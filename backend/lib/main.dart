import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<void> runServer() async {
  const nasaApi = '8hZXdZ7rKPkWyjnsT33McdkB9WaeAebqD0OoHfR1';

  // Add CORS Middleware
  var corsMiddleware = corsHeaders(headers: {
    'Access-Control-Allow-Origin': '*', 
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS', // Allowed methods
  });

  // Middleware for logging requests
  var pipeline = const Pipeline()
      .addMiddleware(corsMiddleware) // CORS Middleware
      .addMiddleware(logRequests());

  // API Handler for NASA data
  var apiHandler = (Request request) async {
    if (request.url.path == 'api/nasa') {
      var nasaApiUrl = 'https://api.nasa.gov/planetary/apod?api_key=$nasaApi';
      var response = await http.get(Uri.parse(nasaApiUrl));
      if (response.statusCode == 200) {
        return Response.ok(response.body,
            headers: {'Content-Type': 'application/json'});
      } else {
        return Response.internalServerError(
            body: 'Error fetching data from NASA API');
      }
    } else {
      return Response.notFound('Not Found');
    }
  };

  // Static file handler
  var staticHandler =
      createStaticHandler('public', defaultDocument: 'index.html');

  // Favicon handler
  var faviconHandler = (Request request) {
    if (request.url.path == 'favicon.ico') {
      var file = File('public/favicon.ico');
      if (file.existsSync()) {
        return Response.ok(file.readAsBytesSync(),
            headers: {'Content-Type': 'image/x-icon'});
      } else {
        return Response.notFound('Favicon not found');
      }
    }
    return Response.notFound('Not Found');
  };

  // Cascade requests
  var cascade =
      Cascade().add(apiHandler).add(faviconHandler).add(staticHandler);

  // Start server
  var server =
      await io.serve(pipeline.addHandler(cascade.handler), 'localhost', 8081);
  print('Server running on http://${server.address.host}:${server.port}');
}
