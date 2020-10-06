import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movie_night/utils/commons.dart';
import 'package:movie_night/utils/shape/custom_clipper.dart';


class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
      angle: -pi / 3.5,
      child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width,
          color: Commons.backGroundColor,
        ),
      ),
    ));
  }
}