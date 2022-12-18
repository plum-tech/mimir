import 'package:flutter/material.dart';

Widget cardTitle(String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const SizedBox(width: 10),
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
        overflow: TextOverflow.fade,
      )
    ],
  );
}

Widget buildCard(String title, Widget content) {
  return Card(
      elevation: 3,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Column(children: [cardTitle(title), content])));
}
