part of mathematics;




class Color extends Vector4 {

  Color(num r, num g, num b, [num alpha = 1.0]) {
    _elements[0] = r.toDouble();
    _elements[1] = g.toDouble();
    _elements[2] = b.toDouble();
    _elements[3] = alpha;
  }

  Color.fromList(List list) {
    _elements[0] = list[0].toDouble();
    _elements[1] = list[1].toDouble();
    _elements[2] = list[2].toDouble();
    if (list.length >= 4) {
      _elements[3] = list[3].toDouble();
    } else {
      _elements[3] = 1.0;
    }
  }

  Color.fromHex(num hex) {
    hexColor = hex;
  }

  set hexColor(num hexColor) {
    var h = hexColor.floor().toInt();
    _elements[0] = ((h & 0xFF0000) >> 16) / 255;
    _elements[1] = ((h & 0x00FF00) >> 8) / 255;
    _elements[2] = (h & 0x0000FF) / 255;
    _elements[3] = 1.0;
  }

  void set red(double val) {
    _elements[0] = val;
  }

  void set green(double val) {
    _elements[1] = val;
  }

  void set blue(double val) {
    _elements[2] = val;
  }

  void set alpha(double val) {
    _elements[3] = val;
  }

  double get red => _elements[0];
  double get green => _elements[1];
  double get blue => _elements[2];
  double get alpha => _elements[3];

}
