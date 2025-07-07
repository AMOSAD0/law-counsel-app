class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    } else if (value.trim().length < 3) {
      return 'الاسم يجب أن يكون على الأقل 3 أحرف';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }

    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }

    final regex = RegExp(r'^(010|011|012|015)[0-9]{8}$');
    if (!regex.hasMatch(value)) {
      return 'رقم الهاتف غير صالح';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }

    if (value != password) {
      return 'كلمتا المرور غير متطابقتين';
    }

    return null;
  }

  static String? validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'تاريخ الميلاد مطلوب';
    }
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'المدينة مطلوبة';
    }
    return null;
  }
  static String? validateIdImg(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'من فضلك ارفع صورة البطاقة الشخصية';
    }
    return null;
  }

  static String? validateBarImg(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'من فضلك ارفع صورة كارنيه النقابة';
    }
    return null;
  }

  static String? validateSpecializations(List<String> specs) {
  if (specs.isEmpty) {
    return 'يجب اختيار تخصص واحد على الأقل';
  }
  return null;
}
}
