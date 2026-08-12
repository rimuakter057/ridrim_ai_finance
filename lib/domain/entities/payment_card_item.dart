class PaymentCardItem {
  const PaymentCardItem({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.isDefault,
  });

  final String id;
  final String brand;
  final String last4;
  final String expiry;
  final bool isDefault;

  PaymentCardItem copyWith({bool? isDefault}) {
    return PaymentCardItem(
      id: id,
      brand: brand,
      last4: last4,
      expiry: expiry,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}