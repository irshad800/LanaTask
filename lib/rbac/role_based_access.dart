class RoleBasedAccessControl {
  final String role;

  RoleBasedAccessControl(this.role);

  bool isAdmin() {
    return role == 'admin';
  }

  bool isUser() {
    return role == 'user';
  }
}
