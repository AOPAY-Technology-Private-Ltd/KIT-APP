class ProfileEntity {
  final String name;
  final String phone;
  final String email;
  final String avatarUrl;
  final int kitBalance;
  final int totalKits;

  const ProfileEntity({
    required this.name,
    required this.phone,
    required this.email,
    required this.avatarUrl,
    required this.kitBalance,
    required this.totalKits,
  });
}