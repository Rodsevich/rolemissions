void main(){
  print(0x001);
}
  //modelos

  sealed class Role{

  }

  abstract class Permission{

  }

  enum Permissions{
    Read,
    Write,
    Update,
    Delete;

    int value => index >> 1;
  }

  0000
  0001
  0010
  0100

