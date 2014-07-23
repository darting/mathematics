part of mathematics;




class Quaternion {
  final Float32List _elements;

  Quaternion.identity() : _elements = new Float32List(4) {
    _elements[3] = 1.0;
  }
  
  void setFromRotation(Matrix4 m) {
    // http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/index.htm
    // assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)
    var te = m._elements,
        m11 = te[0],
        m12 = te[4],
        m13 = te[8],
        m21 = te[1],
        m22 = te[5],
        m23 = te[9],
        m31 = te[2],
        m32 = te[6],
        m33 = te[10],
        trace = m11 + m22 + m33,
        s;

    if (trace > 0) {
      s = 0.5 / math.sqrt(trace + 1.0);
      _elements[3] = 0.25 / s;
      _elements[0] = (m32 - m23) * s;
      _elements[1] = (m13 - m31) * s;
      _elements[2] = (m21 - m12) * s;
    } else if (m11 > m22 && m11 > m33) {
      s = 2.0 * math.sqrt(1.0 + m11 - m22 - m33);
      _elements[3] = (m32 - m23) / s;
      _elements[0] = 0.25 * s;
      _elements[1] = (m12 + m21) / s;
      _elements[2] = (m13 + m31) / s;

    } else if (m22 > m33) {
      s = 2.0 * math.sqrt(1.0 + m22 - m11 - m33);
      _elements[3] = (m13 - m31) / s;
      _elements[0] = (m12 + m21) / s;
      _elements[1] = 0.25 * s;
      _elements[2] = (m23 + m32) / s;
    } else {
      s = 2.0 * math.sqrt(1.0 + m33 - m11 - m22);
      _elements[3] = (m21 - m12) / s;
      _elements[0] = (m13 + m31) / s;
      _elements[1] = (m23 + m32) / s;
      _elements[2] = 0.25 * s;
    }
  }

  double operator [](int i) => _elements[i];

  void operator []=(int i, double v) {
    _elements[i] = v;
  }
}
