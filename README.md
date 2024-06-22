# tldts - Blazing Fast URL Parsing
`tldts` is a Dart library to extract hostnames, domains, public suffixes, top-level domains and subdomains from URLs, inspired by the [tldts](https://github.com/remusao/tldts) library for JavaScript.

**Features**:
    1. Handles both URLs and hostnames
    2. Full Unicode/IDNA support
    3. Support parsing email addresses
    4. Detect IPv4 and IPv6 addresses
    5. Continuously updated version of the public suffix list

# Install

```dart
dart pub add tldts
```

# Usage

```dart
import 'package:tldts/tldts.dart';
import 'package:test/test.dart';

void main() {
  test('parse url', () {
    final result = parse(
        "https://www.leetao.me/post/242/how-to-release-android-apk-without-sign-using-github-action");

    expect(result.domain, "leetao.me");
    expect(result.domainWithoutSuffix, "leetao");
    expect(result.hostname, "www.leetao.me");
    // expect(result.isIcann, true); # TODO: some issues with this
    expect(result.isIp, false);
    expect(result.isPrivate, false);
    expect(result.publicSuffix, "me");
    expect(result.subdomain, "www");
  });
}
```

## Additional information

**tldts is still under development, so there are likely to be some bugs. Be carefully when using it**


