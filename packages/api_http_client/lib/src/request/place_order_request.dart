
class PlaceOrderRequest {
  final List<String> pharmacyIds;
  final String paymentMethodId;
  final String deliveryMethod;
  final double deliveryFee;
  final String addressLine1;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  PlaceOrderRequest({
    required this.pharmacyIds,
    required this.paymentMethodId,
    required this.deliveryMethod,
    required this.deliveryFee,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'pharmacy_ids': pharmacyIds,
      'payment_method_id': paymentMethodId,
      'delivery_method': deliveryMethod,
      'delivery_fee': deliveryFee,
      'address_line_1': addressLine1,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
    };
  }
}