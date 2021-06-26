import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weather_app/location/location_service.dart';
import 'package:weather_app/model/weather.dart';
import 'package:weather_app/network/network_request.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static Location location = new Location();
  static bool? _serviceEnabled;
  static PermissionStatus? _permissionStatus;
  late LocationData currentPosition;
  getUserLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }
    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
    currentPosition = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        currentPosition = currentLocation;
      });
    });
  }

  @override
  void initState() {
    NetworkRequest.fetchWeatherData();
    getUserLocation();
    super.initState();
  }

  get latitude => currentPosition.latitude;
  get longitude => currentPosition.longitude;

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('EE, HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';
    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff1c1f32),
        body: FutureBuilder<Weather>(
            future: NetworkRequest.fetchWeatherData(
                latitude: latitude, longitude: longitude),
            builder: (context, snapshot) {
              final w = snapshot.data;
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return Column(children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        w!.city! + ", " + w.country!,
                        style: TextStyle(fontSize: 28),
                      )),
                ),
                Expanded(
                  child: Text(
                    readTimestamp(
                      w.time!,
                    ),
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Temp'),
                    Text('Wind'),
                    Text('Humidity'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(w.temperature!.toStringAsFixed(0) + '°'),
                    Text(w.windSpeed!.toStringAsFixed(0)),
                    Text(w.humidity!.toStringAsFixed(0) + '%'),
                  ],
                ),
                Spacer()
              ]);
            }),
      ),
    );
  }
}

class _IconData extends IconData {
  const _IconData(int codePoint)
      : super(
          codePoint,
          fontFamily: 'WeatherIcons',
        );
}

class WeatherIcons {
  static const IconData clear_day = const _IconData(0xf00d);
  static const IconData clear_night = const _IconData(0xf02e);
}
