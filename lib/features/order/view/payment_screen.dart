import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_methgo_app/features/order/cubit/order_cubit.dart';
import 'package:flutter_methgo_app/features/card/cubit/card_cubit.dart';
import 'package:flutter_methgo_app/features/order/view/order_success_page.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  static const path = '/payment';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state.status == OrderStatus.paymentConfirmed) {
          context.read<CardCubit>().clearCart();
          context.go(OrderSuccessPage.path, extra: state.order);
        } else if (state.status == OrderStatus.cancelled) {
          context.go('/main');
        }
      },
      builder: (context, state) {
        if (state.status == OrderStatus.paymentExpired) {
          return _PaymentExpiredView(state: state);
        }

        return _PaymentPendingView(state: state);
      },
    );
  }
}

class _PaymentPendingView extends StatelessWidget {
  const _PaymentPendingView({required this.state});

  final OrderState state;

  @override
  Widget build(BuildContext context) {
    final order = state.order;
    final paymentInfo = state.paymentInfo;
    final qrData = paymentInfo?.qrData;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Complete Payment',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Order info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Order: ${order?.orderNumber ?? ''}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${order?.totalAmount.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // QR Code
            if (qrData != null && qrData.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Scan with ABA Mobile',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 220,
                      gapless: true,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Countdown timer
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: state.remainingSeconds <= 60
                    ? Colors.red.shade50
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: state.remainingSeconds <= 60
                        ? Colors.red
                        : Colors.orange.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Expires in ${state.formattedCountdown}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: state.remainingSeconds <= 60
                          ? Colors.red
                          : Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Open ABA App button
            if (paymentInfo?.abapayDeeplink != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openAbaApp(context, paymentInfo!.abapayDeeplink!),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text(
                    'Open ABA App',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Cancel Order button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: state.status == OrderStatus.cancelling
                    ? null
                    : () => _showCancelDialog(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: const BorderSide(color: Colors.red),
                ),
                child: state.status == OrderStatus.cancelling
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Cancel Order',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAbaApp(BuildContext context, String deeplink) async {
    final uri = Uri.parse(deeplink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ABA app is not installed. Please scan the QR code instead.'),
          ),
        );
      }
    }
  }

  void _showCancelDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Order?'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<OrderCubit>().cancelOrder();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}

class _PaymentExpiredView extends StatelessWidget {
  const _PaymentExpiredView({required this.state});

  final OrderState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Payment Expired',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_off, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Payment Expired',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'The payment window for order ${state.order?.orderNumber ?? ''} has expired.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<OrderCubit>().cancelOrder();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text(
                    'Cancel Order',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/main'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
