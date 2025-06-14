import 'package:flutter/material.dart';
import 'package:open_meteo/open_meteo.dart';
import 'package:fl_chart/fl_chart.dart';

class WeatherView extends StatelessWidget {
  final ApiResponse response;
  const WeatherView ({super.key, required this.response}); //On récupère bien la réponse de l'API pour pouvoir construire les vues correspondantes
  @override
  Widget build(BuildContext context) {
    List<FlSpot> tempList = []; //On initialise une liste de points correspondant aux températures pour le graph
    List<FlSpot> apparentTempList = []; //On initialise une liste de points correspondant aux températures apparentes pour le graph
    List<FlSpot> humidityList = []; //On initialise une liste de points correspondant à l'humidité pour le graph
    List<FlSpot> windSpeedList = []; //On initialise une liste de points correspondant à la viteses du vent pour le graph
    List<FlSpot> windGustList = []; //On initialise une liste de points correspondant aux rafales de vents pour le graph
    List<FlSpot> rainList = []; //On initialise une liste de points correspondant à la pluie pour le graph
    List<FlSpot> snowList = []; //On initialise une liste de points correspondant à la chute de neige pour le graph
    List<FlSpot> cloudCoverList = []; //On initialise une liste de points correspondant à la couverture nuageuse pour le graph
    response.hourlyData[HistoricalHourly.temperature_2m]!.values.forEach((key, value) {
      tempList.add(FlSpot(key.millisecondsSinceEpoch.toDouble(), value.toDouble())); //Pour chaque température, on ajoute un point de graph dans la liste, contenant la date/heure convertit en millisecond depuis l'epoch, et la température
    });
    response.hourlyData[HistoricalHourly.apparent_temperature]!.values.forEach((key, value) {
      apparentTempList.add(FlSpot(key.millisecondsSinceEpoch.toDouble(), value.toDouble())); //Idem pour la température ressentie
    });
    response.hourlyData[HistoricalHourly.relative_humidity_2m]!.values.forEach((key, value) {
      humidityList.add(FlSpot(key.millisecondsSinceEpoch.toDouble(), value.toDouble())); //Idem pour l'humidité
    });
    response.hourlyData[HistoricalHourly.wind_speed_10m]!.values.forEach((key, value) {
      windSpeedList.add(FlSpot(key.millisecondsSinceEpoch.toDouble(), value.toDouble())); //Idem pour la vitesse du vent
    });
    response.hourlyData[HistoricalHourly.wind_gusts_10m]!.values.forEach((key, value) {
      windGustList.add(FlSpot(key.millisecondsSinceEpoch.toDouble(), value.toDouble())); //Idem pour les rafales
    });
    response.hourlyData[HistoricalHourly.rain]!.values.forEach((key, value) {
      rainList.add(FlSpot(key.millisecondsSinceEpoch.toDouble(), value.toDouble())); //Idem pour la pluie
    });
    response.hourlyData[HistoricalHourly.snowfall]!.values.forEach((key, value) {
      snowList.add(FlSpot(key.millisecondsSinceEpoch.toDouble(), value.toDouble())); //Idem pour la chute de neige
    });
    response.hourlyData[HistoricalHourly.cloud_cover]!.values.forEach((key, value) {
      cloudCoverList.add(FlSpot(key.millisecondsSinceEpoch.toDouble(), value.toDouble())); //Idem pour la couverture nuageuse
    });

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.thermostat),), //Icône de l'onglet température
                Tab(icon: Icon(Icons.water),), //Icône de l'onglet humidité
                Tab(icon: Icon(Icons.wind_power),), //Icône de l'onglet vents
                Tab(icon: Icon(Icons.water_drop),), //Icône de l'onglet précipitations
                Tab(icon: Icon(Icons.cloud),), //Icône de l'onglet couverture nuageuse
              ],
          ),
        ),
        body: TabBarView( //Chaque child correspond à un onglet de la TabBar
            children: [
              SingleChildScrollView( //Pour rendre le graph et le tableau scrollable
                child: Column(
                  children: [
                    Row( //On fait un row pour la légende du graph
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Temp°C",
                          style: TextStyle(
                            color: Colors.deepPurple, //Les couleurs choisies ici correspondent aux couleurs des lignes du graph
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Temp°C Ressentie",
                          style: TextStyle(
                            color: Colors.deepPurple[200], //Les couleurs choisies ici correspondent aux couleurs des lignes du graph
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox( //On met le graphique dans une SizedBox car il a besoin d'être contenu dans un objet lui indiquant quelle taille il doit faire
                      width: 400,
                      height: 400,
                      child: LineChart( //On construit le graphique. Je commenterais ce premier graph en détail mais ils fonctionnent tous de façon similaire
                        LineChartData( //Pour stocker toutes les données liées au graph
                          titlesData: FlTitlesData( //Pour paramétrer les titres, cad les valeurs affichées sur chaque axe
                            bottomTitles: AxisTitles( //Titres de l'axe du bas
                              sideTitles: SideTitles( //Les titres des dates
                                minIncluded: false, //On exclut le minimum et le maximum pour éviter d'avoir des valeurs qui se chevauchent visuellement
                                maxIncluded: false,
                                showTitles: true, //On affiche bien les titres de l'axe du bas, ce sera notre axe du temps
                                getTitlesWidget: (value, meta) {
                                  var date = DateTime.fromMillisecondsSinceEpoch(value.toInt()).toString(); //Comme on a convertit les dates en milisecond depuis l'epoch pour pouvoir construire chaque point du graph, on les reconvertit pour les afficher de manière lisible
                                  date = date.substring(0, date.length-12);
                                  return SideTitleWidget(
                                    meta: meta,
                                    angle:120, //On penche l'affichage de la date pour plus de lisibilité
                                    child: Text(
                                      "         $date", //On met plusieurs espaces avant la date pour éviter qu'elle chevauche le graph
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles( //Titres de l'axe de gauche
                              sideTitles: SideTitles( //Les titres des valeurs, ici les températures
                                reservedSize: 25, // On laisse de la place pour éviter que les titres ne retournent à la ligne
                                minIncluded: false, //Encore une fois, on retire le max et le min pour éviter des problèmes de superposition
                                maxIncluded: false,
                                showTitles: true, //On montre bien les titres de l'axe de gauche, ce sera ici notre axe des températures, mais pour chaque graph ce sera l'axe des valeurs concerné (humidité en % pour le graph de l'humidité par exemple)
                                getTitlesWidget: (value, meta) {
                                  var temp = value.toInt(); //On passe les température en Int sur les axes pour plus de clarté
                                  return SideTitleWidget(
                                    meta: meta,
                                    space: 1,
                                    child: Text(
                                      "$temp°C", //On récupère et on affiche la température en Int
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                              )
                            ),
                            topTitles: AxisTitles( //Titres de l'axe du haut
                              sideTitles: SideTitles(
                                showTitles: false, //Pour l'axe du haut on n'affiche pas les titres
                              )
                            ),
                            rightTitles: AxisTitles( //Titres de l'axe de droite
                              sideTitles: SideTitles(
                                showTitles: false, //Idem que pour l'axe du haut, on n'affiche pas les titres
                              )
                            )
                          ),
                          lineBarsData: [ //Contient chacune des lignes à afficher sur le graph
                            LineChartBarData(
                              spots: tempList, //On passe la liste de points des température à la première ligne
                              color: Colors.deepPurple, //Même couleur que la légende correspondante
                              dotData: FlDotData(
                                show: false, //On ne montre pas les points car celà rend le graphique assez brouillon avec un grand nombre de points
                              )
                            ),
                            LineChartBarData(
                                spots: apparentTempList, //On passe la liste de points des température apparentes à la deuxième ligne
                                color: Colors.deepPurple[200], //Même couleur que la légende correspondante
                                dotData: FlDotData(
                                  show: false, //On ne montre pas les points car celà rend le graphique assez brouillon avec un grand nombre de points
                                )
                            )
                          ],
                        )
                      ),
                    ),
                    Padding( //On ajoute du padding au dessus pour laisser de la place aux titres de l'axe du bas du graph. On aurais pu le faire avec l'attribut reservedSpace mais cela applatissait le graphique et rendait moins bien à mon goût
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Table(
                        children: buildTemperature(response.hourlyData[HistoricalHourly.temperature_2m]!.values,response.hourlyData[HistoricalHourly.apparent_temperature]!.values), //On appelle la fonction buildTemperature qui construit le tableau des température
                        border: TableBorder.all(), //Pour voir les bordures entre chaque cellule du tableau
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView( //Pour rendre le graph et le tableau scrollable
                child: Column(
                  children: [
                    Row( //On fait un row pour la légende du graph
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Humidité relative",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 400,
                      height: 400,
                      child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    minIncluded: false,
                                    maxIncluded: false,
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      var date = DateTime.fromMillisecondsSinceEpoch(value.toInt()).toString();
                                      date = date.substring(0, date.length-12);
                                      return SideTitleWidget(
                                        meta: meta,
                                        angle:120,
                                        child: Text(
                                          "         $date",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        minIncluded: false,
                                        maxIncluded: false,
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          var humidity = value.toInt();
                                          return SideTitleWidget(
                                            meta: meta,
                                            space: 1,
                                            child: Text(
                                              "$humidity%",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }
                                    )
                                ),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    )
                                ),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    )
                                )
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                  spots: humidityList,
                                  color: Colors.deepPurple,
                                  dotData: FlDotData(
                                    show: false,
                                  )
                              ),
                            ],
                          )
                      ),
                    ),
                    Padding( //On ajoute du padding au dessus pour laisser de la place aux titres de l'axe du bas du graph. On aurais pu le faire avec l'attribut reservedSpace mais cela applatissait le graphique et rendait moins bien à mon goût
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Table(
                        children: buildHumidity(response.hourlyData[HistoricalHourly.relative_humidity_2m]!.values), //On appelle la fonction buildHumidity qui construit le tableau de l'humidité
                        border: TableBorder.all(),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView( //Pour rendre le graph et le tableau scrollable
                child: Column(
                  children: [
                    Row( //On fait un row pour la légende du graph
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Vitesse vent",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Rafales",
                          style: TextStyle(
                            color: Colors.deepPurple[200],
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 400,
                      height: 400,
                      child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    minIncluded: false,
                                    maxIncluded: false,
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      var date = DateTime.fromMillisecondsSinceEpoch(value.toInt()).toString();
                                      date = date.substring(0, date.length-12);
                                      return SideTitleWidget(
                                        meta: meta,
                                        angle:120,
                                        child: Text(
                                          "         $date",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        reservedSize: 40,
                                        minIncluded: false,
                                        maxIncluded: false,
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          var speed = value.toInt();
                                          return SideTitleWidget(
                                            meta: meta,
                                            space: 1,
                                            child: Text(
                                              "$speed kmh",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                                ),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    )
                                ),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    )
                                )
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                  spots: windSpeedList,
                                  color: Colors.deepPurple,
                                  dotData: FlDotData(
                                    show: false,
                                  )
                              ),
                              LineChartBarData(
                                  spots: windGustList,
                                  color: Colors.deepPurple[200],
                                  dotData: FlDotData(
                                    show: false,
                                  )
                              ),
                            ],

                          ),
                      ),
                    ),
                    Padding( //On ajoute du padding au dessus pour laisser de la place aux titres de l'axe du bas du graph. On aurais pu le faire avec l'attribut reservedSpace mais cela applatissait le graphique et rendait moins bien à mon goût
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Table(
                        children: buildWind(response.hourlyData[HistoricalHourly.wind_speed_10m]!.values,response.hourlyData[HistoricalHourly.wind_direction_10m]!.values,response.hourlyData[HistoricalHourly.wind_gusts_10m]!.values), //On appelle la fonction buildWind qui construit le tableau des vents
                        border: TableBorder.all(),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView( //Pour rendre le graph et le tableau scrollable
                child: Column(
                  children: [
                    Row( //On fait un row pour la légende du graph
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Pluie",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Neige",
                          style: TextStyle(
                            color: Colors.deepPurple[200],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 400,
                      height: 400,
                      child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    minIncluded: false,
                                    maxIncluded: false,
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      var date = DateTime.fromMillisecondsSinceEpoch(value.toInt()).toString();
                                      date = date.substring(0, date.length-12);
                                      return SideTitleWidget(
                                        meta: meta,
                                        angle:120,
                                        child: Text(
                                          "         $date",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        reservedSize: 45,
                                        minIncluded: false,
                                        maxIncluded: false,
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          var amount = value.toStringAsFixed(2);
                                          return SideTitleWidget(
                                            meta: meta,
                                            space: 2,
                                            child: Text(
                                              "$amount mm",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }
                                    )
                                ),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    )
                                ),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    )
                                )
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                  spots: rainList,
                                  color: Colors.deepPurple,
                                  dotData: FlDotData(
                                    show: false,
                                  )
                              ),
                              LineChartBarData(
                                  spots: snowList,
                                  color: Colors.deepPurple[200],
                                  dotData: FlDotData(
                                    show: false,
                                  )
                              ),
                            ],
                          )
                      ),
                    ),
                    Padding( //On ajoute du padding au dessus pour laisser de la place aux titres de l'axe du bas du graph. On aurais pu le faire avec l'attribut reservedSpace mais cela applatissait le graphique et rendait moins bien à mon goût
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Table(
                        children: buildPrecipitation(response.hourlyData[HistoricalHourly.precipitation]!.values,response.hourlyData[HistoricalHourly.rain]!.values,response.hourlyData[HistoricalHourly.snowfall]!.values), //On appelle la fonction buildPrecipitation qui construit le tableau des précipitations
                        border: TableBorder.all(),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView( //Pour rendre le graph et le tableau scrollable
                child: Column(
                  children: [
                    Row( //On fait un row pour la légende du graph
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Couverture nuageuse",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 400,
                      height: 400,
                      child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    minIncluded: false,
                                    maxIncluded: false,
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      var date = DateTime.fromMillisecondsSinceEpoch(value.toInt()).toString();
                                      date = date.substring(0, date.length-12);
                                      return SideTitleWidget(
                                        meta: meta,
                                        angle:120,
                                        child: Text(
                                          "         $date",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        minIncluded: false,
                                        maxIncluded: false,
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          var cover = value.toInt();
                                          return SideTitleWidget(
                                            meta: meta,
                                            space: 1,
                                            child: Text(
                                              "$cover%",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }
                                    )
                                ),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    )
                                ),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: false,
                                    )
                                )
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                  spots: cloudCoverList,
                                  color: Colors.deepPurple,
                                  dotData: FlDotData(
                                    show: false,
                                  )
                              ),
                            ],
                          )
                      ),
                    ),
                    Padding( //On ajoute du padding au dessus pour laisser de la place aux titres de l'axe du bas du graph. On aurais pu le faire avec l'attribut reservedSpace mais cela applatissait le graphique et rendait moins bien à mon goût
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Table(
                        children: buildCloudcover(response.hourlyData[HistoricalHourly.cloud_cover]!.values), //On appelle la fonction buildCloudcover qui construit le tableau de la couverture nuageuse
                        border: TableBorder.all(),
                      ),
                    ),
                  ],
                ),
              ),
            ]
        )
      ),
    );
  }
}

List<TableRow> buildTemperature (Map temp, Map apparentTemp){ //fonction qui construit le tableau des températures, ligne par ligne. Je décrie en détail le procédé sur cette fonction, mais toutes les fontions builds ont globalement le même fonctionnement
  List<TableRow> list = []; //On initialise la liste de lignes de tableau qu'on va renvoyer, elle sera remplie tout au long de la fonction
  String strDate = ''; //On initialise une chaine pour stocker et formatter la date
  String strTemp = ''; //On initialise une chaine pour stocker et formatter la température
  String strApparentTemp = ''; //On initialise une chaine pour stocker et formatter la température ressentie
  list.add(TableRow( //On construit d'abord une ligne avec les en-têtes et on l'ajoute à la liste
      children: [
        TableCell(
            child: Text(
              'Date et heure',
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
              ),
            )
        ),
        TableCell(
          child: Text(
            'Temp°C',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
            ),
          ),
        ),
        TableCell(
          child: Text(
            'Temp°C ressentie',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
            ),
          ),
        ),
      ],
      decoration: BoxDecoration(color: Colors.deepPurple), //On met un fond mauve pour l'en tête afin de la détacher visuellement du reste
    )
  );
  temp.forEach((key, value) { // Pour chaque date et heure, on construit une ligne dans le tableau des températures. Vu que les tableaux contiennent le même nombre de lignes, on itère sur une seul des maps.
    strDate = key.toString(); // On récupère la date en string dans la variable strDate
    strDate = strDate.substring(0, strDate.length-7); //On enlève tout ce qui est plus petit que la seconde, pour des raisons de lisibilité et de pertinence (l'API n'est précise qu'à l'heure de toute façons)
    strTemp = value.toString(); //On récupère la température en string dans la variable strTemp
    for (var i = strTemp.length; i > 6; i--){ //Pour la température on ne garde que 5 chiffres (6 caractères avec le point) pour plus de lisibilité
      strTemp = strTemp.substring(0, strTemp.length-1); //On retire le dernier caractère jusqu'à ce qu'il n'en reste que 6
    }
    strApparentTemp = apparentTemp[key].toString(); //On récupère la température ressentie depuis l'autre map, en string, dans la variable strApparentTemp
    for (var i =strApparentTemp.length; i > 6; i--){ //Idem pour la température ressentie, on ne garde que 5 chiffres (6 caractères avec le point) pour plus de lisibilité
      strApparentTemp = strApparentTemp.substring(0, strApparentTemp.length-1); //On retire le dernier caractère jusqu'à ce qu'il n'en reste que 6
    }
    list.add(new TableRow( //Pour chaque entrée, on construit une nouvelle ligne de tableau contenant 3 cellules pour contenir strDate, strTemp et strApparentTemp
      children: [
        TableCell(
            child: Text(
              strDate,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
              ),
            )
        ),
        TableCell(
          child: Text(
            '$strTemp°C',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        TableCell(
          child: Text(
            '$strApparentTemp°C',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    ));
  });
  return list;
}

List<TableRow> buildHumidity (Map humidity){ //fonction qui construit le tableau de l'humidité, ligne par ligne
  List<TableRow> list = [];
  String strDate = '';
  String strHumidity = '';
  list.add(TableRow(
    children: [
      TableCell(
          child: Text(
            'Date et heure',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
      ),
      TableCell(
        child: Text(
          'Humidité relative',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
    decoration: BoxDecoration(color: Colors.deepPurple),
  )
  );
  humidity.forEach((key, value) {
    strDate = key.toString();
    strDate = strDate.substring(0, strDate.length-7);
    strHumidity = value.toString();
    for (var i = strHumidity.length; i > 6; i--){
      strHumidity = strHumidity.substring(0, strHumidity.length-1);
    }
    list.add(new TableRow(
      children: [
        TableCell(
            child: Text(
              strDate,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
              ),
            )
        ),
        TableCell(
          child: Text(
            '$strHumidity%',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    ));
  });
  return list;
}

List<TableRow> buildWind (Map ws10m, Map wd10m, Map gust){ //fonction qui construit le tableau des vents, ligne par ligne
  List<TableRow> list = [];
  String strDate = '';
  String strws10m = '';
  String strwd10m = '';
  String strgust = '';
  list.add(TableRow(
    children: [
      TableCell(
          child: Text(
            'Date et heure',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
      ),
      TableCell(
        child: Text(
          'Vitesse vent',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      TableCell(
        child: Text(
          'Direction vent',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      TableCell(
        child: Text(
          'Rafales',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
    decoration: BoxDecoration(color: Colors.deepPurple),
  )
  );
  ws10m.forEach((key, value) {
    strDate = key.toString();
    strDate = strDate.substring(0, strDate.length-7);
    strws10m = value.toString();
    for (var i = strws10m.length; i > 6; i--){
      strws10m = strws10m.substring(0, strws10m.length-1);
    }
    strwd10m = wd10m[key].toString();
    for (var i = strwd10m.length; i > 6; i--){
      strwd10m = strwd10m.substring(0, strwd10m.length-1);
    }
    strgust = gust[key].toString();
    for (var i = strgust.length; i > 6; i--){
      strgust = strgust.substring(0, strgust.length-1);
    }
    list.add(new TableRow(
      children: [
        TableCell(
            child: Text(
              strDate,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
              ),
            )
        ),
        TableCell(
          child: Text(
            '$strws10m km/h',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        TableCell(
          child: Text(
            '$strwd10m°',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        TableCell(
          child: Text(
            '$strgust km/h',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    ));
  });
  return list;
}

List<TableRow> buildPrecipitation (Map precipitation, Map rain, Map snowfall){ //fonction qui construit le tableau des précipitations, ligne par ligne
  List<TableRow> list = [];
  String strDate = '';
  String strPrecipitation = '';
  String strRain = '';
  String strSnowfall = '';
  list.add(TableRow(
    children: [
      TableCell(
          child: Text(
            'Date et heure',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
      ),
      TableCell(
        child: Text(
          'Précipitations',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      TableCell(
        child: Text(
          'Pluie',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      TableCell(
        child: Text(
          'Neige',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
    decoration: BoxDecoration(color: Colors.deepPurple),
  )
  );
  precipitation.forEach((key, value) {
    strDate = key.toString();
    strDate = strDate.substring(0, strDate.length-7);
    strPrecipitation = value.toString();
    for (var i = strPrecipitation.length; i > 6; i--){
      strPrecipitation = strPrecipitation.substring(0, strPrecipitation.length-1);
    }
    strRain = rain[key].toString();
    for (var i = strRain.length; i > 6; i--){
      strRain = strRain.substring(0, strRain.length-1);
    }
    strSnowfall = snowfall[key].toString();
    for (var i = strSnowfall.length; i > 6; i--){
      strSnowfall = strSnowfall.substring(0, strSnowfall.length-1);
    }
    list.add(new TableRow(
      children: [
        TableCell(
            child: Text(
              strDate,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
              ),
            )
        ),
        TableCell(
          child: Text(
            '$strPrecipitation mm',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        TableCell(
          child: Text(
            '$strRain mm',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        TableCell(
          child: Text(
            '$strSnowfall mm',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    ));
  });
  return list;
}

List<TableRow> buildCloudcover (Map cloudcover){ //fonction qui construit le tableau de la couverture nuageuse, ligne par ligne
  List<TableRow> list = [];
  String strDate = '';
  String strCloudcover = '';
  list.add(TableRow(
    children: [
      TableCell(
        child: Text(
          'Date et heure',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
      ),
      TableCell(
        child: Text(
          'Couverture nuageuse',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
    decoration: BoxDecoration(color: Colors.deepPurple),
  )
  );
  cloudcover.forEach((key, value) {
    strDate = key.toString();
    strDate = strDate.substring(0, strDate.length-7);
    strCloudcover = value.toString();
    for (var i = strCloudcover.length; i > 6; i--){
      strCloudcover = strCloudcover.substring(0, strCloudcover.length-1);
    }
    list.add(new TableRow(
      children: [
        TableCell(
            child: Text(
              strDate,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
              ),
            )
        ),
        TableCell(
          child: Text(
            '$strCloudcover %',
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    ));
  });
  return list;
}
