import 'dart:io';

import 'package:path/path.dart' as path_lib;

File loadImage(String relativePath) {
  print("loading image...");

  Directory root = Directory(path_lib.current);
  String filePath = path_lib.join(root.path, relativePath);
  filePath = path_lib.normalize(filePath);

  return File(filePath);
}
