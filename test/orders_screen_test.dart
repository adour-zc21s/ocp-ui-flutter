import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocp_flut/screens/order/order_screen.dart';

import 'package:ocp_flut/models/orders_model.dart';
import 'package:ocp_flut/screens/order/add_order_screen.dart';
import 'package:ocp_flut/screens/order/order_detail_screen.dart';

void main() {
  testWidgets('Order screen shows title and action button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrderScreen()));

    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Tambah'), findsOneWidget);
  });

  testWidgets('Add order screen shows form fields', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddOrderScreen()));

    expect(find.text('Tambah Order'), findsOneWidget);
    expect(find.text('Nama Customer'), findsOneWidget);
    expect(find.text('Tambah Item'), findsOneWidget);
  });

  testWidgets('Order detail screen shows order information', (tester) async {
    const order = Order(
      id: 'ORD-99',
      customerName: 'Sintayong',
      itemName: 'Router',
      totalAmount: 1500000,
      status: 'Pending',
      orderDate: '2026-09-16',
      branchName: 'Jakarta',
    );

    await tester.pumpWidget(
      const MaterialApp(home: OrderDetailScreen(order: order)),
    );

    expect(find.text('Detail Order'), findsOneWidget);
    expect(find.text('Sintayong'), findsOneWidget);
  });
}
