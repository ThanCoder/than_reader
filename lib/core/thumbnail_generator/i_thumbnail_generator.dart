abstract class IThumbnailGenerator {
  Future<bool> generate(
    String inputPath,
    String outPath, {
    int pageIndex = 0,
    int width = 200,
    int height = 200,
    int quality = 70,
    String? password,
  });
}
