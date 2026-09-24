class CustomerItemEntity {
  final String id;
  final String name;
  final String customerIdCode;
  final String email;
  final String imageUrl;
  final String mobile;
  final String imei1;
  final String imei2;
  final String serialNumber;
  final String purchaseDate;
  final String scheduleLockStatus;
  final bool isLocked;

  const CustomerItemEntity({
    required this.id,
    required this.name,
    required this.customerIdCode,
    required this.email,
    required this.imageUrl,
    required this.mobile,
    required this.imei1,
    required this.imei2,
    required this.serialNumber,
    required this.purchaseDate,
    required this.scheduleLockStatus,
    required this.isLocked,
  });
}