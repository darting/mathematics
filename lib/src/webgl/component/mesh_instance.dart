part of mathematics;




class MeshInstance extends Component {
  Mesh mesh;
  MeshInstance(this.mesh) {
    if(mesh == null) throw new Exception("mesh could not be null");
  }
}