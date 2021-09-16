let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAjhLyu/4VHDhhwQwKkH4++BnJtmG+MSZSbkSmKypuKj"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7lG1J2TQNaqJLKqAzTQQ8yHBArm4o9k/eeaYLSrDuo"
  ];
in
{
  "secret1.age".publicKeys = keys;
}
