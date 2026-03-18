import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/card/cubit/card_cubit.dart';
import 'package:flutter_methgo_app/features/order/cubit/order_cubit.dart';
import 'package:flutter_methgo_app/features/order/view/payment_screen.dart';
import 'package:flutter_methgo_app/features/order/view/order_success_page.dart';
import 'package:go_router/go_router.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  static const path = '/checkout';

  /// KHQR Payment Method ID from the backend
  static const khqrPaymentMethodId = '59415cc0-4436-4aa6-ab61-79f690d1f350';

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const _deliveryTypes = ['PICKUP', 'DELIVERY'];

  String _selectedDeliveryType = 'PICKUP';
  final _addressController = TextEditingController();
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, orderState) {
        if (orderState.status == OrderStatus.paymentPending) {
          setState(() => _isPlacingOrder = false);
          context.go(PaymentScreen.path);
        } else if (orderState.status == OrderStatus.success) {
          setState(() => _isPlacingOrder = false);
          context.read<CardCubit>().clearCart();
          context.go(OrderSuccessPage.path, extra: orderState.order);
        } else if (orderState.status == OrderStatus.failure) {
          setState(() => _isPlacingOrder = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(orderState.errorMessage ?? 'Failed to place order'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Checkout',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<CardCubit, CardState>(
          builder: (context, state) {
            final cart = state.cartData;

            if (cart == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ══ FULFILLMENT TYPE ═══════════════════════════════════
                  const Text(
                    'Fulfillment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: _deliveryTypes.map((type) {
                      final isSelected = _selectedDeliveryType == type;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedDeliveryType = type),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF3B82F6) : Colors.grey.shade300,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                type,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  if (_selectedDeliveryType == 'DELIVERY') ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Delivery Address',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _addressController,
                      maxLines: 3,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText: 'Enter your full address...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // ══ PAYMENT METHOD ═════════════════════════════════════
                  const Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF3B82F6),
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.qr_code_2, color: Color(0xFF3B82F6)),
                      ),
                      title: const Text(
                        'KHQR',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Pay via ABA Mobile or scan QR'),
                      trailing: const Icon(Icons.check_circle, color: Color(0xFF3B82F6)),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ══ ORDER SUMMARY ══════════════════════════════════════
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal', style: TextStyle(color: Colors.grey)),
                            Text('\$${cart.grandTotal.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Fee', style: TextStyle(color: Colors.grey)),
                            Text(_selectedDeliveryType == 'DELIVERY' ? '\$5.00' : 'Free',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                        const Divider(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Amount',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              '\$${(cart.grandTotal + (_selectedDeliveryType == 'DELIVERY' ? 5.0 : 0.0)).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: _isPlacingOrder ? null : () => _placeOrder(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: _isPlacingOrder
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Confirm & Place Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  void _placeOrder(BuildContext context) {
    // Validate address for delivery orders
    if (_selectedDeliveryType == 'DELIVERY' && _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a delivery address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    context.read<OrderCubit>().placeOrder(
      fulfillmentType: _selectedDeliveryType,
      paymentMethodId: CheckoutPage.khqrPaymentMethodId,
      deliveryAddress: _selectedDeliveryType == 'DELIVERY'
          ? _addressController.text.trim()
          : null,
    );
  }
}
