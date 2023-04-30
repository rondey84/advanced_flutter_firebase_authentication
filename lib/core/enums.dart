enum AuthMethod {
  email_password('password'),
  google('google.com'),
  facebook('facebook.com'),
  phone('phone');

  const AuthMethod(this.signInProvider);
  final String signInProvider;
}
