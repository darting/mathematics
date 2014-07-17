part of mathematics;




class Vector3 {
  
  final Float32List _elements = new Float32List(3);

  Vector3(double x, double y, double z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  Vector3 add(Vector3 other) {
    x += other.x;
    y += other.y;
    z += other.z;
    return this;
  }
  
  Vector3 sub(Vector3 other) {
    x -= other.x;
    y -= other.y;
    z -= other.z;
    return this;
  }
  
  double get length {
    return Math.sqrt(lengthSquared);
  }
  
  double get lengthSquared {
    return x * x + y * y + z * z;
  }
  
  // P dot Q = |P| |Q| * cos a
  double dot(Vector3 other) {
    return x * other.x + y * other.y + z * other.z;
  }
  
  Vector3 scale(num val) {
    x *= val;
    y *= val;
    z *= val;
    return this;
  }
  
  // projP-Q = (P dot Q / |Q| * |Q|) Q
  Vector3 projectionTo(Vector3 other) {
     return other.clone().scale(clone().dot(other) / other.lengthSquared); 
  }
  
  Vector3 cross(Vector3 other) {
    return new Vector3(y * other.z - z * other.y,
                      z * other.x - x * other.z,
                      x * other.y - y * other.x);
  }
  
  Vector3 clone() {
    return new Vector3(x, y, z);
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
}

