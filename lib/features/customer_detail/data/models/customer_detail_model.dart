import '../../domain/entities/customer_detail_entity.dart';
import '../../../../core/constants/apiconstants/api_constants.dart';

class CustomerDetailModel extends CustomerDetailEntity {
  const CustomerDetailModel({
    required super.id,
    required super.name,
    required super.customerCode,
    required super.email,
    required super.mobile,
    required super.imei,
    required super.address,
    required super.imageUrl,
    required super.status,
    required super.emiAmount,
    required super.emiDate,
    required super.isLocked,
    super.brand,
    super.manufacturer,
    super.frp,
    super.imeiSlot1,
    super.imeiSlot2,
    super.model,
    super.purchaseDate,
    super.serialNumber,
  });

  factory CustomerDetailModel.fromJson(Map<String, dynamic> json) {
    String rawPath = json['custPhoto_path'] ?? json['imageUrl'] ?? json['custPhoto'] ?? '';
    String fullImageUrl = '';

    if (rawPath.isNotEmpty) {
      if (rawPath.startsWith('http')) {
        fullImageUrl = rawPath;
      } else {
        fullImageUrl = '${ApiConstants.mainBaseUrl}${rawPath.startsWith('/') ? '' : '/'}$rawPath';
      }
    }

    String firstName = json['firstName'] ?? '';
    String lastName = json['lastName'] ?? '';
    String fullName = json['name'] ?? (firstName.isNotEmpty ? '$firstName $lastName' : 'Customer');

    String flat = json['flatNo'] ?? '';
    String area = json['aearSector'] ?? '';
    String currentAddr = json['currentAddress'] ?? '';
    String city = json['cityName'] ?? '';
    String state = json['stateName'] ?? '';
    String pin = json['pinCode'] ?? '';
    String country = json['country'] ?? '';

    List<String> addressParts = [flat, area, currentAddr, city, state, country, pin]
        .where((part) => part != null && part.toString().trim().isNotEmpty)
        .map((e) => e.toString())
        .toList();

    String formattedAddress = addressParts.isNotEmpty ? addressParts.join(', ') : (json['address'] ?? 'N/A');

    bool lockedStatus = json['isDeviceLocked'] ?? json['isLocked'] ?? false;

    return CustomerDetailModel(
      id: json['id']?.toString() ?? json['srNo']?.toString() ?? '',
      name: fullName,
      customerCode: json['customerCodes'] ?? json['customerCode'] ?? '',
      email: json['eMailID'] ?? json['email'] ?? '',
      mobile: json['primaryMobileNumber'] ?? json['mobile'] ?? '',
      imei: json['imeiNumber1'] ?? json['imei'] ?? '',
      address: formattedAddress,
      imageUrl: fullImageUrl,
      status: json['customerActiveStatus'] ?? json['status'] ?? 'Active',
      emiAmount: double.tryParse(json['emiAmount']?.toString() ?? '0.0') ?? 0.0,
      emiDate: json['purchaseDate'] ?? json['emiDate'] ?? '',
      isLocked: lockedStatus,
      brand: json['brandName'] ?? json['brand'],
      manufacturer: json['manufacturer'],
      frp: json['frp'],
      imeiSlot1: json['imeiNumber1'] ?? json['imeiSlot1'],
      imeiSlot2: json['imeiNumber2'] ?? json['imeiSlot2'],
      model: json['modelName'] ?? json['model'],
      purchaseDate: json['purchaseDate'],
      serialNumber: json['serialNumber'],
    );
  }
}