let
  keys = [
    "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAEMTnKiVKLdO8CbEprz/G0mYSbLrGDndS7aHeGh5QeN/ytpyM1QYqY5ouqCj/jX4jRhxo6gkSUIw/v8e2j02Mjr3AG0px3uIl3U2vWLwpmYKUn/Gyzd/Ih9rwYeop5m1OJzx57D3ybqYVTEXkB5n3o27YQkwLCnOD/keElWhRXAcJ3/lg=="
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7lG1J2TQNaqJLKqAzTQQ8yHBArm4o9k/eeaYLSrDuo"
  ];
in
{
  "secret1.age".publicKeys = keys;
}
