import 'package:catalog/app.components/app_bottom_navigation_bat.dart';
import 'package:catalog/app_routes.dart';
import 'package:catalog/catalog/catalog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      ref
          .read(catalogProvider.notifier)
          .changeSearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(catalogProvider);
    final products = state.filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () => _searchController.clear(),
                          icon: const Icon(Icons.close),
                        )
                      : null,
                  hintText: 'Search your product...',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
              ),
            ),

            if (state.categories.isNotEmpty)
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: state.selectedCategory == null ||
                          state.selectedCategory!.isEmpty,
                      onSelected: (_) {
                        ref
                            .read(catalogProvider.notifier)
                            .changeCategory(null);
                      },
                    ),
                    const SizedBox(width: 8),
                    ...state.categories.map((cat) {
                      final isSelected = state.selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (_) {
                            ref
                                .read(catalogProvider.notifier)
                                .changeCategory(cat);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

            const SizedBox(height: 8),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(catalogProvider.notifier).refresh(),
                child: Builder(
                  builder: (context) {
                    if (state.isLoading && state.products.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state.error != null && state.products.isEmpty) {
                      return Center(
                        child: Text(
                          'Error: ${state.error}',
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    if (products.isEmpty) {
                      return const Center(
                        child: Text('No products found.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ListTile(
                          leading: SizedBox(
                            width: 56,
                            height: 56,
                            child: Image.network(
                              product.image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                          title: Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${product.category}, \$${product.price.toStringAsFixed(2)}',
                          ),
                          onTap: () {
                            context.push('/product', extra: product);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
    );
  }
}
