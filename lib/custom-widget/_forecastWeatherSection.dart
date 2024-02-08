import 'package:flutter/material.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/helpper_function.dart';

Widget forecastWeatherSection(WeatherProvider provider, BuildContext context) {
  final forecastItemList = provider.forecastWeather!.list!;
  return Column(
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text('Today',style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),),
          ],
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: forecastItemList.length,
          itemBuilder: (context, index) {
            final item = forecastItemList[index];
            return Card(
              color: Colors.grey.shade700,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(dateFormattedDateTime(item.dt!, pattern: 'EEE HH:mm')),
                    // const Icon(Icons.sunny,color: Colors.indigo,),
                    Flexible(
                        child: Image.network(
                            '$iconUrlPrefix${item.weather![0].icon}$iconUrlSuffix')),
                    Text(
                        '${item.main!.tempMax!.toStringAsFixed(0)}/${item.main!.tempMin!.toStringAsFixed(0)}$degree${provider.unitSymbol}'),
                    Text(item.weather![0].description!),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
