import 'package:flutter/widgets.dart';

double screenHeight;

// TODO remove --> 420.44, 747.45
double screenwidth;

void initializeUtils(BuildContext context) {
  final _size = MediaQuery.of(context).size;
  screenHeight = _size.height;
  screenwidth = _size.width;
}
