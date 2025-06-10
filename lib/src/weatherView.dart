import 'package:flutter/material.dart';
import 'package:open_meteo/open_meteo.dart';

class WeatherView extends StatelessWidget {
  final ApiResponse response;
  const WeatherView ({super.key, required this.response});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.thermostat),),
                Tab(icon: Icon(Icons.water),),
                Tab(icon: Icon(Icons.wind_power),),
                Tab(icon: Icon(Icons.water_drop),),
                Tab(icon: Icon(Icons.cloud),),
              ],
          ),
        ),
        body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Table(
                  children: buildTemperature(response.hourlyData[HistoricalHourly.temperature_2m]!.values,response.hourlyData[HistoricalHourly.apparent_temperature]!.values),
                  border: TableBorder.all(),
                ),
              ),
              SingleChildScrollView(
                child: Table(
                  children: buildHumidity(response.hourlyData[HistoricalHourly.relative_humidity_2m]!.values),
                  border: TableBorder.all(),
                ),
              ),
              SingleChildScrollView(
                child: Table(
                  children: buildWind(response.hourlyData[HistoricalHourly.wind_speed_10m]!.values,response.hourlyData[HistoricalHourly.wind_direction_10m]!.values,response.hourlyData[HistoricalHourly.wind_gusts_10m]!.values),
                  border: TableBorder.all(),
                ),
              ),
              SingleChildScrollView(
                child: Table(
                  children: buildPrecipitation(response.hourlyData[HistoricalHourly.precipitation]!.values,response.hourlyData[HistoricalHourly.rain]!.values,response.hourlyData[HistoricalHourly.snowfall]!.values),
                  border: TableBorder.all(),
                ),
              ),
              SingleChildScrollView(
                child: Table(
                  children: buildCloudcover(response.hourlyData[HistoricalHourly.cloud_cover]!.values),
                  border: TableBorder.all(),
                ),
              ),
            ]
        )
      ),
    );
  }
}

List<TableRow> buildTemperature (Map temp, Map apparentTemp){
  List<TableRow> list = [];
  String strDate = '';
  String strTemp = '';
  String strApparentTemp = '';
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
      decoration: BoxDecoration(color: Colors.deepPurple),
    )
  );
  temp.forEach((key, value) {
    strDate = key.toString();
    strDate = strDate.substring(0, strDate.length-7);
    strTemp = value.toString();
    for (var i = strTemp.length; i > 6; i--){
      strTemp = strTemp.substring(0, strTemp.length-1);
    }
    strApparentTemp = apparentTemp[key].toString();
    for (var i =strApparentTemp.length; i > 6; i--){
      strApparentTemp = strApparentTemp.substring(0, strApparentTemp.length-1);
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

List<TableRow> buildHumidity (Map humidity){
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

List<TableRow> buildWind (Map ws10m, Map wd10m, Map gust){
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

List<TableRow> buildPrecipitation (Map precipitation, Map rain, Map snowfall){
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

List<TableRow> buildCloudcover (Map cloudcover){
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