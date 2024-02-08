import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/helpper_function.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool status = false;
  @override
  void initState() {
    getTempUnitStatus().then((value) {
      setState(() {
        status = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
              title: const Text('Show temperature in fahrenheit'),
              subtitle: const Text('Default is Celsius'),
              value: status,
              onChanged: (value) async {
                status = value;
                setState(() {});
                await setTempUnitStatus(status);
                if (mounted) {
                  Provider.of<WeatherProvider>(context, listen: false)
                      .getData();
                }
              }),
        ],
      ),
    );
  }
}
