part of mathematics;




class Technique {
  Map<String, Pass> _passes = {};

  void add(Pass pass) {
    if (_passes.containsKey(pass.name)) throw new Exception("the shader ${pass.name} is exist already");
    _passes[pass.name] = pass;
  }

  void set(Pass pass) {
    if (_passes.containsKey(pass.name)) _passes.remove(pass.name).dispose();
    _passes[pass.name] = pass;
  }

  Pass get(String name) => _passes[name];

  Pass get defaultPass => _passes["default"];
}
