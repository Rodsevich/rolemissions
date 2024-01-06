abstract class Permission {
  Permission();
}

enum PermissionsEntity {
  read,
  write,
  update,
  delete;

  int get value => index >> 1;
}
