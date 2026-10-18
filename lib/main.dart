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
          cardTheme: const CardThemeData(
            color: orchidPink,
          ),
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

  void _increase(int i) {
    setState(() {
      if (_items[i].quantity < 99) {
        _items[i].quantity++;
      }
    });
  }

  void _decrease(int i) {
    setState(() {
      if (_items[i].quantity > 1) {
        _items[i].quantity--;
      }
    });
  }

  void _toggle(int i, bool value) {
    setState(() {
      _items[i].gotIt = value;
    });
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
      appBar: AppBar(
        title: const Text('Mini Shopping Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, i) {
                  return CartItemTile(
                    item: _items[i],
                    onIncrease: () => _increase(i),
                    onDecrease: () => _decrease(i),
                    onToggle: (value) => _toggle(i, value),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Items: ${_items.length} | Got it: '
                      '${_items.where((item) => item.gotIt).length}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
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
          ],
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final ValueChanged<bool> onToggle;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: item.gotIt,
          activeColor: englishViolet,
          onChanged: (value) {
            if (value != null) {
              onToggle(value);
            }
          },
        ),
        title: Text(
          item.name,
          style: TextStyle(
            color: englishViolet,
            decoration: item.gotIt
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          'PHP ${item.price.toStringAsFixed(2)} each',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onDecrease,
              color: englishViolet,
              icon: const Icon(Icons.remove),
            ),
            Text('${item.quantity}'),
            IconButton(
              onPressed: onIncrease,
              color: englishViolet,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}