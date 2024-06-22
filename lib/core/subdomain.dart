// Returns the subdomain of a hostname string
import 'package:tldts/extensions/javascript_native_method.dart';

String getSubdomain(String hostname, String domain) {
  // If `hostname` and `domain` are the same, then there is no sub-domain
  if (domain.length == hostname.length) {
    return '';
  }
  return hostname.jsSubstring(0, -domain.length - 1);
}
