import 'package:tldts/core/looup/interface.dart';

bool fastPath(
  String hostname,
  SuffixLookupOptions options,
  PublicSuffix out,
) {
  // Fast path for very popular suffixes; this allows to by-pass lookup
  // completely as well as any extra allocation or string manipulation.
  if (!options.allowPrivateDomains && hostname.length > 3) {
    int last = hostname.length - 1;
    int c3 = hostname.codeUnitAt(last);
    int c2 = hostname.codeUnitAt(last - 1);
    int c1 = hostname.codeUnitAt(last - 2);
    int c0 = hostname.codeUnitAt(last - 3);

    if (c3 == 109 /* 'm' */ &&
            c2 == 111 /* 'o' */ &&
            c1 == 99 /* 'c' */ &&
            c0 == 46 /* '.' */
        ) {
      out.isIcann = true;
      out.isPrivate = false;
      out.publicSuffix = 'com';
      return true;
    } else if (c3 == 103 /* 'g' */ &&
            c2 == 114 /* 'r' */ &&
            c1 == 111 /* 'o' */ &&
            c0 == 46 /* '.' */
        ) {
      out.isIcann = true;
      out.isPrivate = false;
      out.publicSuffix = 'org';
      return true;
    } else if (c3 == 117 /* 'u' */ &&
            c2 == 100 /* 'd' */ &&
            c1 == 101 /* 'e' */ &&
            c0 == 46 /* '.' */
        ) {
      out.isIcann = true;
      out.isPrivate = false;
      out.publicSuffix = 'edu';
      return true;
    } else if (c3 == 118 /* 'v' */ &&
            c2 == 111 /* 'o' */ &&
            c1 == 103 /* 'g' */ &&
            c0 == 46 /* '.' */
        ) {
      out.isIcann = true;
      out.isPrivate = false;
      out.publicSuffix = 'gov';
      return true;
    } else if (c3 == 116 /* 't' */ &&
            c2 == 101 /* 'e' */ &&
            c1 == 110 /* 'n' */ &&
            c0 == 46 /* '.' */
        ) {
      out.isIcann = true;
      out.isPrivate = false;
      out.publicSuffix = 'net';
      return true;
    } else if (c3 == 101 /* 'e' */ && c2 == 100 /* 'd' */ && c1 == 46 /* '.' */
        ) {
      out.isIcann = true;
      out.isPrivate = false;
      out.publicSuffix = 'de';
      return true;
    }
  }

  return false;
}
