// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'additiona_info.dart';
import 'hourly_forecast.dart';
import 'package:http/http.dart' as http;

import 'secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
late  Future<Map <String,dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
            'http://api.openweathermap.org/data/2.5/forecast?q=Hyderabad&APPID=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'error occured';
      }
//temp = data['list'][0]['main']['temp'];
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final data = snapshot.data!;
          final currWeather = data['list'][0];
          final currTemp = currWeather['main']['temp'];
          final currSky = currWeather['weather'][0]['main'];
          final currHumidity = currWeather['main']['humidity'];
          final currWind = currWeather['wind']['speed'];
          final currPressure = currWeather['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "$currTemp K",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Icon(
                          currSky == "Clouds" || currSky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          size: 45,
                        ),
                        SizedBox(height: 10),
                        Text(
                          currSky,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Hourly Forecast",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(height: 15),
              
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        final hourlyTemp = data['list'][index + 1]['main']['temp'];
                        final hourlySky = data['list'][index + 1]['weather'][0]['main'];
                    final time =DateTime.parse( hourlyForecast['dt_txt'].toString());
                        return HourlyForecast(
                            time: DateFormat.j().format(time),
                            temparature: hourlyTemp.toString(),
                            icon:
                                hourlySky == "Clouds" || hourlySky == "Rain"
                                    ? Icons.cloud
                                    : Icons.sunny);
                      },
                      itemCount: 5,
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currHumidity.toString(),
                    ),
                    AdditionalInfo(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currWind.toString(),
                    ),
                    AdditionalInfo(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currPressure.toString(),
                    ),
                  ],
                ),Spacer()
              ],
            ),
          );
        },
      ),
    );
  }
}
