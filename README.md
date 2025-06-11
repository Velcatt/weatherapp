# weatherapp

Il s'agit d'une application mobile/PC (même si l'interface est plus orientée mobile) qui récupère des données de l'API Open-Meteo et les affiches.

## Exécution de l'appli

L'application peut être exécutée en debug sur un IDE (j'utilise Android Studio personnellement), avec le point d'entrée /lib/main.dart

Elle peut également être compilée avec la command "flutter build apk" pour obtenir une apk utilisable sur un android ou une émulateur android. Pensez à attendre la fin d'éxecution de la commande pour avoir l'emplacement de l'apk produite dans le dossier "build".

## Utilisation de l'appli

Lorsque l'appli est lancée, vous arriverez directement sur le formulaire à remplir pour choisir les coordonnées et la période de temps désirée.

Une fois ceci fait il ne reste plus qu'à appuyer sur le bouton de validation. Vous serez alors redirigé vers une vue des informations météo, classées dans 5 onglet chacun représentée par une icone:

Température  
Humidité  
Vent  
Précipitations  
Couverture nuageuse  

Chacun de ces onglets contient un tableau des valeurs correspondantes par heure.

Si vous souhaitez revenir au formulaire, il suffit d'appuyer sur la flèche retour au dessus des onglets.

## Organisation du projet

Le point d'entrée /lib/main.dart ne contient qu'une appBar et une instance du formulaire.  
Le fichier /lib/src/form.dart contient le formulaire et son état.  
Le fichier /lib/src/weather.dart contient tout ce qui est lié à l'appel de l'API Open Meteo  
Et enfin le fichier /lib/src/weatherView.dart contient tout ce qui est lié à l'affichage des données.  

## Dépendances

Package [open_meteo.dart](https://pub.dev/packages/open_meteo) : Utilisé pour effectuer les appels API vers l'API Open Meteo (simplifie grandement le processus avec des fonctions évitant d'avoir à construire soi-même l'URL de la requête)

Package [date_field.dart](https://pub.dev/packages/date_field) : Utilisé pour avoir une picker de date prévu pour s'intégrer dans des form (le widget DateTimeFormField)

Package [intl.dart, intl_standalone.dart et date_symbol_data_local.dart](https://pub.dev/packages/intl) : Utilisés pour traiter des formats de date dans le formulaire et initialiser les locales nécessaires pour le bon fonctionnement de date_field