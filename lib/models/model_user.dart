enum UserRole {
  voluntario,
  ong,
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.voluntario:
        return 'Voluntário';
      case UserRole.ong:
        return 'ONG / Instituição';
    }
  }
}