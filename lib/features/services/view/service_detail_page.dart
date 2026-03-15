import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/services/cubit/service_detail_cubit.dart';
import 'package:repository/repository.dart';
import 'package:flutter_methgo_app/features/card/cubit/card_cubit.dart';
import 'package:flutter_methgo_app/features/favorite/cubit/favorite_cubit.dart';
import 'package:flutter_methgo_app/features/pets/cubit/pets_cubit.dart';
import 'package:flutter_methgo_app/features/appointments/cubit/appointments_cubit.dart';
import 'package:api_http_client/api_http_client.dart';
import 'package:intl/intl.dart';

class ServiceDetailPage extends StatelessWidget {
  const ServiceDetailPage({super.key, required this.serviceId});

  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceDetailCubit(
        serviceRepository: context.read<ServiceRepository>(),
      )..fetchService(id: serviceId),
      child: const _ServiceDetailView(),
    );
  }
}

class _ServiceDetailView extends StatelessWidget {
  const _ServiceDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceDetailCubit, ServiceDetailState>(
      builder: (context, state) {
        // ── Loading ────────────────────────────────────────────────────
        if (state.status == ServiceDetailStatus.loading ||
            state.status == ServiceDetailStatus.initial) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.white,
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          );
        }

        // ── Failure ────────────────────────────────────────────────────
        if (state.status == ServiceDetailStatus.failure) {
          return Scaffold(
            appBar: AppBar(title: const Text('Service')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 64, color: Colors.redAccent),
                  const SizedBox(height: 12),
                  Text(state.errorMessage ?? 'Failed to load service',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => context
                        .read<ServiceDetailCubit>()
                        .fetchService(id: ''),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final service = state.service!;

        return Scaffold(
          backgroundColor: const Color(0xFFF0F4FF),
          body: CustomScrollView(
            slivers: [
              // ── Hero SliverAppBar ─────────────────────────────────────
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF7C3AED),
                actions: [
                  BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, favoriteState) {
                      // Check if this service is in the global favorites list
                      final isFavoritedInList = favoriteState.favorites.any(
                        (f) => f.type == 'service' && f.itemId == service.id,
                      );
                      
                      // Use either the service's own isFavorite field OR the global list status
                      final isFavorite = service.isFavorite || isFavoritedInList;

                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          context.read<FavoriteCubit>().toggleFavorite(
                                id: service.id,
                                itemType: 'service',
                              );
                        },
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    service.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image or gradient fallback
                      if (service.imageUrl != null &&
                          service.imageUrl!.startsWith('http'))
                        Image.network(
                          service.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _gradientBox,
                        )
                      else
                        _gradientBox,
                      // Bottom scrim
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black54],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Body content ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price + Duration chips
                      Wrap(
                        spacing: 10,
                        children: [
                          _Chip(
                            icon: Icons.attach_money_rounded,
                            label: '\$${service.price}',
                            color: const Color(0xFF7C3AED),
                          ),
                          if (service.durationMinutes > 0)
                            _Chip(
                              icon: Icons.timer_outlined,
                              label: '${service.durationMinutes} min',
                              color: const Color(0xFF6366F1),
                            ),
                          _Chip(
                            icon: Icons.circle,
                            label: service.status,
                            color: Colors.green,
                            iconSize: 8,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Description card
                      _SectionCard(
                        icon: Icons.description_outlined,
                        title: 'Description',
                        child: Text(
                          service.description.isNotEmpty
                              ? service.description
                              : 'No description available.',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            height: 1.7,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // What's included card
                      _SectionCard(
                        icon: Icons.checklist_rounded,
                        title: 'Service Info',
                        child: Column(
                          children: [
                            _InfoRow(
                              label: 'Price',
                              value: '\$${service.price}',
                            ),
                            const Divider(height: 20),
                            _InfoRow(
                              label: 'Duration',
                              value: '${service.durationMinutes} minutes',
                            ),
                            const Divider(height: 20),
                            _InfoRow(
                              label: 'Status',
                              value: service.status,
                              valueColor: Colors.green,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<CardCubit>().addToCart(service.id, itemType: 'service');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${service.name} added to cart!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.shopping_cart_checkout_rounded),
                              label: Text(
                                'Add to Cart (\$${service.price})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showBookingDialog(context, service),
                              icon: const Icon(Icons.calendar_today_rounded),
                              label: const Text(
                                'Book Now',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C3AED),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBookingDialog(BuildContext context, ServiceModel service) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PetsCubit>(),
        child: BlocProvider.value(
          value: context.read<AppointmentsCubit>(),
          child: _BookingSheet(service: service),
        ),
      ),
    );
  }

  Widget get _gradientBox => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Icon(Icons.spa_rounded, size: 80, color: Colors.white54),
        ),
      );
}

class _BookingSheet extends StatefulWidget {
  const _BookingSheet({required this.service});
  final ServiceModel service;

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  String? _selectedPetId;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  final _requestController = TextEditingController();

  @override
  void dispose() {
    _requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Book ${widget.service.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Pet Selection
            const Text('Select Pet',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            BlocBuilder<PetsCubit, PetsState>(
              builder: (context, state) {
                if (state.status == PetsStatus.loading && state.pets.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == PetsStatus.failure && state.pets.isEmpty) {
                  return Column(
                    children: [
                      Text(state.errorMessage ?? 'Failed to load pets'),
                      TextButton(
                        onPressed: () => context.read<PetsCubit>().fetchPets(),
                        child: const Text('Retry'),
                      ),
                    ],
                  );
                }
                if (state.pets.isEmpty) {
                  return const Text('No pets found. Please add a pet first.');
                }
                return SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.pets.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final pet = state.pets[index];
                      final isSelected = _selectedPetId == pet.id;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedPetId = pet.id),
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF7C3AED)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                image: pet.imageUrl != null && pet.imageUrl!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(pet.imageUrl!),
                                        fit: BoxFit.cover)
                                    : null,
                                color: Colors.grey.shade200,
                              ),
                              child: (pet.imageUrl == null || pet.imageUrl!.isEmpty)
                                  ? const Icon(Icons.pets)
                                  : null,
                            ),
                            const SizedBox(height: 4),
                            Text(pet.name,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Date & Time
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Date',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 90)),
                          );
                          if (date != null) setState(() => _selectedDate = date);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 18, color: Color(0xFF7C3AED)),
                              const SizedBox(width: 8),
                              Text(DateFormat('MMM dd, yyyy')
                                  .format(_selectedDate)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Time',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (time != null) setState(() => _selectedTime = time);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 18, color: Color(0xFF7C3AED)),
                              const SizedBox(width: 8),
                              Text(_selectedTime.format(context)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Special Requests
            const Text('Special Requests',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _requestController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Any special instructions for the groomer...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            BlocConsumer<AppointmentsCubit, AppointmentsState>(
              listener: (context, state) {
                if (state.status == AppointmentsStatus.success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Appointment booked successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state.status == AppointmentsStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'Booking failed'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.status == AppointmentsStatus.loading
                      ? null
                      : () {
                          if (_selectedPetId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a pet')),
                            );
                            return;
                          }

                          final startDateTime = DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            _selectedTime.hour,
                            _selectedTime.minute,
                          );

                          final request = BookAppointmentRequest(
                            petId: _selectedPetId!,
                            serviceId: widget.service.id,
                            startTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(startDateTime),
                            specialRequests: _requestController.text,
                          );

                          context
                              .read<AppointmentsCubit>()
                              .bookAppointment(request);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: state.status == AppointmentsStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Confirm Booking',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.color,
    this.iconSize = 16,
  });
  final IconData icon;
  final String label;
  final Color color;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });
  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF7C3AED)),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
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
        Text(label,
            style: const TextStyle(color: Colors.black45, fontSize: 14)),
        Text(value,
            style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      ],
    );
  }
}
