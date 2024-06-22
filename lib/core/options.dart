import 'package:tldts/core/looup/interface.dart';

class Options extends SuffixLookupOptions {
  final bool detectIp;
  final bool extractHostname;
  final bool mixedInputs;
  final List<String>? validHosts;
  final bool validateHostname;

  Options({
    super.allowIcannDomains = true,
    super.allowPrivateDomains = false,
    this.detectIp = true,
    this.extractHostname = true,
    this.mixedInputs = true,
    this.validHosts,
    this.validateHostname = true,
  });

  Options copyWith(Options? options) {
    return Options(
      allowIcannDomains: options?.allowIcannDomains ?? allowIcannDomains,
      allowPrivateDomains: options?.allowPrivateDomains ?? allowPrivateDomains,
      detectIp: options?.detectIp ?? detectIp,
      extractHostname: options?.extractHostname ?? extractHostname,
      mixedInputs: options?.mixedInputs ?? mixedInputs,
      validHosts: options?.validHosts ?? validHosts,
      validateHostname: options?.validateHostname ?? validateHostname,
    );
  }

  static getDefaultOptions(Options? options) {
    if (options == null) {
      return Options();
    }
    return Options().copyWith(options);
  }
}
