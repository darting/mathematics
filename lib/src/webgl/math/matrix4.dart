part of mathematics;




const double GLMAT_EPSILON = 0.000001;

class Matrix4 {
  final Float32List _elements = new Float32List(16);

  Matrix4(double arg0, double arg1, double arg2, double arg3, double arg4, double arg5, double arg6, double arg7, double arg8, double arg9, double arg10, double arg11, double arg12, double arg13, double arg14, double arg15) {
    setValues(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15);
  }

  Matrix4.zero();

  Matrix4.fromList(List<num> list) {
    for (var i = 0; i < 16 && i < list.length; i++) {
      _elements[i] = list[i].toDouble();
    }
  }

  Matrix4.identity() {
    setIdentity();
  }

  Matrix4.perspective(double fovy, double aspect, double near, double far) {
    var f = 1.0 / math.tan(fovy / 2),
        nf = 1 / (near - far);
    _elements[0] = f / aspect;
    _elements[1] = 0.0;
    _elements[2] = 0.0;
    _elements[3] = 0.0;
    _elements[4] = 0.0;
    _elements[5] = f;
    _elements[6] = 0.0;
    _elements[7] = 0.0;
    _elements[8] = 0.0;
    _elements[9] = 0.0;
    _elements[10] = (far + near) * nf;
    _elements[11] = -1.0;
    _elements[12] = 0.0;
    _elements[13] = 0.0;
    _elements[14] = (2 * far * near) * nf;
    _elements[15] = 0.0;
  }

  Matrix4.ortho(double left, double right, double bottom, double top, double near, double far) {
    var lr = 1 / (left - right),
        bt = 1 / (bottom - top),
        nf = 1 / (near - far);
    _elements[0] = -2 * lr;
    _elements[1] = 0.0;
    _elements[2] = 0.0;
    _elements[3] = 0.0;
    _elements[4] = 0.0;
    _elements[5] = -2 * bt;
    _elements[6] = 0.0;
    _elements[7] = 0.0;
    _elements[8] = 0.0;
    _elements[9] = 0.0;
    _elements[10] = 2 * nf;
    _elements[11] = 0.0;
    _elements[12] = (left + right) * lr;
    _elements[13] = (top + bottom) * bt;
    _elements[14] = (far + near) * nf;
    _elements[15] = 1.0;
  }

  Matrix4.frustum(double out, double left, double right, double bottom, double top, double near, double far) {
    var rl = 1 / (right - left),
        tb = 1 / (top - bottom),
        nf = 1 / (near - far);
    _elements[0] = (near * 2) * rl;
    _elements[1] = 0.0;
    _elements[2] = 0.0;
    _elements[3] = 0.0;
    _elements[4] = 0.0;
    _elements[5] = (near * 2) * tb;
    _elements[6] = 0.0;
    _elements[7] = 0.0;
    _elements[8] = (right + left) * rl;
    _elements[9] = (top + bottom) * tb;
    _elements[10] = (far + near) * nf;
    _elements[11] = -1.0;
    _elements[12] = 0.0;
    _elements[13] = 0.0;
    _elements[14] = (far * near * 2) * nf;
    _elements[15] = 0.0;
  }

  Matrix4 setValues(double arg0, double arg1, double arg2, double arg3, double arg4, double arg5, double arg6, double arg7, double arg8, double arg9, double arg10, double arg11, double arg12, double arg13, double arg14, double arg15) {
    _elements[15] = arg15;
    _elements[14] = arg14;
    _elements[13] = arg13;
    _elements[12] = arg12;
    _elements[11] = arg11;
    _elements[10] = arg10;
    _elements[9] = arg9;
    _elements[8] = arg8;
    _elements[7] = arg7;
    _elements[6] = arg6;
    _elements[5] = arg5;
    _elements[4] = arg4;
    _elements[3] = arg3;
    _elements[2] = arg2;
    _elements[1] = arg1;
    _elements[0] = arg0;
    return this;
  }

