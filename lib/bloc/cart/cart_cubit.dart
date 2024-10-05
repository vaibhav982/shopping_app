import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/product.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState());

  void addToCart(Product product) {
    final updatedCart = List<Product>.from(state.cartItems)..add(product);
    emit(CartState(cartItems: updatedCart));
  }

  void clearCart() {
    emit(CartState(cartItems: []));
  }

  void removeFromCart(Product product) {
    final updatedCart = List<Product>.from(state.cartItems);
    final index = updatedCart.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      updatedCart.removeAt(index);
      emit(CartState(cartItems: updatedCart));
    }
  }

  void removeAllFromCart(Product product) {
    final updatedCart =
        state.cartItems.where((item) => item.id != product.id).toList();
    emit(CartState(cartItems: updatedCart));
  }
}
