import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _items = [
    CartItem(
      id: '1',
      name: 'Gitar Akustik',
      price: 1200000,
      imageUrl: 'https://via.placeholder.com/70',
      quantity: 1,
    ),
    CartItem(
      id: '2',
      name: 'Gitar Elektrik',
      price: 2500000,
      imageUrl: 'https://via.placeholder.com/70',
      quantity: 1,
    ),
  ];

  double get _total => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void _goToTransactionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionScreen(items: _items, totalAmount: _total),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text('Rp ${item.price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              item.quantity = item.quantity > 1 ? item.quantity - 1 : 1;
                            });
                          },
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              item.quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _goToTransactionPage,
              icon: const Icon(Icons.shopping_cart_checkout),
              label: Text('Checkout (Rp ${_total.toStringAsFixed(2)})'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionScreen extends StatefulWidget {
  final List<CartItem> items;
  final double totalAmount;

  const TransactionScreen({Key? key, required this.items, required this.totalAmount}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String selectedPaymentMethod = 'Transfer Bank';
  bool isElectricGuitarSelected = false;
  bool isAcousticGuitarSelected = false;
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController deliveryTimeController = TextEditingController();

  @override
  void dispose() {
    customerNameController.dispose();
    deliveryTimeController.dispose();
    super.dispose();
  }

  void _confirmOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Text(
          'Nama Pemesan: ${customerNameController.text}\n'
              'Waktu Pengiriman: ${deliveryTimeController.text}\n'
              'Metode Pembayaran: $selectedPaymentMethod\n'
              'Jenis Gitar: ${isElectricGuitarSelected ? 'Gitar Elektrik' : ''} ${isAcousticGuitarSelected ? 'Gitar Akustik' : ''}\n'
              'Total Pembayaran: Rp ${widget.totalAmount.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan dikonfirmasi!')));
            },
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detail Pemesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: customerNameController,
              decoration: InputDecoration(
                labelText: 'Nama Pemesan',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: deliveryTimeController,
              decoration: InputDecoration(
                labelText: 'Waktu Pengiriman (misal: 3 hari)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Metode Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              title: const Text('Transfer Bank'),
              value: 'Transfer Bank',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Kartu Kredit'),
              value: 'Kartu Kredit',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Pembayaran Tunai'),
              value: 'Pembayaran Tunai',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Jenis Gitar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text('Gitar Elektrik'),
              value: isElectricGuitarSelected,
              onChanged: (value) {
                setState(() {
                  isElectricGuitarSelected = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Gitar Akustik'),
              value: isAcousticGuitarSelected,
              onChanged: (value) {
                setState(() {
                  isAcousticGuitarSelected = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ringkasan Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Divider(),
                    Text('Nama Pemesan: ${customerNameController.text}'),
                    Text('Waktu Pengiriman: ${deliveryTimeController.text}'),
                    Text('Metode Pembayaran: $selectedPaymentMethod'),
                    Text('Jenis Gitar: ${isElectricGuitarSelected ? 'Gitar Elektrik' : ''} ${isAcousticGuitarSelected ? 'Gitar Akustik' : ''}'),
                    const SizedBox(height: 8),
                    Text('Total Pembayaran: Rp ${widget.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmOrder,
                child: const Text('Konfirmasi Pembayaran'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
