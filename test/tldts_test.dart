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
