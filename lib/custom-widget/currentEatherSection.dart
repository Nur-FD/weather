import 'package:flutter/material.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/helpper_function.dart';

Widget currentWeatherSection(WeatherProvider provider, BuildContext context) {
  return Column(
    children: [
      Text(
        dateFormattedDateTime(provider.currentWeather!.dt!),
        // style: Theme.of(context).textTheme.titleLarge,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      Text(
        '${provider.currentWeather!.name},${provider.currentWeather!.sys!.country}',
        // style: Theme.of(context).textTheme.displaySmall,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 40
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           const Flexible(
            // child: Image.network(
            //     '$iconUrlPrefix${provider.currentWeather!.weather![0].icon}$iconUrlSuffix'),
            child: Icon(
              Icons.sunny,
              size: 40,
              color: Colors.yellow,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '${provider.currentWeather!.main!.temp!.toStringAsFixed(0)}$degree${provider.unitSymbol}',
            style: const TextStyle(
              fontSize: 60,
              color: Colors.black,
            ),
          ),
        ],
      ),
      Text(
        'feels like: ${provider.currentWeather!.main!.feelsLike!.toStringAsFixed(0)}$degree${provider.unitSymbol}',
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      Text(
        provider.currentWeather!.weather![0].description!,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    ],
  );
}
