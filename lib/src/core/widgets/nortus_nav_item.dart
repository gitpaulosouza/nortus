enum NortusNavItem { news, profile }

extension NortusNavItemExtension on NortusNavItem {
  String get label {
    switch (this) {
      case NortusNavItem.news:
        return 'Notícias';
      case NortusNavItem.profile:
        return 'Meu perfil';
    }
  }

  String get route {
    switch (this) {
      case NortusNavItem.news:
        return '/news';
      case NortusNavItem.profile:
        return '/profile';
    }
  }
}
