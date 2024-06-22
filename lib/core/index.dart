import 'package:tldts/core/domain.dart';
import 'package:tldts/core/domain_without_suffix.dart';
import 'package:tldts/core/extract_hostname.dart';
import 'package:tldts/core/is_ip.dart';
import 'package:tldts/core/is_valid.dart';
import 'package:tldts/core/looup/interface.dart';
import 'package:tldts/core/options.dart';
import 'package:tldts/core/subdomain.dart';

class Result extends PublicSuffix {
  // `hostname` is either a registered name (including but not limited to a
  // hostname), or an IP address. IPv4 addresses must be in dot-decimal
  // notation, and IPv6 addresses must be enclosed in brackets ([]). This is
  // directly extracted from the input URL.
  String? hostname;

  // Is `hostname` an IP? (IPv4 or IPv6)
  bool? isIp;

  // `hostname` split between subdomain, domain and its public suffix (if any)
  String? subdomain;
  String? domain;
  String? domainWithoutSuffix;

  Result({
    this.hostname,
    this.isIp,
    this.subdomain,
    this.domain,
    this.domainWithoutSuffix,
  });
}

enum FLAG { hostname, isValid, publicSuffix, domain, subdomain, all }

typedef SuffixLookupFunction = void Function(
    String url, SuffixLookupOptions options, PublicSuffix publicSuffix);

Result parseImpl(String url, FLAG step, SuffixLookupFunction suffixLookup,
    [Options? partialOptions]) {
  Result result = Result();

  Options options = Options.getDefaultOptions(partialOptions);
  // Very fast approximate check to make sure `url` is a string. This is needed
  // because the library will not necessarily be used in a typed setup and
  // values of arbitrary types might be given as argument.
  if (url.runtimeType != String) {
    return result;
  }

  // Extract hostname from `url` only if needed. This can be made optional
  // using `options.extractHostname`. This option will typically be used
  // whenever we are sure the inputs to `parse` are already hostnames and not
  // arbitrary URLs.
  //
  // `mixedInput` allows to specify if we expect a mix of URLs and hostnames
  // as input. If only hostnames are expected then `extractHostname` can be
  // set to `false` to speed-up parsing. If only URLs are expected then
  // `mixedInputs` can be set to `false`. The `mixedInputs` is only a hint
  // and will not change the behavior of the library.
  if (!options.extractHostname) {
    result.hostname = url;
  } else if (options.mixedInputs) {
    result.hostname = extractHostname(url, isValidHostname(url));
  } else {
    result.hostname = extractHostname(url, false);
  }

  if (step == FLAG.hostname || result.hostname == null) {
    return result;
  }

  // Check if `hostname` is a valid ip address
  if (options.detectIp) {
    result.isIp = isIp(result.hostname!);
    if (result.isIp!) {
      return result;
    }
  }

  // Perform optional hostname validation. If hostname is not valid, no need to
  // go further as there will be no valid domain or sub-domain.
  if (options.validateHostname &&
      options.extractHostname &&
      !isValidHostname(result.hostname!)) {
    result.hostname = null;
    return result;
  }

  // Extract public suffix
  suffixLookup(result.hostname!, options, result);
  if (step == FLAG.publicSuffix || result.publicSuffix == null) {
    return result;
  }

  // Extract domain
  result.domain = getDomain(result.publicSuffix!, result.hostname!, options);
  if (step == FLAG.domain || result.domain == null) {
    return result;
  }

  // Extract subdomain
  result.subdomain = getSubdomain(result.hostname!, result.domain!);
  if (step == FLAG.subdomain) {
    return result;
  }

  // Extract domain without suffix
  result.domainWithoutSuffix = getDomainWithoutSuffix(
    result.domain!,
    result.publicSuffix!,
  );

  return result;
}
