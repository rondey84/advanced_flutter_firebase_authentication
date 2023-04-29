enum AuthMethod {
  email_password('password'),
  google('google.com'),
  apple('apple.com');
  // phone('phone');

  const AuthMethod(this.signInProvider);
  final String signInProvider;
}
