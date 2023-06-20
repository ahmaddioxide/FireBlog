
nameValidation(value){
    if (value!.isEmpty) {
      return 'Please enter your name';
    } else if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
}

emailValidation(value){
  if (value!.isEmpty) {
    return 'Please enter your email';
  } else if (!value.contains('@')) {
    return 'Please enter a valid email';
  } else if (!value.contains('.')) {
    return 'Please enter a valid email';
  } else if (value.length < 5) {
    return 'Email must be at least 5 characters';
  } else if (value.length > 50) {
    return 'Email must be less than 50 characters';
  } else if (value.contains(' ')) {
    return 'Email cannot contain spaces';
  } else if (value.contains('..')) {
    return 'Email cannot contain consecutive periods';
  } else if (value.contains('.@')) {
    return 'Email cannot contain a period before the @ symbol';
  } else if (value.contains('@.')) {
    return 'Email cannot contain a period after the @ symbol';
  }
  return null;
}

passwordValidation(value){
  if (value!.isEmpty) {
    return 'Please enter your password';
  } else if (value.length < 8) {
    return 'Password must be at least 8 characters';
  } else if (value.length > 50) {
    return 'Password must be less than 50 characters';
  } else if (value.contains(' ')) {
    return 'Password cannot contain spaces';
  } else if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter';
  } else if (!value.contains(RegExp(r'[a-z]'))) {
    return 'Password must contain at least one lowercase letter';
  } else if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one number';
  } else if (!value
      .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password must contain at least one special character';
  }
  return null;
}

bool isValidWebsite(String? website) {
  if (website == null || website.isEmpty) {
    return true;
  }
  const pattern = r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?$';
  final regExp = RegExp(pattern, caseSensitive: false);
  return regExp.hasMatch(website);
}
