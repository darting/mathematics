part of mathematics;




class Vector2 {
  final Float32List _elements;

  Vector2(double x, double y) : _elements = new Float32List(2) {
    setValues(x, y);
  }

  Vector2.zero() : _elements = new Float32List(2);

  Vector2.all(double d) : this(d, d);

  void setValues(double x, double y) {
    _elements[0] = x;
    _elements[1] = y;
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
}
