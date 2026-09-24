class PlanEntity {
  final String id;
  final int kitsCount;
  final double price;
  final double pricePerKit;
  final String? discountLabel;
  final bool isMostPopular;

  const PlanEntity({
    required this.id,
    required this.kitsCount,
    required this.price,
    required this.pricePerKit,
    this.discountLabel,
    this.isMostPopular = false,
  });
}

class PaymentMethodEntity {
  final String id;
  final String name;
  final String description;
  final String icon;

  const PaymentMethodEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}