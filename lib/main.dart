import 'package:flutter/material.dart';

const Color englishViolet = Color(0xFF563C5C);
const Color orchidPink = Color(0xFFF2BDCD);

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: englishViolet,
            foregroundColor: Colors.white,
          ),
          cardTheme: const CardThemeData(color: orchidPink),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: englishViolet,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: const CartScreen(),
      ),
    );

class CartItem {
  String name;
  double price;
  int quantity;
  bool gotIt;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
    this.gotIt = false,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _items = [];

  @override
  void initState() {
    super.initState();
    _items.add(CartItem(name: 'Tulips', price: 250, quantity: 2));
    _items.add(CartItem(name: 'Lilies', price: 250, quantity: 5));
    _items.add(CartItem(name: 'Lavender', price: 125, quantity: 1));
  }

  double get _total {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini Shopping Cart')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, i) {
                  final item = _items[i];
                  return Card(
                    child: ListTile(
                      title: Text(
                        item.name,
                        style: const TextStyle(color: englishViolet),
                      ),
                      subtitle: Text(
                        'PHP ${item.price.toStringAsFixed(2)} each',
                      ),
                      trailing: Text('x${item.quantity}'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: orchidPink,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Total: PHP ${_total.toStringAsFixed(2)}',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: englishViolet,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}