part of mathematics;




class Vector3 {
  final Float32List _elements;

  Vector3(double x, double y, double z) : _elements = new Float32List(3) {
    setValues(x, y, z);
  }

  Vector3.zero() : _elements = new Float32List(3);

  Vector3.all(double d) : this(d, d, d);

  void setValues(double x, double y, double z) {
    _elements[0] = x;
    _elements[1] = y;
    _elements[2] = z;
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

  void copyFrom(Vector3 target) {
    for (var i = 0; i < 3; i++) {
      _elements[i] = target._elements[i];
    }
  }
}
