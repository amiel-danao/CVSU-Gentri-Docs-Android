import '../providers/auth_provider.dart';

class AppConstants {
  static const appTitle = "Gentri-Docs";
  static const loginTitle = "Gentri-Docs - Login";
  static const chatListTitle = "Gentri-Docs - Veterinarians";
  static const profileTitle = "Profile";
  static const fullPhotoTitle = "Full Photo";
  static const petsPageTitle = "My Pets";
  static const petProfileTitle = "Edit Pet";
}

typedef AuthStateCallback = void Function(Status status);
