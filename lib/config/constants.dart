// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

class AppConstants {
  static const String baseBackendUrl = "http://10.0.2.2:8000/";

  static const String allergiesUrl = "${baseBackendUrl}allergies/";
  static const String placesUrl = "${baseBackendUrl}places/";
  static const String predictorsUrl = "${baseBackendUrl}predictors/";
  static const String usersUrl = "${baseBackendUrl}users/";
}

