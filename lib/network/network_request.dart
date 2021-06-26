import 'dart:convert';

import 'package:http/http.dart';
import 'package:weather_app/apikey.dart';
import 'package:weather_app/model/weather.dart';

class NetworkRequest {
  static final baseUrl = "http://api.openweathermap.org/data/";

  static Future<Weather> fetchWeatherData(
      {double? latitude, double? longitude}) async {
    final response = await get(Uri.parse(
        baseUrl + '2.5/weather?lat=$latitude&lon=$longitude&appid=$API_KEY'));
    if (response.statusCode == 200) {
      var weather = jsonDecode(response.body);
      print(weather);
      return Weather.fromMap(weather);
    }
    throw Exception('Unable to get data');
  }

  Future getWeatherData(String cityName) async {
    final url = '$baseUrl/data/2.5/weather?q=$cityName&appid=$API_KEY';
    final response = await get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Unable to get data');
    }
    final weatherJson = json.decode(response.body);
    return Weather.fromMap(weatherJson);
  }
}
