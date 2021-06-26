import 'package:flutter/material.dart';
import 'package:weather_app/screen/home_screen.dart';

class Weather {
  double? latitude;
  double? longitude;
  List<Weather>? forecast;
  String? main;
  String? description;
  String? icon;
  String? city;
  String? country;
  int? sunrise;
  int? sunset;
  int? time;
  int? humidity;
  double? temperature;
  Temperature? minTemperature;
  Temperature? maxTemperature;
  double? windSpeed;
  Weather({
    this.latitude,
    this.longitude,
    this.forecast,
    this.main,
    this.description,
    this.icon,
    this.city,
    this.country,
    this.sunrise,
    this.sunset,
    this.time,
    this.humidity,
    this.temperature,
    this.minTemperature,
    this.maxTemperature,
    this.windSpeed,
  });

  factory Weather.fromMap(Map map) {
    final weather = map['weather'][0];
    return Weather(
        main: weather['main'],
        description: weather['description'],
        icon: weather['icon'],
        longitude: map['coord']['lon'],
        latitude: map['coord']['lat'],
        time: map['dt'],
        humidity: map['main']['humidity'],
        sunrise: map['sys']['sunrise'],
        sunset: map['sys']['sunset'],
        country: map['sys']['country'],
        city: map['name'],
        temperature: map['main']['temp'],
        maxTemperature: Temperature(intToDouble(map['main']['temp_max'])),
        minTemperature: Temperature(intToDouble(map['main']['temp'])),
        windSpeed: intToDouble(map['wind']['speed']));
  }

  List<Weather> weatherForecast(Map<String, dynamic> map) {
    List<Weather> weather = [];
    for (var item in map['list']) {
      weather.add(Weather(
          time: item['dt'],
          temperature: item['main']['temp'],
          icon: item['weather'][0]['icon']));
    }
    return weather;
  }
}

//  IconData getIconData(){
//     switch(iconCode){
//       case '01d': return WeatherIcons.clear_day;
//       case '01n': return WeatherIcons.clear_night;
//       case '02d': return WeatherIcons.few_clouds_day;
//       case '02n': return WeatherIcons.few_clouds_day;
//       case '03d':
//       case '04d':
//         return WeatherIcons.clouds_day;
//       case '03n':
//       case '04n':
//         return WeatherIcons.clear_night;
//       case '09d': return WeatherIcons.shower_rain_day;
//       case '09n': return WeatherIcons.shower_rain_night;
//       case '10d': return WeatherIcons.rain_day;
//       case '10n': return WeatherIcons.rain_night;
//       case '11d': return WeatherIcons.thunder_storm_day;
//       case '11n': return WeatherIcons.thunder_storm_night;
//       case '13d': return WeatherIcons.snow_day;
//       case '13n': return WeatherIcons.snow_night;
//       case '50d': return WeatherIcons.mist_day;
//       case '50n': return WeatherIcons.mist_night;
//       default: return WeatherIcons.clear_day;
//     }
//   }
// }

intToDouble(dynamic val) {
  if (val.runtimeType == double) {
    return val;
  } else if (val.runtimeType == int) {
    return val.toDouble();
  } else {
    throw new Exception("value is not of type 'int' or 'double' got type '" +
        val.runtimeType.toString() +
        "'");
  }
}

enum TemperatureUnit { kelvin, celsius, fahrenheit }

class Temperature {
  final double _kelvin;

  Temperature(this._kelvin);

  double get kelvin => _kelvin;

  double get celsius => _kelvin - 273.15;

  double get fahrenheit => _kelvin * (9 / 5) - 459.67;

  double as(TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.kelvin:
        return this.kelvin;
      case TemperatureUnit.celsius:
        return this.celsius;
      case TemperatureUnit.fahrenheit:
        return this.fahrenheit;
    }
  }
}
