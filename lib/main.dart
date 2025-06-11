import 'package:flutter/material.dart';
import 'package:open_meteo/open_meteo.dart';
import 'src/weather.dart';
import 'src/form.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  var request = WeatherRequest(52.52, 13.41, DateTime.utc(2015, 5, 18), DateTime.utc(2015, 5, 21));
  var response = await getResponse(request);
  var data = response.hourlyData[HistoricalHourly.temperature_2m]!;
  var temp = data.values;
  runApp(MaterialApp(
    home: Scaffold(
        appBar: AppBar(
          title: Text(
              'Données Météo',
              style: TextStyle(
                color: Colors.white,
              )
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
              child : MyCustomForm()
            ),
        )
    )
  );
}

