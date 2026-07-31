class CustomerDetailEntity {
  final String id;
  final String name;
  final String customerCode;
  final String email;
  final String mobile;
  final String imei;
  final String address;
  final String imageUrl;
  final String status;
  final double emiAmount;
  final String emiDate;
  final bool isLocked;

  final String? brand;
  final String? manufacturer;
  final String? frp;
  final String? imeiSlot1;
  final String? imeiSlot2;
  final String? model;
  final String? purchaseDate;
  final String? serialNumber;

  const CustomerDetailEntity({
    required this.id,
    required this.name,
    required this.customerCode,
    required this.email,
    required this.mobile,
    required this.imei,
    required this.address,
    required this.imageUrl,
    required this.status,
    required this.emiAmount,
    required this.emiDate,
    required this.isLocked,
    this.brand,
    this.manufacturer,
    this.frp,
    this.imeiSlot1,
    this.imeiSlot2,
    this.model,
    this.purchaseDate,
    this.serialNumber,
  });
}