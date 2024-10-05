import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/bloc/cart/cart_cubit.dart';
import 'package:shopping_app/bloc/cart/cart_state.dart';
import 'package:shopping_app/bloc/checkout/checkout_cubit.dart';
import 'package:shopping_app/bloc/checkout/checkout_state.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartState.cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartState.cartItems[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('${product.price.toStringAsFixed(2)}'),
                      trailing: Text(
                          'x${cartState.cartItems.where((item) => item.id == product.id).length}'),
                    );
                  },
                ),
              ),
              CheckoutSummary(state: cartState),
              BlocBuilder<CheckoutCubit, CheckoutState>(
                builder: (context, checkoutState) {
                  if (checkoutState is CheckoutLoading) {
                    return CircularProgressIndicator();
                  } else if (checkoutState is CheckoutSuccess) {
                    return Text('Checkout Successful!',
                        style: TextStyle(color: Colors.green));
                  } else if (checkoutState is CheckoutFailure) {
                    return Text(checkoutState.message,
                        style: TextStyle(color: Colors.red));
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FilledButton(
                        onPressed: () => context
                            .read<CheckoutCubit>()
                            .checkout(cartState.cartItems),
                        child: Text('Proceed to Payment'),
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class CheckoutSummary extends StatelessWidget {
  final CartState state;

  CheckoutSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: TextStyle(fontSize: 16)),
              Text('${state.subtotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Promotion discount',
                  style: TextStyle(fontSize: 16, color: Colors.green)),
              Text('-${state.promotionDiscount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, color: Colors.green)),
            ],
          ),
          Divider(thickness: 1, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('${state.total.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ],
      ),
    );
  }
}
