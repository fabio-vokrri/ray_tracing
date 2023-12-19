import 'dart:io';

void main(List<String> args) async {
  int width = 256;
  int heigth = 256;

  StringBuffer content = StringBuffer("P3\n$width $heigth\n255\n");

  for (int i = 0; i < heigth; i++) {
    stderr.write("\rLines remaining: ${heigth - i}\n");
    for (int j = 0; j < width; j++) {
      int r = (i / (width - 1) * 255.999).toInt();
      int g = (j / (heigth - 1) * 255.999).toInt();
      int b = 0;

      content.write("$r $g $b\n");
    }
  }

  stderr.write("\rDone!\n");

  File image = File("output_image.ppm");
  await image.writeAsString(content.toString());
}
