import 'package:tldts/core/looup/fast_path.dart';
import 'package:tldts/core/looup/interface.dart';
import 'package:tldts/data/trie.dart';

enum RuleType { icann, private }

class Match {
  final int index;
  final bool isIcann;
  final bool isPrivate;

  Match({required this.index, required this.isIcann, required this.isPrivate});
}

Match? lookupInTrie(
    List<String> parts, Trie? trie, int index, int allowedMask) {
  Match? result;
  Trie? node = trie;

  while (node != null) {
    // We have a match!
    if (((node[0] as int) & allowedMask) != 0) {
      result = Match(
        index: index + 1,
        isIcann: node[0] == RuleType.icann.index,
        isPrivate: node[0] == RuleType.private.index,
      );
    }

    // No more `parts` to look for
    if (index == -1) {
      break;
    }

    final succ = node[1] as Map<String, Trie>;
    node = succ.containsKey(parts[index]) ? succ[parts[index]] : succ['*'];
    index -= 1;
  }

  return result;
}

void suffixLookup(
    String hostname, SuffixLookupOptions options, PublicSuffix out) {
  if (fastPath(hostname, options, out)) {
    return;
  }

  final hostnameParts = hostname.split('.');
  final allowedMask =
      (options.allowPrivateDomains ? RuleType.private.index : 0) |
          (options.allowIcannDomains ? RuleType.icann.index : 0);

  // Look for exceptions
  final exceptionMatch = lookupInTrie(
    hostnameParts,
    exceptions,
    hostnameParts.length - 1,
    allowedMask,
  );

  if (exceptionMatch != null) {
    out.isIcann = exceptionMatch.isIcann;
    out.isPrivate = exceptionMatch.isPrivate;
    out.publicSuffix =
        hostnameParts.sublist(exceptionMatch.index + 1).join('.');
    return;
  }

  // Look for a match in rules
  final rulesMatch = lookupInTrie(
    hostnameParts,
    rules,
    hostnameParts.length - 1,
    allowedMask,
  );

  if (rulesMatch != null) {
    out.isIcann = rulesMatch.isIcann;
    out.isPrivate = rulesMatch.isPrivate;
    out.publicSuffix = hostnameParts.sublist(rulesMatch.index).join('.');
    return;
  }

  // No match found...
  // Prevailing rule is '*' so we consider the top-level domain to be the
  // public suffix of `hostname` (e.g.: 'example.org' => 'org').
  out.isIcann = false;
  out.isPrivate = false;
  out.publicSuffix = hostnameParts.isNotEmpty ? hostnameParts.last : null;
}
