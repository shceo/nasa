import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

void main() async {
  // Middleware для логгирования запросов
  var pipeline = const Pipeline().addMiddleware(logRequests());

  // Создаем обработчик для статических файлов (например, HTML, CSS)
  var handler = pipeline.addHandler(createStaticHandler('public', defaultDocument: 'index.html'));

  // Запуск сервера
  var server = await io.serve(handler, 'localhost', 8080);
  print('Server is running on http://${server.address.host}:${server.port}');
}
