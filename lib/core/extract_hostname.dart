/// Extracts the hostname from a given URL.
///
/// @param url - URL we want to extract a hostname from.
/// @param urlIsValidHostname - hint from caller; true if `url` is already a valid hostname.
String? extractHostname(String url, bool urlIsValidHostname) {
  int start = 0;
  int end = url.length;
  bool hasUpper = false;

  // If url is not already a valid hostname, then try to extract hostname.
  if (!urlIsValidHostname) {
    // Special handling of data URLs
    if (url.startsWith('data:')) {
      return null;
    }

    // Trim leading spaces
    while (start < url.length && url.codeUnitAt(start) <= 32) {
      start += 1;
    }

    // Trim trailing spaces
    while (end > start + 1 && url.codeUnitAt(end - 1) <= 32) {
      end -= 1;
    }

    // Skip scheme.
    if (url.codeUnitAt(start) == 47 /* '/' */ &&
        url.codeUnitAt(start + 1) == 47 /* '/' */) {
      start += 2;
    } else {
      final indexOfProtocol = url.indexOf(':/', start);
      if (indexOfProtocol != -1) {
        // Implement fast-path for common protocols. We expect most protocols
        // should be one of these 4 and thus we will not need to perform the
        // more expansive validity check most of the time.
        final protocolSize = indexOfProtocol - start;
        final c0 = url.codeUnitAt(start);
        final c1 = url.codeUnitAt(start + 1);
        final c2 = url.codeUnitAt(start + 2);
        final c3 = url.codeUnitAt(start + 3);
        final c4 = url.codeUnitAt(start + 4);

        if (protocolSize == 5 &&
            c0 == 104 /* 'h' */ &&
            c1 == 116 /* 't' */ &&
            c2 == 116 /* 't' */ &&
            c3 == 112 /* 'p' */ &&
            c4 == 115 /* 's' */) {
          // https
        } else if (protocolSize == 4 &&
            c0 == 104 /* 'h' */ &&
            c1 == 116 /* 't' */ &&
            c2 == 116 /* 't' */ &&
            c3 == 112 /* 'p' */) {
          // http
        } else if (protocolSize == 3 &&
            c0 == 119 /* 'w' */ &&
            c1 == 115 /* 's' */ &&
            c2 == 115 /* 's' */) {
          // wss
        } else if (protocolSize == 2 &&
            c0 == 119 /* 'w' */ &&
            c1 == 115 /* 's' */) {
          // ws
        } else {
          // Check that scheme is valid
          for (int i = start; i < indexOfProtocol; i += 1) {
            final lowerCaseCode = url.codeUnitAt(i) | 32;
            if (!(((lowerCaseCode >= 97 && lowerCaseCode <= 122) || // [a, z]
                (lowerCaseCode >= 48 && lowerCaseCode <= 57) || // [0, 9]
                lowerCaseCode == 46 || // '.'
                lowerCaseCode == 45 || // '-'
                lowerCaseCode == 43))) {
              // '+'
              return null;
            }
          }
        }

        // Skip 0, 1 or more '/' after ':/'
        start = indexOfProtocol + 2;
        while (url.codeUnitAt(start) == 47 /* '/' */) {
          start += 1;
        }
      }
    }

    // Detect first occurrence of '/', '?' or '#'. We also keep track of the
    // last occurrence of '@', ']' or ':' to speed-up subsequent parsing of
    // (respectively), identifier, ipv6 or port.
    int indexOfIdentifier = -1;
    int indexOfClosingBracket = -1;
    int indexOfPort = -1;
    for (int i = start; i < end; i += 1) {
      final code = url.codeUnitAt(i);
      if (code == 35 || // '#'
          code == 47 || // '/'
          code == 63) {
        // '?'
        end = i;
        break;
      } else if (code == 64) {
        // '@'
        indexOfIdentifier = i;
      } else if (code == 93) {
        // ']'
        indexOfClosingBracket = i;
      } else if (code == 58) {
        // ':'
        indexOfPort = i;
      } else if (code >= 65 && code <= 90) {
        hasUpper = true;
      }
    }

    // Detect identifier: '@'
    if (indexOfIdentifier != -1 &&
        indexOfIdentifier > start &&
        indexOfIdentifier < end) {
      start = indexOfIdentifier + 1;
    }

    // Handle ipv6 addresses
    if (url.codeUnitAt(start) == 91 /* '[' */) {
      if (indexOfClosingBracket != -1) {
        return url.substring(start + 1, indexOfClosingBracket).toLowerCase();
      }
      return null;
    } else if (indexOfPort != -1 && indexOfPort > start && indexOfPort < end) {
      // Detect port: ':'
      end = indexOfPort;
    }
  }

  // Trim trailing dots
  while (end > start + 1 && url.codeUnitAt(end - 1) == 46 /* '.' */) {
    end -= 1;
  }

  final hostname =
      start != 0 || end != url.length ? url.substring(start, end) : url;

  if (hasUpper) {
    return hostname.toLowerCase();
  }

  return hostname;
}
