import 'package:flutter/services.dart';

Future<String> fetchFileFromAssets(String fileName) async {
  try {
    return await rootBundle
        .loadString('assets/' + fileName + '.txt')
        .then((file) => file.toString());
  } catch (e) {
    return Future.error('​файл не найден');
  }
}
