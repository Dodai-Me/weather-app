import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  final Map<String, dynamic> locationWeather;

  const LocationScreen({
    super.key,
    required this.locationWeather
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  late int temperature;
  late String weatherIcon;
  late String weatherInfo;
  late String cityName;
  WeatherModel weather = WeatherModel();
  
  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData){
    setState(() {
        double temp = weatherData['main']['temp'];
        temperature = temp.toInt();
        weatherInfo = weather.getMessage(temperature);
        weatherIcon = weather.getWeatherIcon(weatherData['weather'][0]['id']);
        cityName = weatherData['name'];
    });
  }

  AssetImage weatherBackground(){
    if(weatherIcon == '🌩' || weatherIcon == '🌧' || weatherIcon == '☔️'){
      return const AssetImage('images/rain_background.jpg');
    }

    else if(weatherIcon == '☃️'){
      return const AssetImage('images/snow_background.jpg');
    }

    else if(weatherIcon == '🌫'){
      return const AssetImage('images/wind_background.jpg');
    }

    else if(weatherIcon == '☀️'){
      return const AssetImage('images/sun_background.jpg');
    }

    else if(weatherIcon == '☁️'){
      return const AssetImage('images/cloud_background.jpg');
    }

    return const AssetImage('images/rain_background.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: weatherBackground(),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop
            ),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async{
                      Map<String, dynamic> weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async{
                      String typedName = await Navigator.push(context, MaterialPageRoute(builder: (context) => const CityScreen()));

                      if(typedName.isNotEmpty){
                        try{
                          dynamic weatherData = await weather.getCityWeather(typedName);
                          updateUI(weatherData);
                        }
                        catch (e) {
                          print('Error getting weather: $e');
                        }
                      }
                      else{
                        print('City name cannot be empty');
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherInfo in $cityName',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}