  Matrix4 setZero() {
    _elements[0] = 0.0;
    _elements[1] = 0.0;
    _elements[2] = 0.0;
    _elements[3] = 0.0;
    _elements[4] = 0.0;
    _elements[5] = 0.0;
    _elements[6] = 0.0;
    _elements[7] = 0.0;
    _elements[8] = 0.0;
    _elements[9] = 0.0;
    _elements[10] = 0.0;
    _elements[11] = 0.0;
    _elements[12] = 0.0;
    _elements[13] = 0.0;
    _elements[14] = 0.0;
    _elements[15] = 0.0;
    return this;
  }

  Matrix4 setIdentity() {
    _elements[0] = 1.0;
    _elements[1] = 0.0;
    _elements[2] = 0.0;
    _elements[3] = 0.0;
    _elements[4] = 0.0;
    _elements[5] = 1.0;
    _elements[6] = 0.0;
    _elements[7] = 0.0;
    _elements[8] = 0.0;
    _elements[9] = 0.0;
    _elements[10] = 1.0;
    _elements[11] = 0.0;
    _elements[12] = 0.0;
    _elements[13] = 0.0;
    _elements[14] = 0.0;
    _elements[15] = 1.0;
    return this;
  }

  Matrix4 clone() {
    var m = new Matrix4.zero();
    m[0] = _elements[0];
    m[1] = _elements[1];
    m[2] = _elements[2];
    m[3] = _elements[3];
    m[4] = _elements[4];
    m[5] = _elements[5];
    m[6] = _elements[6];
    m[7] = _elements[7];
    m[8] = _elements[8];
    m[9] = _elements[9];
    m[10] = _elements[10];
    m[11] = _elements[11];
    m[12] = _elements[12];
    m[13] = _elements[13];
    m[14] = _elements[14];
    m[15] = _elements[15];
    return m;
  }

  Matrix4 transpose() {
    var a01 = _elements[1],
        a02 = _elements[2],
        a03 = _elements[3],
        a12 = _elements[6],
        a13 = _elements[7],
        a23 = _elements[11];
    _elements[1] = _elements[4];
    _elements[2] = _elements[8];
    _elements[3] = _elements[12];
    _elements[4] = a01;
    _elements[6] = _elements[9];
    _elements[7] = _elements[13];
    _elements[8] = a02;
    _elements[9] = a12;
    _elements[11] = _elements[14];
    _elements[12] = a03;
    _elements[13] = a13;
    _elements[14] = a23;
    return this;
  }

  Matrix4 fromRotationTranslation(Quaternion rotation, Vector3 translation) {
    var x = rotation._elements[0],
        y = rotation._elements[1],
        z = rotation._elements[2],
        w = rotation._elements[3],
        x2 = x + x,
        y2 = y + y,
        z2 = z + z,

        xx = x * x2,
        xy = x * y2,
        xz = x * z2,
        yy = y * y2,
        yz = y * z2,
        zz = z * z2,
        wx = w * x2,
        wy = w * y2,
        wz = w * z2;

    _elements[0] = 1 - (yy + zz);
    _elements[1] = xy + wz;
    _elements[2] = xz - wy;
    _elements[3] = 0.0;
    _elements[4] = xy - wz;
    _elements[5] = 1 - (xx + zz);
    _elements[6] = yz + wx;
    _elements[7] = 0.0;
    _elements[8] = xz + wy;
    _elements[9] = yz - wx;
    _elements[10] = 1 - (xx + yy);
    _elements[11] = 0.0;
    _elements[12] = translation._elements[0];
    _elements[13] = translation._elements[1];
    _elements[14] = translation._elements[2];
    _elements[15] = 1.0;

    return this;
  }

