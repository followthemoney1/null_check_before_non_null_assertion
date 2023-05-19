void main() {
  print('hello world');

  String? giftCode;
  final s2 = giftCode != null ? giftCode : '';

  String? email;
  if (email.isNotNullNorEmpty) {
    email!.length;
  }

  String? email2;
  if (email2 == null) {
    email2!.length;
  }

  String? email3;
  if (email3 != null) {
    email3!.length;
  }

  int? s;
  s!.bitLength;
  if (s != null) {
    s.hashCode;
  }
}

extension NullableStringExtensionsNull<E> on String? {
  /// Returns `true` if this string is `null` or empty.

  /// Returns `true` if this string is not `null` and not empty.
  bool get isNotNullNorEmpty {
    return this?.isNotEmpty ?? false;
  }

  bool get isNotEmptyOrFalse {
    return this?.isNotEmpty ?? false;
  }

  bool get isNullOrEmpty {
    return this?.isEmpty ?? true;
  }
}

class Main {}
