extension StringExtension on Duration {
  /// Getter method
  ///
  /// Extract a formatted string for displaying on play overlay
  String get extractTimeString {
    final int hours = this.inHours;
    final int minutes = this.inMinutes.remainder(60);
    final int seconds = this.inSeconds.remainder(60);

    // take 2 digits if int value < 10
    final String formattedMinutes = minutes.toString().padLeft(2, '0');
    final String formattedSeconds = seconds.toString().padLeft(2, '0');

    if (hours >= 1) {
      return "$hours:$formattedMinutes:$formattedSeconds";
    } else {
      return "$minutes:$formattedSeconds";
    }
  }
}
