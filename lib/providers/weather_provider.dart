import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/forecast_weather.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/helpper_function.dart';

enum LocationConversionStatus {
  success, failed,
}
class WeatherProvider extends ChangeNotifier {
  CurrentWeather? currentWeather;
  ForecastWeather? forecastWeather;
  String unit = metric;
  String unitSymbol = celsius;
  double latitude = 18.24, longitude = 54.05;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/';
  bool shouldGetLocationFromCityName=false;
  bool get hasDatsLoaded => currentWeather != null && forecastWeather != null;
  Future<void> getData() async {
    if(!shouldGetLocationFromCityName){
      final position = await _determinePosition();
      latitude = position.latitude;
      longitude = position.longitude;
    }
    await _getCurrentData();
    await _getForecastData();
  }

  Future<void> getTempUnitFromPref() async {
    final status = await getTempUnitStatus();
    unit = status ? imperial : metric;
    unitSymbol = status ? fahrenheit : celsius;
  }

  Future<void> _getCurrentData() async {
    await getTempUnitFromPref();
    final endUrl =
        'weather?lat=$latitude&lon=$longitude&appid=$weatherApiKey&units=$unit';
    final url = Uri.parse('$baseUrl$endUrl');
    try {
      final response = await http.get(url);
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        currentWeather = CurrentWeather.fromJson(json);
        notifyListeners();
      } else {
        print(json['message']);
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _getForecastData() async {
    await getTempUnitFromPref();
    final endUrl =
        'forecast?lat=$latitude&lon=$longitude&appid=$weatherApiKey&units=$unit';
    final url = Uri.parse('$baseUrl$endUrl');
    try {
      final response = await http.get(url);
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        forecastWeather = ForecastWeather.fromJson(json);
        notifyListeners();
      } else {
        log(json['message']);
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<LocationConversionStatus> convertCityToLatLog(String city) async {
    try {
      final locationList = await geo.locationFromAddress(city);
      if(locationList.isNotEmpty){
        final location=locationList.first;
        latitude=location.latitude;
        longitude=location.longitude;
        shouldGetLocationFromCityName=true;
        getData();
        return
        LocationConversionStatus.success;
      }else{
       return LocationConversionStatus.failed;
      }
    } catch (error) {
      log(error.toString());
      return LocationConversionStatus.failed;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
