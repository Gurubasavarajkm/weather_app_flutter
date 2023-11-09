import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/hourly_horecast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
import 'package:intl/intl.dart';


class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
 late final Future<Map<String, dynamic>> weather;
  @override
  void initState()
  {
    super.initState();
    weather = getWeatherAPI();
  }


  Future<Map<String, dynamic>> getWeatherAPI() async
  {
    String cityName = "Davangere,in";
    try {
    final res = await http.get(
      Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKEY"
      ),
      );

      final data = jsonDecode(res.body);
      return data;
      }
  catch (e) {
        throw "An unexpected Error Occured";
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Weather App',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  getWeatherAPI();
                });
              },
              iconSize: 28,
            )
          ],
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: getWeatherAPI(),
          builder: (context, snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting)
          {
            return const Center(child: CircularProgressIndicator());
          }

          if(snapshot.hasError)
          {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;

          final currentData = data['list'][0];
          final currentTemp = currentData['main']['temp'];
          final currenSKY = currentData['weather'][0]['main'];
          final currentPressure = currentData['main']['pressure'];
          final currentHumidity = currentData['main']['humidity'];
          final currentWindSpeed = currentData['wind']['speed'];
          
            return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child:  Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                             '${(currentTemp - 273.15).toStringAsFixed(0)}°C ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                             Icon(
                              currenSKY == 'Clouds' || currenSKY == 'Rain'
                              ? Icons.cloud : Icons.sunny,
                              size: 50,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                             Text(
                              currenSKY,
                              style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Hourly Forecast",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
              
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) { 
                    final hourlySky = data['list'][index+1]['weather'][0]['main'];
                    final hourlyTemp = data['list'][index+1]['main']['temp'];

                    final time = DateTime.parse(data['list'][index+2]['dt_txt']);
                  return HourlyForecast(DateFormat.j().format(time),
                  hourlySky == 'Clouds' || hourlySky == 'Rain' ? Icons.cloudy_snowing : Icons.sunny,
                   '${(hourlyTemp - 272.15).toStringAsFixed(0)} °C'
                   );
                  }
                  ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Additional Information", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
               AdditionalInfo(icon: Icons.water_drop,label:"Humidity", temp: currentHumidity.toString(),),
               AdditionalInfo(icon: Icons.wind_power_sharp,label: "Wind Speed", temp: currentWindSpeed.toString()),
               AdditionalInfo(icon: Icons.water,label: "Pressure", temp: currentPressure.toString(),),
                ],
              ),
            ],
          ),
                  );
          }
        )
    );
  }
}

class AdditionalInfo extends StatelessWidget {
  final String label;
  final IconData icon;
  final String temp;
  const AdditionalInfo({
    super.key,
    required this.label,
    required this.icon,
    required this.temp
  });
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Icon(icon, size: 22,),
          const SizedBox(
            height: 10,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(temp, style: const TextStyle(fontSize: 18, ),)
        ],
      );
  }
}