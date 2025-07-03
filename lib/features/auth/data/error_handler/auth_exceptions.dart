class AuthExceptionHandler {
  static String handleException(String code) {
    switch (code) {
      case "invalid-email":
        return "The email address is badly formatted.";
      case "wrong-password":
        return "The password is incorrect. Please try again.";
      case "user-not-found":
        return "No user found with this email.";
      case "user-disabled":
        return "This user has been disabled. Please contact support.";
      case "email-already-in-use":
        return "This email is already in use. Try another one.";
      case "operation-not-allowed":
        return "Signing in with email and password is not enabled.";
      case "weak-password":
        return "The password is too weak. Please choose a stronger password.";
      default:
        return "An unexpected error occurred. Please try again.";
    }
  }
}