  Matrix4 fromQuaternion(Quaternion q) {
    var x = q[0],
        y = q[1],
        z = q[2],
        w = q[3],
        x2 = x + x,
        y2 = y + y,
        z2 = z + z,

        xx = x * x2,
        yx = y * x2,
        yy = y * y2,
        zx = z * x2,
        zy = z * y2,
        zz = z * z2,
        wx = w * x2,
        wy = w * y2,
        wz = w * z2;

    _elements[0] = 1 - yy - zz;
    _elements[1] = yx + wz;
    _elements[2] = zx - wy;
    _elements[3] = 0.0;

    _elements[4] = yx - wz;
    _elements[5] = 1 - xx - zz;
    _elements[6] = zy + wx;
    _elements[7] = 0.0;

    _elements[8] = zx + wy;
    _elements[9] = zy - wx;
    _elements[10] = 1 - xx - yy;
    _elements[11] = 0.0;

    _elements[12] = 0.0;
    _elements[13] = 0.0;
    _elements[14] = 0.0;
    _elements[15] = 1.0;
    return this;
  }

  /**
     * Generates a look-at matrix with the given eye position, focal point, and up axis
     * @param [Vector3] eye Position of the viewer
     * @param [Vector3] center Point the viewer is looking at
     * @param [Vector3] up vec3 pointing up
     */
  Matrix4 lookAt(Vector3 eye, Vector3 center, Vector3 up) {
    var x0,
        x1,
        x2,
        y0,
        y1,
        y2,
        z0,
        z1,
        z2,
        len,
        eyex = eye._elements[0],
        eyey = eye._elements[1],
        eyez = eye._elements[2],
        upx = up._elements[0],
        upy = up._elements[1],
        upz = up._elements[2],
        centerx = center._elements[0],
        centery = center._elements[1],
        centerz = center._elements[2];

    if ((eyex - centerx).abs() < GLMAT_EPSILON && (eyey - centery).abs() < GLMAT_EPSILON && (eyez - centerz).abs() < GLMAT_EPSILON) {
      return setIdentity();
    }

    z0 = eyex - centerx;
    z1 = eyey - centery;
    z2 = eyez - centerz;

    len = 1 / math.sqrt(z0 * z0 + z1 * z1 + z2 * z2);
    z0 *= len;
    z1 *= len;
    z2 *= len;

    x0 = upy * z2 - upz * z1;
    x1 = upz * z0 - upx * z2;
    x2 = upx * z1 - upy * z0;
    len = math.sqrt(x0 * x0 + x1 * x1 + x2 * x2);
    if (len == 0.0) {
      x0 = 0.0;
      x1 = 0.0;
      x2 = 0.0;
    } else {
      len = 1 / len;
      x0 *= len;
      x1 *= len;
      x2 *= len;
    }

    y0 = z1 * x2 - z2 * x1;
    y1 = z2 * x0 - z0 * x2;
    y2 = z0 * x1 - z1 * x0;

    len = math.sqrt(y0 * y0 + y1 * y1 + y2 * y2);
    if (len == 0.0) {
      y0 = 0.0;
      y1 = 0.0;
      y2 = 0.0;
    } else {
      len = 1 / len;
      y0 *= len;
      y1 *= len;
      y2 *= len;
    }

    _elements[0] = x0;
    _elements[1] = y0;
    _elements[2] = z0;
    _elements[3] = 0.0;
    _elements[4] = x1;
    _elements[5] = y1;
    _elements[6] = z1;
    _elements[7] = 0.0;
    _elements[8] = x2;
    _elements[9] = y2;
    _elements[10] = z2;
    _elements[11] = 0.0;
    _elements[12] = -(x0 * eyex + x1 * eyey + x2 * eyez);
    _elements[13] = -(y0 * eyex + y1 * eyey + y2 * eyez);
    _elements[14] = -(z0 * eyex + z1 * eyey + z2 * eyez);
    _elements[15] = 1.0;

    return this;
  }

