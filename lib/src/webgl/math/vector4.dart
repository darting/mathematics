part of mathematics;




class Vector4 {
  final Float32List _elements;

  Vector4(double x, double y, double z, double w) : _elements = new Float32List(4) {
    setValues(x, y, z, w);
  }

  Vector4.fromList(List<num> list) : _elements = new Float32List(4) {
    for (var i = 0; i < list.length && i < 4; i++) {
      _elements[i] = list[i].toDouble();
    }
  }

  Vector4.zero() : _elements = new Float32List(4);

  void setValues(double x, double y, double z, double w) {
    _elements[0] = x;
    _elements[1] = y;
    _elements[2] = z;
    _elements[3] = w;
  }

  double operator [](int i) => _elements[i];

  void operator []=(int i, double v) {
    _elements[i] = v;
  }

  double get x => _elements[0];
  void set x(num val) {
    _elements[0] = val.toDouble();
  }

  double get y => _elements[1];
  void set y(num val) {
    _elements[1] = val.toDouble();
  }

  double get z => _elements[2];
  void set z(num val) {
    _elements[2] = val.toDouble();
  }

  double get w => _elements[3];
  void set w(num val) {
    _elements[3] = val.toDouble();
  }
}
