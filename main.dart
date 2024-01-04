void main(){
  print(0x001);
}
  //modelos

  sealed class Role{
    List<Permission> permissions;
    //0b0010101010101010101
  }

  abstract class Permission{

  }

  enum EntityPermissions{
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

