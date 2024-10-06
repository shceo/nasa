import 'dart:convert'; // Для работы с JSON
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<void> runServer() async {
  const nasaApi = '8hZXdZ7rKPkWyjnsT33McdkB9WaeAebqD0OoHfR1';

  // Добавляем CORS Middleware
  var corsMiddleware = corsHeaders(headers: {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  });

  var pipeline = const Pipeline()
      .addMiddleware(corsMiddleware)
      .addMiddleware(logRequests());

  // Обработчик API для данных о солнечных вспышках, геомагнитных бурях и резких изменениях
  var apiHandler = (Request request) async {
    print('Received request for: ${request.url.path}');

    final now = DateTime.now();
    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final startDate = formattedDate;
    final endDate = formattedDate;

    if (request.url.path == 'api/solar-flares') {
      print('Fetching Solar Flares data...');

      var solarFlaresUrl =
          'https://api.nasa.gov/DONKI/FLR?startDate=$startDate&endDate=$endDate&api_key=$nasaApi';
      
      var solarResponse = await http.get(Uri.parse(solarFlaresUrl));
      print('Solar Flares API Response: ${solarResponse.statusCode}');

      if (solarResponse.statusCode == 200) {
        List<dynamic> solarData = json.decode(solarResponse.body);
        
        // Обработка солнечных вспышек
        var filteredSolarData = solarData.map((flare) {
          return {
            'flrID': flare['flrID'],
            'instruments': flare['instruments']
                .map((inst) => inst['displayName'])
                .toList(),
            'beginTime': flare['beginTime'],
            'peakTime': flare['peakTime'],
            'endTime': flare['endTime'],
            'classType': flare['classType'],
            'sourceLocation': flare['sourceLocation'],
            'activeRegionNum': flare['activeRegionNum'],
            'note': flare['note'],
            'link': flare['link'],
          };
        }).toList();

        return Response.ok(
            json.encode({'solarFlares': filteredSolarData}),
            headers: {'Content-Type': 'application/json'});
      } else {
        return Response.internalServerError(
            body: 'Error fetching solar flares data from NASA API');
      }
    }

    if (request.url.path == 'api/geomagneticstorms') {
      print('Fetching Geomagnetic Storms data...');

      var geomagneticStormUrl =
          'https://api.nasa.gov/DONKI/GST?startDate=$startDate&endDate=$endDate&api_key=$nasaApi';

      var geomagneticResponse = await http.get(Uri.parse(geomagneticStormUrl));
      print('Geomagnetic Storms API Response: ${geomagneticResponse.statusCode}');

      if (geomagneticResponse.statusCode == 200) {
        List<dynamic> geomagneticData = json.decode(geomagneticResponse.body);
        
        // Обработка геомагнитных бурь
        var filteredGeomagneticData = geomagneticData.map((storm) {
          return {
            'gstID': storm['gstID'],
            'startTime': storm['startTime'],
            'kpIndex': storm['allKpIndex'].map((kp) {
              return {
                'observedTime': kp['observedTime'],
                'kpIndex': kp['kpIndex'],
                'source': kp['source']
              };
            }).toList(),
            'linkedEvents': storm['linkedEvents'],
            'link': storm['link'],
          };
        }).toList();

        return Response.ok(
            json.encode({'geomagneticStorms': filteredGeomagneticData}),
            headers: {'Content-Type': 'application/json'});
      } else {
        return Response.internalServerError(
            body: 'Error fetching geomagnetic storms data from NASA API');
      }
    }

    if (request.url.path == 'api/rapid-bursts') {
      print('Fetching Rapid Bursts Events data...');

      var rapidBurstsUrl =
          'https://api.nasa.gov/DONKI/RBE?startDate=$startDate&endDate=$endDate&api_key=$nasaApi';

      var rapidBurstsResponse = await http.get(Uri.parse(rapidBurstsUrl));
      print('Rapid Bursts Events API Response: ${rapidBurstsResponse.statusCode}');

      if (rapidBurstsResponse.statusCode == 200) {
        List<dynamic> rapidBurstsData = json.decode(rapidBurstsResponse.body);
        
        // Обработка резких изменений
        var filteredRapidBurstsData = rapidBurstsData.map((burst) {
          return {
            'rbeID': burst['rbeID'],
            'beginTime': burst['beginTime'],
            'peakTime': burst['peakTime'],
            'endTime': burst['endTime'],
            'classType': burst['classType'],
            'sourceLocation': burst['sourceLocation'],
            'note': burst['note'],
            'link': burst['link'],
          };
        }).toList();

        return Response.ok(
            json.encode({'rapidBursts': filteredRapidBurstsData}),
            headers: {'Content-Type': 'application/json'});
      } else {
        return Response.internalServerError(
            body: 'Error fetching rapid bursts data from NASA API');
      }
    }

    print('Request not found: ${request.url.path}');
    return Response.notFound('Not Found');
  };

  // Обработчик статических файлов
  var staticHandler =
      createStaticHandler('public', defaultDocument: 'index.html');

  // Обработчик для favicon
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

  // Каскад запросов
  var cascade =
      Cascade().add(apiHandler).add(faviconHandler).add(staticHandler);

  var server =
      await io.serve(pipeline.addHandler(cascade.handler), 'localhost', 3000);
  print('Server running on http://${server.address.host}:${server.port}');
}
