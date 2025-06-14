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
    final cityController = TextEditingController();
    return Form(
      key: _formKey,
        child : SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, //On centre le formulaire verticalement pour une meilleure accessibilité des champs
            children: <Widget>[
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent), //On rend les dividers transparents pour clarifier le formulaire
                child: ExpansionTile( //On met la recherche de ville dans une ExpansionTile car son utilisation est totalement optionnelle
                    title: Text('Rechercher...'),
                    children: [
                      TextFormField( //Champs de nom de ville / code postal. Ce champs n'a pas de validator car la recherche par nom de ville/code postal est optionnelle
                        decoration: const InputDecoration(
                          hintText: 'exemple : Montpellier ou 34000',
                          labelText: 'Nom de ville ou code postal',
                        ),
                        controller: cityController,
                      ),
                      ElevatedButton(
                          onPressed: () async { //On fait une fonction async puisqu'on aura besoin d'attendre la réponse d'une API
                            var apiAnswer = await getCoordinates(GeocodingRequest(cityController.text)); //on récupère la réponse de l'API Geocoding pour pouvoir l'utiliser ensuite
                            try {
                              latitudeController.text = apiAnswer.values.elementAt(0)[0]['latitude'].toString(); //On prérempli le champs Latitude avec la latitude de la ville cherchée
                              longitudeController.text = apiAnswer.values.elementAt(0)[0]['longitude'].toString(); //On prérempli le champs Longitude avec la longitude de la ville cherchée
                            } catch (_){ //Si les deux opérations précédentes ne fonctionnent pas et soulèvent une erreur, c'est que l'API n'a pas trouvé de ville correspondante.
                              showDialog(
                                  context: context,
                                  builder : (context) => AlertDialog( //Si l'API n'a pas trouvé ne ville, on fait pop une fenêtre de dialogue qui l'indique
                                    title: const Text('Erreur'),
                                    content : const Text('Aucune ville trouvée à ce nom / code postal'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      )
                                    ],
                                  )
                              );
                            }
                          }, 
                          child: const Icon(Icons.search),
                      ),
                    ],
                ),
              ),
              TextFormField( //Champs de texte pour la latitude
                decoration: const InputDecoration(
                  hintText: 'exemple : 52.52',
                  labelText: 'Latitude',
                ),
                controller: latitudeController,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null || double.tryParse(value)! > 90.0 || double.tryParse(value)! < -90.0) { //On vérifie que l'entrée est une latitude valide
                    return 'Veuillez entrer une latitude';
                  }
                return null;
                }
              ),
              TextFormField( //Champs de texte pour la longitude
                decoration: const InputDecoration(
                  hintText: 'exemple : 13.41',
                  labelText: 'Longitude',
                ),
                controller: longitudeController,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null || double.tryParse(value)! > 180.0 || double.tryParse(value)! < -180.0) { //On vérifie que l'entrée est une longitude valide
                    return 'Veuillez entrer une longitude';
                  }
                  return null;
                }
              ),
              DateTimeFormField( //Champs de date pour la date de début
                decoration: const InputDecoration(
                  labelText: 'Date de début',
                ),
                dateFormat: DateFormat.yMMMMd('fr_FR'), //Pour formatter la date en français
                firstDate: DateTime(1940, 1, 1), //0n commence en 1940 puisque c'est la date la plus tôt de l'API
                lastDate: DateTime.now(),
                initialPickerDateTime: DateTime.now(),
                onChanged: (DateTime? value) {
                  startDate = value;
                },
                mode: DateTimeFieldPickerMode.date, //On ne choisit que la date, l'API ne reconnaissant pas l'heure
              ),
              DateTimeFormField( //Champs de date pour la date de fin
                decoration: const InputDecoration(
                  labelText: 'Date de fin',
                ),
                dateFormat: DateFormat.yMMMMd('fr_FR'), //Pour formatter la date en français
                firstDate: DateTime(1940,1,1), //0n commence en 1940 puisque c'est la date la plus tôt de l'API
                lastDate: DateTime.now(),
                initialPickerDateTime: DateTime.now(),
                onChanged: (DateTime? value) {
                  endDate = value;
                },
                mode: DateTimeFieldPickerMode.date, //On ne choisit que la date, l'API ne reconnaissant pas l'heure
              ),
              ElevatedButton(
                onPressed: () async { //La fonction est async puisque c'est à l'appui du bouton de validation que sera éventuellement appelé l'Historical API d'Open Meteo
                  if (startDate == null || endDate == null || startDate!.isAfter(endDate!)) { //On vérifie que deux date sont choisies, et que la date de fin est ultérieure à la date de début
                    showDialog(
                      context: context,
                      builder : (context) => AlertDialog( //Si les dates ne sont pas valides, on fait pop une fenêtre de dialogue qui l'indique
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
                    if (_formKey.currentState!.validate()) { //On effectue les validations de la latitude et de la longitude
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Traitement des données...')), //Si tous les champs sont valides, on affiche une snackbar pour signifier à l'utilisateur que les données sont en traitement, car l'appel de l'API peut prendre un certain temps pour de longues périodes
                      );
                      var apiAnswer = await getResponse(WeatherRequest(double.parse(latitudeController.text), double.parse(longitudeController.text), startDate!, endDate!)); //On effectue l'appel API pour récupérer les données demandées par l'utilisateur. On le fait ici pour pouvoir faire de la route WeatherView un StatelessWidget. On stock ensuite la réponse dans la variable apiAnswer.
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WeatherView(response : apiAnswer)) //Si toute les conditions sont remplies, on passe sur la route WeatherView (de ./weatherView.dart) qui affichera les données en partant de la réponse de l'API stockée dans apiAnswer
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