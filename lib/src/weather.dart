import 'package:open_meteo/open_meteo.dart';

class WeatherRequest { //Classe pour stocker les données nécessaires à une requête API
  late double latitude;
  late double longitude;
  late DateTime startDate;
  late DateTime endDate;

  WeatherRequest (double latitude, double longitude, DateTime startDate, DateTime endDate) {
    this.latitude = latitude;
    this.longitude = longitude;
    this.startDate = startDate;
    this.endDate = endDate;
  }
}

Future<ApiResponse> getResponse(WeatherRequest request) async { //Fonction qui effectue la requête API en partant d'une WeatherRequest
  final historical = HistoricalApi();
  return await historical.request(
    latitude: request.latitude,
    longitude: request.longitude,
    startDate: request.startDate,
    endDate: request.endDate,
    hourly: { //On choisit ici quelles sont les variables à récupérer
      HistoricalHourly.temperature_2m,
      HistoricalHourly.apparent_temperature,
      HistoricalHourly.relative_humidity_2m,
      HistoricalHourly.wind_speed_10m,
      HistoricalHourly.wind_direction_10m,
      HistoricalHourly.wind_gusts_10m,
      HistoricalHourly.precipitation,
      HistoricalHourly.rain,
      HistoricalHourly.snowfall,
      HistoricalHourly.cloud_cover,
    },
  );
}