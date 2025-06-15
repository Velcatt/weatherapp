# WeatherApp

Il s'agit d'une application mobile/PC (même si l'interface est plus orientée mobile) qui récupère des données de l'API Open-Meteo et les affiches sous forme de graphique et de tableau.

## Exécution de l'application

L'application peut être exécutée en debug sur un IDE (j'utilise Android Studio personnellement), avec le point d'entrée /lib/main.dart

Elle peut également être compilée avec la command "flutter build apk" pour obtenir une apk utilisable sur un android ou une émulateur android. Pensez à attendre la fin d'éxecution de la commande pour avoir l'emplacement de l'apk produite dans le dossier "build".

## Utilisation de l'application

Lorsque l'application est lancée, vous arriverez directement sur le formulaire à remplir pour choisir les coordonnées et la période de temps désirée.  

Si vous préférez rechercher une ville, il vous suffit d'ouvrir le menu déroulant "Rechercher...", d'entrer un nom de ville ou un code postal, et d'appuyer sur le bouton avec une icône de loupe. Cela préremplira les champs de coordonnées avec les coordonnées de la ville recherchée.

Une fois ceci fait il ne reste plus qu'à appuyer sur le bouton de validation. Vous serez alors redirigé vers une vue des informations météo, classées dans 5 onglet chacun représentée par des icônes :

Température  
Humidité  
Vent  
Précipitations  
Couverture nuageuse  

Chacun de ces onglets contient un graphique de l'évolution des données en fonction du temps, et un tableau des valeurs correspondantes par heure. Vous pouvez défiler pour accéder à toutes les valeurs du tableau.

Si vous souhaitez revenir au formulaire, il suffit d'appuyer sur la flèche retour au dessus des onglets.

## Organisation du projet

Le point d'entrée /lib/main.dart ne contient qu'une MaterialApp, avec une appBar et une instance du formulaire.  
Le fichier /lib/src/form.dart contient le formulaire et son état.  
Le fichier /lib/src/weather.dart contient tout ce qui est lié à l'appel de l'API Open Meteo.  
Et enfin le fichier /lib/src/weatherView.dart contient tout ce qui est lié à l'affichage des données récupérées depuis l'API.  

## Dépendances

Package [open_meteo.dart](https://pub.dev/packages/open_meteo) : Utilisé pour effectuer les appels vers l'API Open Meteo (simplifie grandement le processus avec des fonctions évitant d'avoir à construire soi-même l'URL de la requête) et gérer les réponses de l'API. On utilise 2 API de Open Météo, la Geocoding API pour la recherche par nom de ville, et la Historical API pour récupérer les données météo.

Package [date_field.dart](https://pub.dev/packages/date_field) : Utilisé pour avoir un picker de date prévu pour s'intégrer dans des formulaires (le widget DateTimeFormField)

Package [intl.dart, intl_standalone.dart et date_symbol_data_local.dart](https://pub.dev/packages/intl) : Utilisés pour traiter des formats de date dans le formulaire et initialiser les locales nécessaires pour le bon fonctionnement de date_field

Package [fl_chart.dart](https://pub.dev/packages/fl_chart) : Utilisé pour construire et afficher les graphiques à partir de la réponse de l'API. Je l'ai choisis plutôt que SyncFusion Flutter Charts car je trouvais fl_chart plus flexible dans sa façon de traiter les données et d'en faire des points sur un graphique.

Package [flutter_localizations.dart](https://pub.dev/packages/flutter_localization) : Utilisé pour avoir des locales globales dans la MaterialApp afin de pouvoir avoir les date pickers en français.

## Bugs

Il faut parfois appuyer plusieurs fois sur les boutons "Valider" et "Rechercher" (la loupe) pour qu'ils fonctionnent. J'ai l'impression que c'est lié au variations de temps de réponse de l'API mais je n'en suis pas certain.

Il peut y avoir de gros ralentissements lorsque de grandes période de temps sont recherchées (exemple : 1 an)

Il y a plusieurs erreurs remontée par l'IDE lors du premier build, que je n'ai pas eu le temps de traiter. Elles n'empêche cependant pas l'application de fonctionner.