  double invert() {
    var a00 = _elements[0],
        a01 = _elements[1],
        a02 = _elements[2],
        a03 = _elements[3],
        a10 = _elements[4],
        a11 = _elements[5],
        a12 = _elements[6],
        a13 = _elements[7],
        a20 = _elements[8],
        a21 = _elements[9],
        a22 = _elements[10],
        a23 = _elements[11],
        a30 = _elements[12],
        a31 = _elements[13],
        a32 = _elements[14],
        a33 = _elements[15],

        b00 = a00 * a11 - a01 * a10,
        b01 = a00 * a12 - a02 * a10,
        b02 = a00 * a13 - a03 * a10,
        b03 = a01 * a12 - a02 * a11,
        b04 = a01 * a13 - a03 * a11,
        b05 = a02 * a13 - a03 * a12,
        b06 = a20 * a31 - a21 * a30,
        b07 = a20 * a32 - a22 * a30,
        b08 = a20 * a33 - a23 * a30,
        b09 = a21 * a32 - a22 * a31,
        b10 = a21 * a33 - a23 * a31,
        b11 = a22 * a33 - a23 * a32,

        // Calculate the determinant
        det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

    if (det == 0.0) {
      return det;
    }
    det = 1.0 / det;

    _elements[0] = (a11 * b11 - a12 * b10 + a13 * b09) * det;
    _elements[1] = (a02 * b10 - a01 * b11 - a03 * b09) * det;
    _elements[2] = (a31 * b05 - a32 * b04 + a33 * b03) * det;
    _elements[3] = (a22 * b04 - a21 * b05 - a23 * b03) * det;
    _elements[4] = (a12 * b08 - a10 * b11 - a13 * b07) * det;
    _elements[5] = (a00 * b11 - a02 * b08 + a03 * b07) * det;
    _elements[6] = (a32 * b02 - a30 * b05 - a33 * b01) * det;
    _elements[7] = (a20 * b05 - a22 * b02 + a23 * b01) * det;
    _elements[8] = (a10 * b10 - a11 * b08 + a13 * b06) * det;
    _elements[9] = (a01 * b08 - a00 * b10 - a03 * b06) * det;
    _elements[10] = (a30 * b04 - a31 * b02 + a33 * b00) * det;
    _elements[11] = (a21 * b02 - a20 * b04 - a23 * b00) * det;
    _elements[12] = (a11 * b07 - a10 * b09 - a12 * b06) * det;
    _elements[13] = (a00 * b09 - a01 * b07 + a02 * b06) * det;
    _elements[14] = (a31 * b01 - a30 * b03 - a32 * b00) * det;
    _elements[15] = (a20 * b03 - a21 * b01 + a22 * b00) * det;
    return det;
  }

