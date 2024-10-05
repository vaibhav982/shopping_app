import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/bloc/cart/cart_cubit.dart';
import 'package:shopping_app/bloc/cart/cart_state.dart';
import 'package:shopping_app/bloc/checkout/checkout_cubit.dart';
import 'package:shopping_app/bloc/checkout/checkout_state.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/widgets/cart_item.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, checkoutState) {
          if (checkoutState is CheckoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Something went wrong'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, checkoutState) {
          return BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              if (checkoutState is CheckoutSuccess) {
                return SuccessView();
              }

              if (cartState.cartItems.isEmpty) {
                return EmptyCartView();
              }

              Map<int, List<Product>> groupedItems = {};
              for (var item in cartState.cartItems) {
                if (!groupedItems.containsKey(item.id)) {
                  groupedItems[item.id!] = [];
                }
                groupedItems[item.id]!.add(item);
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: groupedItems.length,
                      itemBuilder: (context, index) {
                        final productId = groupedItems.keys.elementAt(index);
                        final products = groupedItems[productId]!;
                        return CartItem(
                            product: products.first, quantity: products.length);
                      },
                    ),
                  ),
                  CartSummary(state: cartState),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Empty Cart',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Go to shopping'),
          ),
        ],
      ),
    );
  }
}

class SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 64),
          SizedBox(height: 16),
          Text(
            'Success!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 8),
          Text(
            'Thank you for shopping with us!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              context.read<CartCubit>().clearCart();
              context.read<CheckoutCubit>().reset();
              Navigator.of(context).pop();
            },
            child: Text('Shop again'),
          ),
        ],
      ),
    );
  }
}

// EmptyCartView and CartItem remain the same

class CartSummary extends StatelessWidget {
  final CartState state;

  CartSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.primary)),
              Text('${state.subtotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Promotion discount',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.primary)),
              Text('-${state.promotionDiscount.toStringAsFixed(2)}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.red)),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${state.total.toStringAsFixed(2)}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.primary)),
              BlocBuilder<CheckoutCubit, CheckoutState>(
                builder: (context, checkoutState) {
                  if (checkoutState is CheckoutLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    width: 180,
                    child: FilledButton(
                      onPressed: () => context
                          .read<CheckoutCubit>()
                          .checkout(state.cartItems),
                      child: Text('Checkout'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
