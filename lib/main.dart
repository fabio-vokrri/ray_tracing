import 'dart:io';

import 'package:ray_tracing/utility/color.dart';

void main(List<String> args) async {
  int width = 256;
  int heigth = 256;

  // creates a buffer that will be written in the output image file (PPM format)
  StringBuffer content = StringBuffer("P3\n$width $heigth\n255\n");

  // standard "hello world" for computer graphics
  for (int i = 0; i < heigth; i++) {
    stdout.write("\rLines remaining: ${heigth - i}\n");
    for (int j = 0; j < width; j++) {
      Color pixelColor = Color(i / (width - 1), j / (heigth - 1), 0);
      content.write(pixelColor); // toString method automatically invoked
    }
  }

  stdout.write("\n\rDONE!\n");

  // creates the image output file
  File image = File("output_image.ppm");
  // and writes the content buffer in it
  await image.writeAsString(content.toString());
}

void writeColor(Color pixelColor) {}
