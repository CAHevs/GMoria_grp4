import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



//Main class with constructor that receives the language of the smartphone
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context){

    return Localizations.of<AppLocalizations>(context, AppLocalizations);

  }

  //Allow to delegate
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings;

  //Method to load json files
  Future<bool> load() async {

    //Load the language json from the images folder
    String jsonString = await rootBundle.loadString('images/${locale.languageCode}.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value){

      return MapEntry(key, value.toString());
    });

    return true;

  }

  //Method that return the right value compared to entered key
  String translate(String key){

    return _localizedStrings[key];
  }



}


//Class that handle supported language and load language of the smartphone
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations>{

    const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
      return ['en', 'fr'].contains(locale.languageCode);
    }
  
    @override
    Future<AppLocalizations> load(Locale locale) async {
      AppLocalizations localizations = new AppLocalizations(locale);
      await localizations.load();
      return localizations;
    }
  
    @override
    bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;


    

}