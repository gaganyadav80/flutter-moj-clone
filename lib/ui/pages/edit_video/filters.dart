import 'package:flutter/material.dart';

import 'edit_video_models.dart';

FilterModel currentFilterColor = FILTERS[0];

List<FilterModel> FILTERS = [
  // Matrix
  FilterModel("Original", null, null, ORIGINAL_MATRIX),
  FilterModel("BW", null, null, BW_MATRIX),
  FilterModel("Old Times", null, null, OLDTIMES_MATRIX),
  FilterModel("New Times", null, null, NEWTIMES_MATRIX),
  FilterModel("Cold Life", null, null, COLDLIFE_MATRIX),
  FilterModel("Stinson", null, null, STINSON_MATRIX),
  FilterModel("Blood Red", null, null, BLOOD_MATRIX),
  FilterModel("Pastel", null, null, PASTEL_MATRIX),
  FilterModel("Saturated", null, null, SATURATED_MATRIX),
  FilterModel("Milk", null, null, MILK_MATRIX),
  FilterModel("Sweet", null, null, SWEET_MATRIX),
  // FilterModel("Summers", null, null, SUMMERS_MATRIX),
  // FilterModel("Greenday", null, null, GREENDAY_MATRIX),
  FilterModel("Invert", null, null, INVERT_MATRIX),
  FilterModel("Hudson", null, null, HUDSON_MATRIX),
  FilterModel("Willow", null, null, WILLOW_MATRIX),
  // Sepia Category
  FilterModel("Sepium", null, null, SEPIUM_MATRIX),
  FilterModel("Vintage", null, null, VINTAGE_MATRIX),
  // FilterModel("Sepia", null, null, SEPIA_MATRIX),
  FilterModel("Earlybird", null, null, EARLYBIRD_MATRIX),
  // Colors
  FilterModel("Bluesky", Color(0xff0044cc), BlendMode.screen, null), // flag
  FilterModel("Toaster", Color(0xff3b003b), BlendMode.screen, null), // flag
  FilterModel("Lavender", Color(0xffE6E6FA), BlendMode.softLight, null), // flag
  FilterModel("Loft", Color.fromRGBO(155, 200, 210, 0.9), BlendMode.overlay, null), // flag
  FilterModel("Aden", Color(0xff360309).withOpacity(0.65), BlendMode.overlay, null), // flag
  FilterModel("Grass", Color.fromRGBO(155, 200, 155, 0.8), BlendMode.overlay, GRASS_MATRIX),
  FilterModel("Maven", Color.fromRGBO(242, 242, 242, 0.3), BlendMode.colorDodge, null), // flag
  FilterModel("Slumber", Color.fromRGBO(0, 70, 150, 0.4), BlendMode.darken, null), // flag
  FilterModel("Nashville", Color.fromRGBO(43, 42, 161, 0.3), BlendMode.colorBurn, null), // flag
  FilterModel("Faded Pink", Color.fromRGBO(243, 106, 188, 0.5), BlendMode.screen, null), // flag
  // New Filters
  FilterModel("Moon", Color(0xff383838), BlendMode.lighten, null),
  // FilterModel("Willow 2", Color(0xffd4a9af), BlendMode.overlay, null),
  FilterModel("Brannan", Color.fromRGBO(161, 44, 199, 0.31), BlendMode.lighten, null),
  FilterModel("Valencia", Color(0xff3a0339), BlendMode.saturation, null),
  FilterModel("Summers 2", Color(0xffb77d21), BlendMode.overlay, null),
];

