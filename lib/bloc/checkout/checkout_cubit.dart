import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../models/product.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());
  void reset() {
    emit(CheckoutInitial());
  }

  void checkout(List<Product> products) async {
    emit(CheckoutLoading());
    try {
      final response = await http.post(
        //192.168.1.36
        //192.168.190.105
        Uri.parse('http://192.168.1.36:8080/orders/checkout'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'products': products.map((e) => e.id).toList()}),
      );
      if (response.statusCode == 204) {
        emit(CheckoutSuccess());
      } else {
        emit(CheckoutFailure('Failed to checkout. Please try again later.'));
      }
    } catch (e) {
      emit(CheckoutFailure('Failed to checkout. Please try again later.'));
    }
  }
}
