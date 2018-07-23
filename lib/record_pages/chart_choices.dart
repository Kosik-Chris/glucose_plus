import 'package:flutter/material.dart';

class ChartChoice {
  const ChartChoice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<ChartChoice> choices = const <ChartChoice>[
  const ChartChoice(title: 'Save', icon: Icons.save),
  const ChartChoice(title: 'Change graph type', icon: Icons.gradient),
  const ChartChoice(title: 'Load external data', icon: Icons.file_upload),
  const ChartChoice(title: 'Export Graph', icon: Icons.file_download)
];