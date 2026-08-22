class ReaderTracking {
  final String fileId;
  final Stopwatch stopwatch = Stopwatch();

  int lastPage;

  ReaderTracking({required this.fileId, required this.lastPage});

  void start() {
    stopwatch.start();
  }

  void pause() {
    stopwatch.stop();
  }

  Duration get elapsed => stopwatch.elapsed;
}
