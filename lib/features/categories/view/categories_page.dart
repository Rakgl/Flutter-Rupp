import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/features/categories/cubit/categories_cubit.dart';
import 'package:flutter_methgo_app/features/categories/view/category_detail_page.dart';
import 'package:flutter_methgo_app/features/shared/widgets/category_cart.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  static const path = '/categories';

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // ── Gradient SliverAppBar ────────────────────────────────
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFF3B82F6),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding:
                      const EdgeInsets.only(left: 20, bottom: 16),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (state.categories.isNotEmpty)
                        Text(
                          '${state.categories.length} types available',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF3B82F6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16, bottom: 16),
                        child: Icon(
                          Icons.grid_view_rounded,
                          size: 110,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── States ───────────────────────────────────────────────
              if (state.status == CategoriesStatus.loading ||
                  state.status == CategoriesStatus.initial)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.status == CategoriesStatus.failure)
                SliverFillRemaining(
                  child: _ErrorView(
                    message:
                        state.errorMessage ?? 'Failed to fetch categories',
                    onRetry: () =>
                        context.read<CategoriesCubit>().fetchCategories(),
                  ),
                )
              else if (state.categories.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.category_outlined,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('No categories found',
                            style:
                                TextStyle(fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.82,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = state.categories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => CategoryDetailPage(
                                  categoryId: category.id,
                                ),
                              ),
                            );
                          },
                          child: CategoryCart(
                            type: category.type ?? '',
                            name: category.name,
                            description: category.description,
                            image: category.imageUrl ?? '',
                          ),
                        );
                      },
                      childCount: state.categories.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
