import 'package:flutter/material.dart';

// Custom colors used for the app theme.
const Color englishViolet = Color(0xFF563C5C);
const Color orchidPink = Color(0xFFF2BDCD);

void main() => runApp(
      MaterialApp(
        // Customization 1: Set the background color of the app.
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,

          // Customization 2: Set the AppBar colors.
          appBarTheme: const AppBarTheme(
            backgroundColor: englishViolet,
            foregroundColor: Colors.white,
          ),

          // Customization 3: Set the background color of cards.
          cardTheme: const CardThemeData(
            color: orchidPink,
          ),

          // Customization 4: Set the colors of ElevatedButtons.
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

// CartItem model stores the information for each shopping cart item.
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

// StatefulWidget allows the shopping cart screen to update when data changes.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

// State class stores the cart data and handles user interactions.
class _CartScreenState extends State<CartScreen> {
  // List that stores all shopping cart items.
  final List<CartItem> _items = [];

  // Controllers read and clear the text entered by the user.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Lifecycle method: preload sample items when the screen is created.
  @override
  void initState() {
    super.initState();

    _items.add(CartItem(name: 'Tulips', price: 250, quantity: 2));
    _items.add(CartItem(name: 'Lilies', price: 250, quantity: 5));
    _items.add(CartItem(name: 'Lavender', price: 125, quantity: 1));
  }

  // Lifecycle method: release both controllers when the screen is removed.
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Increase the quantity, but do not allow it to exceed 99.
  void _increase(int i) {
    setState(() {
      if (_items[i].quantity < 99) {
        _items[i].quantity++;
      }
    });
  }

  // Decrease the quantity, but keep it at a minimum of 1.
  void _decrease(int i) {
    setState(() {
      if (_items[i].quantity > 1) {
        _items[i].quantity--;
      }
    });
  }

  // Update the got-it checkbox and refresh the screen.
  void _toggle(int i, bool value) {
    setState(() {
      _items[i].gotIt = value;
    });
  }

  // Validate the input before adding a new item to the cart.
  void _addItem() {
    String name = _nameController.text.trim();
    double? price = double.tryParse(_priceController.text);

    // Reject an empty name, invalid price, or price that is not positive.
    if (name.isEmpty || price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid item name or price. Please enter valid values.',
          ),
        ),
      );
      return;
    }

    // Add the valid item and clear the input fields.
    setState(() {
      _items.add(CartItem(name: name, price: price));
      _nameController.clear();
      _priceController.clear();
    });
  }

  // Remove all items marked as got it.
  void _clearChecked() {
    setState(() {
      _items.removeWhere((item) => item.gotIt);
    });
  }

  // Calculate the total price of all items using price multiplied by quantity.
  double get _total {
    double total = 0;

    for (var item in _items) {
      total += item.price * item.quantity;
    }

    return total;
  }

  // Build the shopping cart interface.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Shopping Cart'),
      ),
      body: Padding(
        // Add space around the main content.
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Display cart items in a scrollable list.
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, i) {
                  // Pass item data and callbacks to the stateless child.
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

            // Show the number of items, checked items, and total price.
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

            const SizedBox(height: 10),

            // Text fields for entering an item name and price.
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Price (PHP)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Buttons for adding an item and clearing checked items.
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addItem,
                    child: const Text('Add'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearChecked,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: englishViolet,
                      side: const BorderSide(
                        color: englishViolet,
                      ),
                    ),
                    child: const Text('Clear checked'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// StatelessWidget displays one cart item.
// It receives data and callbacks from CartScreen and does not call setState().
class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final ValueChanged<bool> onToggle;

  // Constructor receives the item data and actions from the parent.
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
        // Checkbox calls the parent's callback when its value changes.
        leading: Checkbox(
          value: item.gotIt,
          activeColor: englishViolet,
          onChanged: (value) {
            if (value != null) {
              onToggle(value);
            }
          },
        ),

        // Cross out the item name when it is marked as got it.
        title: Text(
          item.name,
          style: TextStyle(
            color: englishViolet,
            decoration: item.gotIt
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),

        // Display the price of one item.
        subtitle: Text(
          'PHP ${item.price.toStringAsFixed(2)} each',
        ),

        // Quantity controls call the parent's increase and decrease methods.
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
