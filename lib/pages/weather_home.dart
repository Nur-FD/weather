import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:weather_animation/weather_animation.dart';
import 'package:weather_app/custom-widget/_forecastWeatherSection.dart';
import 'package:weather_app/custom-widget/citySearchDelegate.dart';
import 'package:weather_app/custom-widget/currentEatherSection.dart';
import 'package:weather_app/pages/settings_page.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/show_message.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  @override
  void didChangeDependencies() {
    Provider.of<WeatherProvider>(context, listen: false).getData();
    super.didChangeDependencies();
  }
  String imagePath='assets/weather.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
              onPressed: () async {
                final result = await showSearch(
                    context: context, delegate: CitySearchDelegate()) as String;
                if (result.isNotEmpty) {
                  EasyLoading.show(status: 'Please wait');
                  if (mounted) {
                    await Provider.of<WeatherProvider>(context, listen: false)
                        .convertCityToLatLog(result);
                  }
                  if (mounted) {
                    final status = await Provider.of<WeatherProvider>(context,
                            listen: false)
                        .convertCityToLatLog(result);
                    EasyLoading.dismiss();
                    if (status == LocationConversionStatus.failed) {
                      if (mounted) {
                        showMg(context, 'could not find data');
                      }
                    }
                  }
                }
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage())),
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: Stack(
        children: [
          // Container(
          //   height:MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //  decoration: BoxDecoration(
          //    image: DecorationImage(
          //      image: AssetImage(imagePath),
          //      fit:BoxFit.cover,
          //    )
          //  ),
          // ),
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: PageView(
              children: [for (final w in WeatherScene.values) w.sceneWidget],
            ),
          ),
          Consumer<WeatherProvider>(
            builder: (context, provider, child) {
              return provider.hasDatsLoaded
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    currentWeatherSection(provider, context),
                    forecastWeatherSection(provider, context),
                  ],
                ),
              )
                  : const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
