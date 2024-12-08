import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget loadingAnimatedWidget({required IconData pageIcon}) {
  //* the icon size
  const double iconSize = 50;

  //* ui tree
  return Stack(
    alignment: AlignmentDirectional.center,
    children: [
      //* middle side icon
      Icon(
        pageIcon,
        color: Colors.teal,
      ),

      //* loading animation
      LoadingAnimationWidget.discreteCircle(
          color: Colors.teal,
          secondRingColor: Colors.teal.withOpacity(.7),
          thirdRingColor: Colors.teal.withOpacity(.2),
          size: iconSize),
    ],
  );
}
