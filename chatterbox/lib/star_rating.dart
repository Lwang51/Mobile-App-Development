//code from: https://gist.github.com/sma/1f22ef926ef878f10915aa9e00bc9eaa
//Auther: Stefan Matthias Aust
//***with a little tweaks made by me

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final void Function(int index) onChanged;
  final int value;
  final int totalRating;
  final double star;
  final String uid;
  final IconData filledStar;
  final IconData unfilledStar;

  StarRating({
    Key? key,
    required this.onChanged,
    required this.uid,
    this.value = 0,
    required this.filledStar,
    required this.unfilledStar,
    required this.totalRating,
    required this.star,
    // ignore: unnecessary_null_comparison
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final color = Theme.of(context).accentColor;
    const size = 36.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          // ignore: unnecessary_null_comparison
          onPressed: onChanged != null
              ? () {
                  onChanged(value == index + 1 ? index : index + 1);
                  _db.collection("users").doc(uid).set({
                    "totalRating": totalRating + 1,
                    "userRating": ((index + 1) / totalRating)
                  });
                }
              : null,
          color: index < value ? color : null,
          iconSize: size,
          icon: Icon(
            index < value
                ? filledStar ?? Icons.star
                : unfilledStar ?? Icons.star_border,
          ),
          padding: EdgeInsets.zero,
          tooltip: "${index + 1} of 5",
        );
      }),
    );
  }
}
