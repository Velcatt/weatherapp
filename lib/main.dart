import 'package:flutter/material.dart';
import 'src/form.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  runApp(MaterialApp(
    home: Scaffold(
        appBar: AppBar(
          title: Text(
              'WeatherApp',
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

