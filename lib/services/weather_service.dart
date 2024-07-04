import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather1/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {

    //Get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);


    if (placemarks.isEmpty) {
      throw Exception('Could not determine city from current location');
    }

    // In ra tất cả thông tin của Placemark để kiểm tra
    print(placemarks[0]);


    if (placemarks.isEmpty || placemarks[0].locality == null) {
    throw Exception('Could not determine city from current location');
  }
    String? city = placemarks[0].subAdministrativeArea;
    String? cityNameWithoutDiacritics = removeDiacritics(city!);
    cityNameWithoutDiacritics = cityNameWithoutDiacritics.replaceAll('Thanh pho ', '');

    return cityNameWithoutDiacritics;
    // return city ?? "";
  }
}
