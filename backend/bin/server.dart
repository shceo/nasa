import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart'
    as http; // Подключаем http для запросов к API NASA
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

void main() async {
  // Middleware для логирования запросов
  var pipeline = const Pipeline().addMiddleware(logRequests());

  const NasaApi = "8hZXdZ7rKPkWyjnsT33McdkB9WaeAebqD0OoHfR1";
  // Обработчик для API NASA
  var apiHandler = (Request request) async {
    if (request.url.path == 'api/nasa') {
      // URL NASA API (например, Picture of the Day)
      var nasaApiUrl = 'https://api.nasa.gov/planetary/apod?api_key=${NasaApi}';

      var response = await http.get(Uri.parse(nasaApiUrl));

      if (response.statusCode == 200) {
        // Возвращаем данные с NASA API на фронтенд
        return Response.ok(response.body,
            headers: {'Content-Type': 'application/json'});
      } else {
        // Если произошла ошибка при запросе к NASA API
        return Response.internalServerError(
            body: 'Error fetching data from NASA API');
      }
    } else {
      return Response.notFound('Not Found');
    }
  };

  // Обработчик статических файлов (если нужны, например, изображения)
  var staticHandler = createStaticHandler('public');

  // Объединяем обработчики API и статических файлов
  var cascade = Cascade().add(apiHandler).add(staticHandler);

  // Запуск сервера
  var server =
      await io.serve(pipeline.addHandler(cascade.handler), 'localhost', 8080);
  print('Server running on http://${server.address.host}:${server.port}');
}
