String? Function(String?) emptyValidator(String message) {
  String? inner(String? value) {
    if (value == null) return null;
    return value.isEmpty ? message : null;
  }

  return inner;
}