  Matrix4 adjoint() {
    var out = new Matrix4.zero();
    var a00 = _elements[0],
        a01 = _elements[1],
        a02 = _elements[2],
        a03 = _elements[3],
        a10 = _elements[4],
        a11 = _elements[5],
        a12 = _elements[6],
        a13 = _elements[7],
        a20 = _elements[8],
        a21 = _elements[9],
        a22 = _elements[10],
        a23 = _elements[11],
        a30 = _elements[12],
        a31 = _elements[13],
        a32 = _elements[14],
        a33 = _elements[15];

    out[0] = (a11 * (a22 * a33 - a23 * a32) - a21 * (a12 * a33 - a13 * a32) + a31 * (a12 * a23 - a13 * a22));
    out[1] = -(a01 * (a22 * a33 - a23 * a32) - a21 * (a02 * a33 - a03 * a32) + a31 * (a02 * a23 - a03 * a22));
    out[2] = (a01 * (a12 * a33 - a13 * a32) - a11 * (a02 * a33 - a03 * a32) + a31 * (a02 * a13 - a03 * a12));
    out[3] = -(a01 * (a12 * a23 - a13 * a22) - a11 * (a02 * a23 - a03 * a22) + a21 * (a02 * a13 - a03 * a12));
    out[4] = -(a10 * (a22 * a33 - a23 * a32) - a20 * (a12 * a33 - a13 * a32) + a30 * (a12 * a23 - a13 * a22));
    out[5] = (a00 * (a22 * a33 - a23 * a32) - a20 * (a02 * a33 - a03 * a32) + a30 * (a02 * a23 - a03 * a22));
    out[6] = -(a00 * (a12 * a33 - a13 * a32) - a10 * (a02 * a33 - a03 * a32) + a30 * (a02 * a13 - a03 * a12));
    out[7] = (a00 * (a12 * a23 - a13 * a22) - a10 * (a02 * a23 - a03 * a22) + a20 * (a02 * a13 - a03 * a12));
    out[8] = (a10 * (a21 * a33 - a23 * a31) - a20 * (a11 * a33 - a13 * a31) + a30 * (a11 * a23 - a13 * a21));
    out[9] = -(a00 * (a21 * a33 - a23 * a31) - a20 * (a01 * a33 - a03 * a31) + a30 * (a01 * a23 - a03 * a21));
    out[10] = (a00 * (a11 * a33 - a13 * a31) - a10 * (a01 * a33 - a03 * a31) + a30 * (a01 * a13 - a03 * a11));
    out[11] = -(a00 * (a11 * a23 - a13 * a21) - a10 * (a01 * a23 - a03 * a21) + a20 * (a01 * a13 - a03 * a11));
    out[12] = -(a10 * (a21 * a32 - a22 * a31) - a20 * (a11 * a32 - a12 * a31) + a30 * (a11 * a22 - a12 * a21));
    out[13] = (a00 * (a21 * a32 - a22 * a31) - a20 * (a01 * a32 - a02 * a31) + a30 * (a01 * a22 - a02 * a21));
    out[14] = -(a00 * (a11 * a32 - a12 * a31) - a10 * (a01 * a32 - a02 * a31) + a30 * (a01 * a12 - a02 * a11));
    out[15] = (a00 * (a11 * a22 - a12 * a21) - a10 * (a01 * a22 - a02 * a21) + a20 * (a01 * a12 - a02 * a11));
    return out;
  }

  double determinant() {
    var a00 = _elements[0],
        a01 = _elements[1],
        a02 = _elements[2],
        a03 = _elements[3],
        a10 = _elements[4],
        a11 = _elements[5],
        a12 = _elements[6],
        a13 = _elements[7],
        a20 = _elements[8],
        a21 = _elements[9],
        a22 = _elements[10],
        a23 = _elements[11],
        a30 = _elements[12],
        a31 = _elements[13],
        a32 = _elements[14],
        a33 = _elements[15],

        b00 = a00 * a11 - a01 * a10,
        b01 = a00 * a12 - a02 * a10,
        b02 = a00 * a13 - a03 * a10,
        b03 = a01 * a12 - a02 * a11,
        b04 = a01 * a13 - a03 * a11,
        b05 = a02 * a13 - a03 * a12,
        b06 = a20 * a31 - a21 * a30,
        b07 = a20 * a32 - a22 * a30,
        b08 = a20 * a33 - a23 * a30,
        b09 = a21 * a32 - a22 * a31,
        b10 = a21 * a33 - a23 * a31,
        b11 = a22 * a33 - a23 * a32;

    // Calculate the determinant
    return b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;
  }

  void copyForm(Matrix4 matrix) {
    for (var i = 0; i < 16; i++) {
      _elements[i] = matrix[i].toDouble();
    }
  }
  
  /**
   * copy translation to [ref]
   */
  void copyTranslation(Vector3 ref) {
    ref[0] = _elements[12];
    ref[1] = _elements[13];
    ref[2] = _elements[14];
  }

  double operator [](int i) => _elements[i];

  void operator []=(int i, double v) {
    _elements[i] = v;
  }
}
