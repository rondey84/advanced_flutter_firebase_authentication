enum AuthMethod {
  email_password('password'),
  google('google.com'),
  // TODO: Add Facebooks provider value
  facebook(''),
  apple('apple.com');
  // phone('phone');

  const AuthMethod(this.signInProvider);
  final String signInProvider;
}
