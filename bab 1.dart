import 'dart:async';

enum Role { Admin, Customer }

class Product {
   String productName;
   double price;
   bool inStock;

  Product({required this.productName, required this.price, required this.inStock});
}
//nursan
class User {
  String name;
  int age;
  late List<Product> products;
  Role? role;

  User({required this.name, required this.age, this.role});

  void viewProducts() {
    print('Produk untuk $name:');
    for (var product in products) {
      print('- ${product.productName} (Stok: ${product.inStock ? 'Tersedia' : 'Habis'})');
    }
  }
}

class AdminUser extends User {
  AdminUser({required String name, required int age})
      : super(name: name, age: age, role: Role.Admin);

  void addProduct(Product product) {
    if (!product.inStock) {
      throw Exception('Produk ${product.productName} tidak tersedia dalam stok!');
    }
    products.add(product);
    print('Produk ${product.productName} berhasil ditambahkan.');
  }

  void removeProduct(String productName) {
    products.removeWhere((product) => product.productName == productName);
    print('Produk $productName berhasil dihapus.');
  }
}

class CustomerUser extends User {
  CustomerUser({required String name, required int age})
      : super(name: name, age: age, role: Role.Customer);
}

Future<Product> fetchProductDetails(String productName) async {
  await Future.delayed(Duration(seconds: 2)); 
  return Product(productName: productName, price: 100.0, inStock: true);
}

void main() async {
  Map<String, Product> productCatalog = {
    'Laptop': Product(productName: 'Laptop', price: 1500.0, inStock: true),
    'Mouse': Product(productName: 'Mouse', price: 20.0, inStock: true),
    'Keyboard': Product(productName: 'Keyboard', price: 30.0, inStock: false)
  };

  AdminUser admin = AdminUser(name: 'ima', age: 20);
  CustomerUser customer = CustomerUser(name: 'sani', age: 20);

  admin.products = [];
  customer.products = [];

  try {
    admin.addProduct(productCatalog['Laptop']!);
    admin.addProduct(productCatalog['Keyboard']!);
  } catch (e) {
    print('Error $e');
  }

  customer.products = admin.products;
  customer.viewProducts();

  print('Mengambil detail produk...');
  Product fetchedProduct = await fetchProductDetails('Monitor');
  print('Detail Produk: ${fetchedProduct.productName}, Harga: ${fetchedProduct.price}, Stok: ${fetchedProduct.inStock}');
}
