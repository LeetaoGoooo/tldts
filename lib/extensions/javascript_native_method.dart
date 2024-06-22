extension JavaScriptLikeSubstring on String {
  String jsSubstring(int startIndex, [int? endIndex]) {
    int length = this.length;

    // Handle negative start index
    if (startIndex < 0) {
      startIndex = length + startIndex;
      if (startIndex < 0) startIndex = 0;
    }

    // If no end index is provided, use the string length
    endIndex ??= length;

    // Handle negative end index
    if (endIndex < 0) {
      endIndex = length + endIndex;
      if (endIndex < 0) endIndex = 0;
    }

    // Ensure start index is not greater than end index
    if (startIndex > endIndex) {
      int temp = startIndex;
      startIndex = endIndex;
      endIndex = temp;
    }

    // Ensure indices are within valid range
    startIndex = startIndex.clamp(0, length);
    endIndex = endIndex.clamp(0, length);

    return this.substring(startIndex, endIndex);
  }
}
