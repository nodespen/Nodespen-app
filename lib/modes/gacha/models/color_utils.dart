import 'dart:ui' show Color;

int colorToInt(Color c) => ((c.a * 255).round() << 24) |
    ((c.r * 255).round() << 16) |
    ((c.g * 255).round() << 8) |
    (c.b * 255).round();

Color intToColor(int v) => Color.fromARGB(
    (v >> 24) & 0xFF, (v >> 16) & 0xFF,
    (v >> 8) & 0xFF, v & 0xFF);
