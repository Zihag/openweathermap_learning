import 'package:flutter/material.dart';
import 'package:weather1/models/weather_model.dart';
import 'package:weather1/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService('API_KEY');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch(mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloudy.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'rain':
        return 'assets/rainy.json';
      case 'thunder':
        return 'assets/thunder.json';
      default:
        return 'assets/sunny.json';
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fetchWeather();

    print(_weather?.cityName?? "Khong co");
    print(_weather?.temperature?? "Khong co nhiet do");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName?? "Loading city.."),
            
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            Text('${_weather?.temperature.round()}℃'),

            Text(_weather?.mainCondition?? "")
          ],
        ),
      )
    );
  }
}