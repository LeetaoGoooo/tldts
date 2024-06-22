library tldts;

import 'package:tldts/core/index.dart';
import 'package:tldts/core/options.dart';
import 'package:tldts/src/suffix-trie.dart';

Result parse(String url, [Options? options]) {
  return parseImpl(url, FLAG.all, suffixLookup, options);
}
