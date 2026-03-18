import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_http_client/api_http_client.dart';
import 'package:repository/repository.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  static const path = '/payment-history';

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  bool _isLoading = true;
  List<PaymentHistoryItem> _orders = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final response =
        await context.read<OrderRepository>().getPaymentHistory();
    await response.when<void>(
      success: (PaymentHistoryResponse res) async {
        if (mounted) {
          setState(() {
            _orders = res.orders;
            _isLoading = false;
          });
        }
      },
      failure: (error) async {
        if (mounted) {
          setState(() {
            _error = error;
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Payment History',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _fetchHistory,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 64,
                color: Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No payment history',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your completed orders will appear here.',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchHistory,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = _orders[index];
          return _OrderHistoryCard(order: order);
        },
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  const _OrderHistoryCard({required this.order});

  final PaymentHistoryItem order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              _StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 12),

          // Details
          _DetailRow(label: 'Total', value: '\$${order.totalAmount.toStringAsFixed(2)}'),
          const SizedBox(height: 6),
          _DetailRow(label: 'Payment', value: order.paymentMethod?.name ?? '-'),
          const SizedBox(height: 6),
          _DetailRow(
            label: 'Payment Status',
            value: order.paymentStatus,
            valueColor: order.paymentStatus == 'PAID'
                ? Colors.green
                : order.paymentStatus == 'FAILED'
                    ? Colors.red
                    : Colors.orange,
          ),
          const SizedBox(height: 6),
          _DetailRow(label: 'Type', value: order.fulfillmentType),
          if (order.deliveryAddress != null) ...[
            const SizedBox(height: 6),
            _DetailRow(label: 'Address', value: order.deliveryAddress!),
          ],
          const SizedBox(height: 6),
          _DetailRow(label: 'Date', value: order.createdAt),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'PROCESSING':
        color = Colors.blue;
        break;
      case 'PENDING':
        color = Colors.orange;
        break;
      case 'CANCELLED':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.black45, fontSize: 13)),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
