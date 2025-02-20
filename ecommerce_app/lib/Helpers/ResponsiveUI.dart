import 'package:flutter/material.dart';

class ResponsiveUI {
  static num? baseWidth;
  static num? baseHeight;

  static w(double width, BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double deviceWidth = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;

    double percentage = (width * 100) / baseWidth!;
    return (deviceWidth * (percentage)) / 100;
  }

  static h(double height, BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double deviceHeight = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;

    double percentage = (height * 100) / baseHeight!;
    return (deviceHeight * (percentage)) / 100;
  }

  static sp(double size, BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    double screenHeight = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;

    double screenWidth = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;

    double widthScaleFactor = screenWidth / baseWidth!;
    double heightScaleFactor = screenHeight / baseHeight!;
    double scaleFactor = (widthScaleFactor + heightScaleFactor) / 2.0;
    return size * scaleFactor;
  }

  static r(double radius, BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    double screenHeight = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;

    double screenWidth = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;

    double widthScaleFactor = screenWidth / baseWidth!;
    double heightScaleFactor = screenHeight / baseHeight!;
    double scaleFactor = (widthScaleFactor + heightScaleFactor) / 2.0;
    return radius * scaleFactor;
  }

  static th(double height, double fontSize, BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    double screenHeight = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;

    double heightScaleFactor = screenHeight / baseHeight!;
    double responsiveFontSize = fontSize * heightScaleFactor;
    double responsiveLineheight = height * heightScaleFactor;
    double responsiveLineHeightMultiplier =
        responsiveLineheight / responsiveFontSize;

    return responsiveLineHeightMultiplier;
  }

  static circleRadius(double height, double width, BuildContext context) {
    double heightScaleFactor = h(height, context);
    double widthScaleFactor = w(width, context);
    double radius = widthScaleFactor < heightScaleFactor
        ? widthScaleFactor
        : heightScaleFactor;
    return radius;
  }
}
