import 'package:tldts/extensions/javascript_native_method.dart';

/// Return the part of domain without suffix.
/// Example: for domain 'foo.com', the result would be 'foo'.
String getDomainWithoutSuffix(
  String domain,
  String suffix,
) {
  // Note: here `domain` and `suffix` cannot have the same length because in
  // this case we set `domain` to `null` instead. It is thus safe to assume
  // that `suffix` is shorter than `domain`.
  return domain.jsSubstring(0, -suffix.length - 1);
}
