import 'package:open_meteo/open_meteo.dart';

class WeatherRequest { //Classe pour stocker les données nécessaires à une requête API sur Historical API
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

class GeocodingRequest { //Classe pour stocker les données nécessaire à une requête API sur Geocoding API
  late String cityName;

  GeocodingRequest (String cityName) {
    this.cityName = cityName;
  }
}

Future<ApiResponse> getResponse(WeatherRequest request) async { //Fonction qui effectue la requête API vers l'Historical API en partant d'une WeatherRequest
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

Future<Map> getCoordinates(GeocodingRequest request) async { //Fonction qui effectue la requête API vers la Geocoding API en partant d'une GeocodingRequest
  final geocoding = GeocodingApi();
  return await geocoding.requestJson(name: request.cityName);
}