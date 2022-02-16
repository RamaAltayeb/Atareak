String durationTransform(double seconds) {
  final duration = Duration(seconds: seconds.toInt());
  final List<String> time = duration.toString().split(':');
  return '${time[0]}:${time[1]}:${time[2].substring(0, 2)}';
}

String distanceTransform(double meters) {
  final double km = meters / 1000;
  return '${km.toStringAsFixed(2)}كم';
}
