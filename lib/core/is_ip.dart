bool isProbablyIpv4(String hostname) {
  // Cannot be shorter than 1.1.1.1
  if (hostname.length < 7) {
    return false;
  }
  // Cannot be longer than: 255.255.255.255
  if (hostname.length > 15) {
    return false;
  }
  int numberOfDots = 0;
  for (int i = 0; i < hostname.length; i++) {
    int code = hostname.codeUnitAt(i);
    if (code == 46) {
      // '.'
      numberOfDots++;
    } else if (code < 48 || code > 57) {
      // '0' and '9'
      return false;
    }
  }
  return (numberOfDots == 3 &&
          hostname.codeUnitAt(0) != 46 && // '.'
          hostname.codeUnitAt(hostname.length - 1) != 46 // '.'
      );
}

bool isProbablyIpv6(String hostname) {
  if (hostname.length < 3) {
    return false;
  }
  int start = hostname.startsWith('[') ? 1 : 0;
  int end = hostname.length;
  if (hostname[end - 1] == ']') {
    end -= 1;
  }
  // We only consider the maximum size of a normal IPV6. Note that this will
  // fail on so-called "IPv4 mapped IPv6 addresses" but this is a corner-case
  // and a proper validation library should be used for these.
  if (end - start > 39) {
    return false;
  }
  bool hasColon = false;
  for (; start < end; start += 1) {
    int code = hostname.codeUnitAt(start);
    if (code == 58) {
      // ':'
      hasColon = true;
    } else if (!((code >= 48 && code <= 57) || // 0-9
            (code >= 97 && code <= 102) || // a-f
            (code >= 65 && code <= 90) // A-F
        )) {
      return false;
    }
  }
  return hasColon;
}

bool isIp(String hostname) {
  return isProbablyIpv4(hostname) || isProbablyIpv6(hostname);
}
