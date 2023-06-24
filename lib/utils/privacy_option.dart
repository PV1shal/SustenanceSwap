/// enum for privacy option in post
enum PrivacyOption {
  onlyMe,
  public,
}

/// get value returns privacy in string
extension PrivacyOptionExtension on PrivacyOption {
  String get value {
    switch (this) {
      case PrivacyOption.onlyMe:
        return "My University";
      case PrivacyOption.public:
        return "Public";
    }
  }
}
