import 'package:flutter/material.dart';
import 'package:sit/design/adaptive/editor.dart';
import 'package:sit/entity/campus.dart';

class Init{
  static void init(){
    EditorEx.registerEnumEditor(Campus.values);
    EditorEx.registerEnumEditor(ThemeMode.values);
  }
}
