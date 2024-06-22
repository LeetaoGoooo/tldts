class PublicSuffix {
  bool? isIcann;
  bool? isPrivate;
  String? publicSuffix;

  PublicSuffix({
    this.isIcann,
    this.isPrivate,
    this.publicSuffix,
  });
}

class SuffixLookupOptions {
  bool allowIcannDomains;
  bool allowPrivateDomains;

  SuffixLookupOptions({
    this.allowIcannDomains = true,
    this.allowPrivateDomains = false,
  });
}
