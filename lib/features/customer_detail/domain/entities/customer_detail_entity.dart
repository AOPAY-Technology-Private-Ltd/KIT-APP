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
  final String? deviceName;
  final String? osVersion;
  final String? sdkVersion;
  final String? appVersion;

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
    this.deviceName,
    this.osVersion,
    this.sdkVersion,
    this.appVersion,
  });

  CustomerDetailEntity copyWith({
    String? id,
    String? name,
    String? customerCode,
    String? email,
    String? mobile,
    String? imei,
    String? address,
    String? imageUrl,
    String? status,
    double? emiAmount,
    String? emiDate,
    bool? isLocked,
    String? brand,
    String? manufacturer,
    String? frp,
    String? imeiSlot1,
    String? imeiSlot2,
    String? model,
    String? purchaseDate,
    String? serialNumber,
    String? deviceName,
    String? osVersion,
    String? sdkVersion,
    String? appVersion,
  }) {
    return CustomerDetailEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      customerCode: customerCode ?? this.customerCode,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      imei: imei ?? this.imei,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      emiAmount: emiAmount ?? this.emiAmount,
      emiDate: emiDate ?? this.emiDate,
      isLocked: isLocked ?? this.isLocked,
      brand: brand ?? this.brand,
      manufacturer: manufacturer ?? this.manufacturer,
      frp: frp ?? this.frp,
      imeiSlot1: imeiSlot1 ?? this.imeiSlot1,
      imeiSlot2: imeiSlot2 ?? this.imeiSlot2,
      model: model ?? this.model,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      serialNumber: serialNumber ?? this.serialNumber,
      deviceName: deviceName ?? this.deviceName,
      osVersion: osVersion ?? this.osVersion,
      sdkVersion: sdkVersion ?? this.sdkVersion,
      appVersion: appVersion ?? this.appVersion,
    );
  }
}