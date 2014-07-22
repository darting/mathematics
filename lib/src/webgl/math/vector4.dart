part of mathematics;




class Vector4 {
  final Float32List _elements = new Float32List(4);
  
  double operator [](int i) => _elements[i];

  void operator []=(int i, double v) {
    _elements[i] = v;
  }
}