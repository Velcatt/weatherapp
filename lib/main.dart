import 'package:flutter/material.dart';
import 'src/form.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async{
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale(); //Ces trois dernières commandes sont nécessaire au bon fonctionnement du picker de date qui se trouve dans le formulaire. Nous avons ici besoin de récupérer les locales du système éxecutant l'appli.
  runApp(MaterialApp(
    home: Scaffold(
        appBar: AppBar(
          title: Text(
              'WeatherApp', //Titre de l'appli qui s'affiche au dessus du formulaire
              style: TextStyle(
                color: Colors.white,
              )
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
              child : MyCustomForm() //Le formulaire est ici placé sur la page, au centre
            ),
        ),
    localizationsDelegates: [ //On utilise la localisation globale pour pouvoir mettre les date pickers en français dans le form
      GlobalMaterialLocalizations.delegate
    ],
    supportedLocales: [
      const Locale('en'),
      const Locale('fr')
    ],
    )
  );
}

