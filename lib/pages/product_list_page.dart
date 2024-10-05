import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/bloc/product/product_cubit.dart';
import 'package:shopping_app/bloc/product/product_state.dart';

import '../pages/cart_page.dart';
import '../widgets/product_item.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildProductList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.stars_rounded),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage()),
      );
    }
  }

  Widget _buildProductList() {
    return SafeArea(
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial) {
            context.read<ProductCubit>().fetchProducts();
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildRecommendedProducts(state),
                _buildMainProductList(state),
              ],
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildRecommendedProducts(ProductLoaded state) {
    if (state.recommendedProductsError != null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.red[100],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading recommended products: ${state.recommendedProductsError}',
                style: TextStyle(color: Colors.red[900]),
              ),
            ),
          ),
        ),
      );
    }

    if (state.recommendedProducts.isEmpty) {
      return SliverToBoxAdapter(child: Container());
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Recommended Products',
              style: Theme.of(context).textTheme.titleLarge),
        ),
        ...state.recommendedProducts
            .map((product) => ProductItem(product: product))
            .toList(),
      ]),
    );
  }

  Widget _buildMainProductList(ProductLoaded state) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Latest Products',
              style: Theme.of(context).textTheme.titleLarge),
        ),
        ...state.products
            .map((product) => ProductItem(product: product))
            .toList(),
        if (state.isLoading)
          Center(child: CircularProgressIndicator())
        else if (state.hasReachedMax)
          Center(child: Text('No more products'))
        else if (state.mainProductsError != null)
          Card(
            color: Colors.red[100],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error loading more products: ${state.mainProductsError}',
                style: TextStyle(color: Colors.red[900]),
              ),
            ),
          ),
      ]),
    );
  }

  void _onScroll() {
    if (_isBottom) context.read<ProductCubit>().fetchProducts(loadMore: true);
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