const List<double> ORIGINAL_MATRIX = [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
// const List<double> PURPLE_MATRIX = [1.0, -0.2, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, -0.1, 0.0, 0.0, 1.2, 1.0, 0.1, 0.0, 0.0, 0.0, 1.7, 1.0, 0.0];
// const List<double> YELLOW_MATRIX = [1.0, 0.0, 0.0, 0.0, 0.0, -0.2, 1.0, 0.3, 0.1, 0.0, -0.1, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
const List<double> BW_MATRIX = [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0];
const List<double> NEWTIMES_MATRIX = [1.0, 0.0, 0.0, 0.0, 0.0, -0.4, 1.3, -0.4, 0.2, -0.1, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
const List<double> OLDTIMES_MATRIX = [0.5, 0.0, 0.5, 0.1, -0.1, -0.2, 1.2, -0.3, 0.2, -0.1, -0.2, 0.4, 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
const List<double> COLDLIFE_MATRIX = [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, -0.2, 0.2, 0.1, 0.4, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
const List<double> SEPIUM_MATRIX = [1.3, -0.3, 1.1, 0.0, 0.0, 0.0, 1.3, 0.2, 0.0, 0.0, 0.0, 0.0, 0.8, 0.2, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
const List<double> MILK_MATRIX = [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.6, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
//? GRASS_MATRIX on standby
const List<double> GRASS_MATRIX = [0.8, 0.1, 0.3, 0.0, 0.0, 0.6, 1.2, -0.1, 0.0, 0.0, 0.4, 0.3, 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
const List<double> VINTAGE_MATRIX = [0.9, 0.5, 0.1, 0.0, 0.0, 0.3, 0.8, 0.1, 0.0, 0.0, 0.2, 0.3, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
const List<double> SWEET_MATRIX = [1.0, 0.0, 0.2, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
// const List<double> SEPIA_MATRIX = [0.39, 0.769, 0.189, 0.0, 0.0, 0.349, 0.686, 0.168, 0.0, 0.0, 0.272, 0.534, 0.131, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
// const List<double> SUMMERS_MATRIX = [1.6, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, -0.2, 0.2, 0.1, 0.4, -2.0, -0.3, -1.0, 0.0, 1.0, 0.0];
// const List<double> GREENDAY_MATRIX = [0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.1, -0.1, -0.6, 1.0, 0.0];
const List<double> INVERT_MATRIX = [-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0];
const List<double> HUDSON_MATRIX = [0.6, 0.3, 0.1, 0.0, -0.1, 0.0, 0.2, -0.1, 0.0, 0.0, 0.0, 0.0, 0.80, 0.0, 0.0, -0.40, -0.60, -0.20, 1.0, 0.0];
const List<double> EARLYBIRD_MATRIX = [0.82, 0.0, 0.0, 0.0, 0.0, 0.0, 0.73, 0.0, 0.0, 0.0, 0.0, 0.0, 0.56, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
const List<double> WILLOW_MATRIX = [0.85, 0.0, 0.0, 0.0, 0.0, 0.0, 0.80, 0.0, 0.0, 0.0, 0.0, 0.0, 0.80, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
const List<double> STINSON_MATRIX = [0.94, 0.0, 0.0, 0.0, 0.0, 0.0, 0.58, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
const List<double> BLOOD_MATRIX = [-1.0, 3.0, 3.0, 0.0, -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.2, -0.5, -0.3, 0.9, 0.0];
const List<double> PASTEL_MATRIX = [1.5, -0.25, -0.25, 0.0, 0.0, -0.25, 1.5, -0.25, 0.0, 0.0, -0.25, -0.25, 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
const List<double> SATURATED_MATRIX = [3.0, -1.0, -1.0, 0.0, 0.0, -1.0, 3.0, -1.0, 0.0, 0.0, -1.0, -1.0, 3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];

///! Rejected
//* comes orange
// const List<double> FADEDBLUE_MATRIX = [1.0, 0.0, 0.5, 1.5, -1.6, 0.0, 1.0, 1.5, -0.2, 0.2, 0.0, 1.0, 1.0, -0.3, 0.4, 0.0, 0.0, -0.2, 1.0, 0.0];
//* comes red
// const List<double> CYAN_MATRIX = [0.30, 0.0, 0.0, 1.9, -2.2, 0.0, 1.0, 0.0, 0.0, 0.3, 0.0, 0.0, 1.0, 0.0, 0.5, 0.0, 0.0, 0.0, 1.0, 0.2];
//* same as BW
// const List<double> GREYSCALE_MATRIX = [0.2126, 0.7152, 0.0722, 0.0, 0.0, 0.2126, 0.7152, 0.0722, 0.0, 0.0, 0.2126, 0.7152, 0.0722, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
//* too dark red
// const List<double> ADEN_MATRIX = [0.60, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.0];
//* just like sepia.. not blue
// const List<double> BLUESKY_MATRIX = [-0.2, 1.0, 0.6, 0.1, -0.1, 0.1, 1.2, 0.0, 0.1, 0.0, 0.0, 1.2, -0.2, 0.1, 0.0, 1.4, 1.7, 2.5, 3.0, 1.0];
//* too dark pink
// const List<double> LOFT_MATRIX = [0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.42, 0.0, 0.0, 0.0, 0.0, 0.0, 0.74, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
//* too dark blue
// const List<double> NASHVILLE_MATRIX = [0.29, 0.0, 0.0, 0.0, 0.0, 0.0, 0.35, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.0];
//* too dark
// const List<double> TOASTER_MATRIX = [0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.31, 0.0, 0.0, 0.0, 0.0, 0.0, 0.06, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.0];
//* blurred.. not visible properly
// const List<double> SLUMBER_MATRIX = [0.49, 0.0, 0.0, 0.0, 0.0, 0.0, 0.41, 0.0, 0.0, 0.0, 0.0, 0.0, 0.09, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
//* too green.. dark
// const List<double> MAVEN_MATRIX = [0.01, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.10, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.0];
