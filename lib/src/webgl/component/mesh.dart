part of mathematics;




class Mesh extends Component {
  
  List<SubMesh> _subMeshes = [];

  @override
  void _targetAdded(Node target) {
    // TODO: implement _targetAdded
  }

  @override
  void _targetRemoved(Node target) {
    // TODO: implement _targetRemoved
  }
}

class SubMesh {
  int _start;
  int _count;
  int _material;
}