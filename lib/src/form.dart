import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'weatherView.dart';
import 'weather.dart';
import 'package:intl/intl.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DateTime? startDate;
    DateTime? endDate;
    final latitudeController = TextEditingController();
    final longitudeController = TextEditingController();
    return Form(
      key: _formKey,

        child : SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'exemple : 52.52',
                  labelText: 'Latitude',
                ),
                controller: latitudeController,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null || double.tryParse(value)! > 90.0 || double.tryParse(value)! < -90.0) {
                    return 'Veuillez entrer une latitude';
                  }
                return null;
                }
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'exemple : 13.41',
                  labelText: 'Longitude',
                ),
                controller: longitudeController,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null || double.tryParse(value)! > 180.0 || double.tryParse(value)! < -180.0) {
                    return 'Veuillez entrer une longitude';
                  }
                  return null;
                }
              ),
              DateTimeFormField(
                decoration: const InputDecoration(
                  labelText: 'Date de début',
                ),
                dateFormat: DateFormat.yMMMMd('fr_FR'),
                firstDate: DateTime(1940, 1, 1),
                lastDate: DateTime.now(),
                initialPickerDateTime: DateTime.now(),
                onChanged: (DateTime? value) {
                  startDate = value;
                },
                mode: DateTimeFieldPickerMode.date,
              ),
              DateTimeFormField(
                decoration: const InputDecoration(
                  labelText: 'Date de fin',
                ),
                dateFormat: DateFormat.yMMMMd('fr_FR'),
                firstDate: DateTime(1940,1,1),
                lastDate: DateTime.now(),
                initialPickerDateTime: DateTime.now(),
                onChanged: (DateTime? value) {
                  endDate = value;
                },
                mode: DateTimeFieldPickerMode.date,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (startDate == null || endDate == null || startDate!.isAfter(endDate!)) {
                    showDialog(
                      context: context,
                      builder : (context) => AlertDialog(
                        title: const Text('Erreur de date'),
                        content : const Text('Veuillez sélectionner une date de début et de fin, avec une date de fin ultérieure à la date de début'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          )
                        ],
                      )
                    );
                  }else{
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Traitement des données...')),
                      );
                      var apiAnswer = await getResponse(WeatherRequest(double.parse(latitudeController.text), double.parse(longitudeController.text), startDate!, endDate!));
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WeatherView(response : apiAnswer))
                      );
                    }
                  }
                },
                child: const Text('Valider'),
              ),
            ],
          )
        ),
    );
  }
}