/// 课表显示模式
enum DisplayMode {
  daily,
  weekly;

  static DisplayMode? at(int? index) {
    if (index == null) {
      return null;
    } else if (0 <= index && index < DisplayMode.values.length) {
      return DisplayMode.values[index];
    }
    return null;
  }

  DisplayMode toggle() => DisplayMode.values[(index + 1) & 1];
}
