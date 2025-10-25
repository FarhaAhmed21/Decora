import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getProducts() async {
    final snapshot = await _firestore.collection('products').get();
    print("there is  ${snapshot.docs.length} products karen");

    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();
  }
  Future<List<Product>> getDiscountedProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .where('discount', isGreaterThan: 0)
        .get();
    List<Product> products = snapshot.docs.map((doc) {
      return Product.fromMap(doc.data(), doc.id);
    }).toList();
    print("there are ${products.length} discounted products karen");

    return products;
  }
  Future<List<Product>> getNewCollectionProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .where('isNewCollection',isEqualTo:true )
        .get();
    List<Product> products = snapshot.docs.map((doc) {
      return Product.fromMap(doc.data(), doc.id);
    }).toList();
    print("there are ${products.length} of new collection products karen");

    return products;
  }
  Future<List<Comment>> fetchComments(Product product) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc(product.id)
        .get();
    print("product id: ${product.id}");

    if (snapshot.exists) {
      final data = snapshot.data()!;
      print("data keys: ${data.keys}");


      final rawComments = data['comments'];

      if (rawComments == null) {
        print("no comments field karen");
        return [];
      }

      try {
        final comments = (rawComments as List)
            .map((item) => Comment.fromMap(Map<String, dynamic>.from(item)))
            .toList();
        print("there are ${comments.length} comments karen");
        return comments;
      } catch (e) {
        print("error while parsing comments karen: $e");
        return [];
      }
    } else {
      print("no product found karen");
      return [];
    }
  }
  Future<void> replaceProductsInFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference productsRef = firestore.collection('products');

    print("🧹 Deleting old products...");
    final oldDocs = await productsRef.get();
    for (var doc in oldDocs.docs) {
      await doc.reference.delete();
    }

    print("✅ Old products deleted. Adding new ones...");
    for (var product in sampleProducts) {
      await productsRef.doc(product['id']).set(product);
      print("📦 Added product: ${product['name']}");
    }

    print("🎉 All products updated successfully!");
  }



}
final List<Map<String, dynamic>> sampleProducts = [
  // 1️⃣ Livingroom
  {
    "id": "productId_1",
    "name": "Rustic Charm Sofa",
    "categories": "livingroom",
    "price": 250,
    "discount": 0,
    "extraInfo": "Two seater",
    "quantity": 3,
    "details":
    "The Rustic Charm Sofa blends traditional design with modern comfort, perfect for cozy living rooms.",
    "isNewCollection": true,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Terracotta",
        "hexColor": "#E97451",
        "imageUrl":
        "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Terracotta/Rust-colored Sofa
      },
      {
        "colorName": "Forest Green",
        "hexColor": "#228B22",
        "imageUrl":
        "https://images.pexels.com/photos/16487621/pexels-photo-16487621/free-photo-of-living-room-in-green-with-fireplace.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Forest Green Sofa
      },
    ],
    "comments": [
      {
        "date": "25-10-2025",
        "email": "mona@example.com",
        "userName": "Mona Ahmed",
        "userid": "1",
        "profilePic":
        "https://randomuser.me/api/portraits/women/44.jpg",
        "text": "Very comfortable sofa, perfect for my living room!",
        "postPics": [
          "https://img.freepik.com/free-vector/red-leather-sofa-realistic-illustration_1284-12133.jpg?w=740&q=80",
        ],
      },
      {
        "date": "26-10-2025",
        "email": "adam@example.com",
        "userName": "Adam Youssef",
        "userid": "2",
        "profilePic":
        "https://randomuser.me/api/portraits/men/31.jpg",
        "text": "Love the quality and the color!",
        "postPics": [],
      },
    ],
  },

  {
    "id": "productId_2",
    "name": "Modern Elegance Sofa",
    "categories": "livingroom",
    "price": 320,
    "discount": 15,
    "extraInfo": "Three seater",
    "quantity": 5,
    "details":
    "A sleek, elegant design with plush cushions, ideal for modern spaces.",
    "isNewCollection": true,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Beige",
        "hexColor": "#F5F5DC",
        "imageUrl":
        "https://images.pexels.com/photos/439227/pexels-photo-439227.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Modern Beige Sofa
      },
      {
        "colorName": "Navy Blue",
        "hexColor": "#000080",
        "imageUrl":
        "https://images.pexels.com/photos/5675306/pexels-photo-5675306.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Navy Blue Sofa
      },
    ],
    "comments": [
      {
        "date": "24-10-2025",
        "email": "dina@example.com",
        "userName": "Dina Samir",
        "userid": "3",
        "profilePic": "https://randomuser.me/api/portraits/women/25.jpg",
        "text": "Really elegant! Looks great in my home.",
        "postPics": [],
      },
    ],
  },

  {
    "id": "productId_3",
    "name": "Urban Loft Armchair",
    "categories": "livingroom",
    "price": 180,
    "discount": 10,
    "extraInfo": "Single seater",
    "quantity": 7,
    "details":
    "Compact armchair perfect for small apartments or reading corners.",
    "isNewCollection": false,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Gray",
        "hexColor": "#808080",
        "imageUrl":
        "https://images.pexels.com/photos/7061730/pexels-photo-7061730.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Gray Armchair in Loft
      },
    ],
    "comments": [],
  },

  {
    "id": "productId_4",
    "name": "Classic Leather Recliner",
    "categories": "livingroom",
    "price": 450,
    "discount": 20,
    "extraInfo": "Recliner with adjustable headrest",
    "quantity": 2,
    "details":
    "Luxurious leather recliner with adjustable positions for full relaxation.",
    "isNewCollection": false,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Dark Brown",
        "hexColor": "#654321",
        "imageUrl":
        "https://images.pexels.com/photos/4352247/pexels-photo-4352247.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Dark Brown Leather Recliner
      },
    ],
    "comments": [],
  },

  {
    "id": "productId_5",
    "name": "Scandinavian Minimalist Sofa",
    "categories": "livingroom",
    "price": 300,
    "discount": 5,
    "extraInfo": "Two seater with wooden legs",
    "quantity": 6,
    "details":
    "Minimalist design with soft tones and wooden legs for natural warmth.",
    "isNewCollection": true,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Light Gray",
        "hexColor": "#D3D3D3",
        "imageUrl":
        "https://images.pexels.com/photos/5879761/pexels-photo-5879761.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Light Gray Minimalist Sofa
      },
      {
        "colorName": "Blush Pink",
        "hexColor": "#FFC0CB",
        "imageUrl":
        "https://images.pexels.com/photos/8134709/pexels-photo-8134709.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Blush Pink Sofa
      },
    ],
    "comments": [],
  },

  // 2️⃣ Bedroom
  {
    "id": "productId_6",
    "name": "Cozy Cloud Bed",
    "categories": "bedroom",
    "price": 500,
    "discount": 10,
    "extraInfo": "Queen size upholstered bed",
    "quantity": 4,
    "details":
    "A soft, padded headboard and a cloud-like mattress base make for the ultimate comfort.",
    "isNewCollection": true,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Ivory",
        "hexColor": "#FFFFF0",
        "imageUrl":
        "https://images.pexels.com/photos/7061734/pexels-photo-7061734.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Ivory Upholstered Bed
      },
    ],
    "comments": [
      {
        "date": "21-10-2025",
        "email": "ahmed@example.com",
        "userName": "Ahmed Kareem",
        "userid": "4",
        "profilePic": "https://randomuser.me/api/portraits/men/45.jpg",
        "text": "Super comfy bed. Love the design!",
        "postPics": [],
      },
    ],
  },

  {
    "id": "productId_7",
    "name": "Nordic Pine Wardrobe",
    "categories": "bedroom",
    "price": 280,
    "discount": 5,
    "extraInfo": "3-door wardrobe",
    "quantity": 5,
    "details":
    "Spacious wardrobe with natural pine finish, ideal for Scandinavian interiors.",
    "isNewCollection": false,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Pine Wood",
        "hexColor": "#DEB887",
        "imageUrl":
        "https://images.pexels.com/photos/6782570/pexels-photo-6782570.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Pine Wood Wardrobe
      },
    ],
    "comments": [],
  },

  {
    "id": "productId_8",
    "name": "Velvet Dream Bedside Table",
    "categories": "bedroom",
    "price": 120,
    "discount": 0,
    "extraInfo": "Drawer storage table",
    "quantity": 10,
    "details":
    "Compact yet elegant bedside table with soft-touch velvet finish.",
    "isNewCollection": true,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Emerald",
        "hexColor": "#50C878",
        "imageUrl":
        "https://images.pexels.com/photos/6889787/pexels-photo-6889787.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Emerald Velvet Bedside Table
      },
    ],
    "comments": [],
  },

  // 3️⃣ Office
  {
    "id": "productId_9",
    "name": "ErgoFlex Office Chair",
    "categories": "office",
    "price": 220,
    "discount": 12,
    "extraInfo": "Adjustable mesh back chair",
    "quantity": 8,
    "details":
    "Designed for maximum comfort and posture support during long working hours.",
    "isNewCollection": false,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Black",
        "hexColor": "#000000",
        "imageUrl":
        "https://images.pexels.com/photos/17693997/pexels-photo-17693997/free-photo-of-black-office-chair-by-desk.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Black Mesh Office Chair
      },
    ],
    "comments": [],
  },

  {
    "id": "productId_10",
    "name": "Walnut Writing Desk",
    "categories": "office",
    "price": 340,
    "discount": 8,
    "extraInfo": "Solid wood top with drawers",
    "quantity": 6,
    "details":
    "Classic writing desk made from premium walnut wood for elegance and durability.",
    "isNewCollection": true,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Walnut",
        "hexColor": "#773F1A",
        "imageUrl":
        "https://images.pexels.com/photos/6684074/pexels-photo-6684074.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Walnut Writing Desk
      },
    ],
    "comments": [],
  },

  // 4️⃣ Dining
  {
    "id": "productId_11",
    "name": "Oakwood Dining Table",
    "categories": "dining",
    "price": 480,
    "discount": 5,
    "extraInfo": "6-seater solid wood table",
    "quantity": 3,
    "details":
    "Durable oakwood table perfect for family gatherings and dinner parties.",
    "isNewCollection": false,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Oak",
        "hexColor": "#C3B091",
        "imageUrl":
        "https://images.pexels.com/photos/6889759/pexels-photo-6889759.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Oakwood Dining Table
      },
    ],
    "comments": [],
  },

  {
    "id": "productId_12",
    "name": "Modern Dining Chairs Set",
    "categories": "dining",
    "price": 260,
    "discount": 10,
    "extraInfo": "Set of 4 chairs",
    "quantity": 7,
    "details":
    "Stylish dining chairs with ergonomic design and soft fabric seats.",
    "isNewCollection": true,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Cream",
        "hexColor": "#FFFDD0",
        "imageUrl":
        "https://images.pexels.com/photos/6782488/pexels-photo-6782488.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Cream Dining Chairs Set
      },
    ],
    "comments": [],
  },

  // 5️⃣ Outdoor
  {
    "id": "productId_13",
    "name": "Patio Relax Lounge Set",
    "categories": "outdoor",
    "price": 550,
    "discount": 18,
    "extraInfo": "Rattan 3-piece set",
    "quantity": 2,
    "details":
    "Weather-resistant outdoor lounge with soft cushions and glass-top table.",
    "isNewCollection": true,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Natural Rattan",
        "hexColor": "#D2B48C",
        "imageUrl":
        "https://images.pexels.com/photos/19183422/pexels-photo-19183422/free-photo-of-rattan-patio-set.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Natural Rattan Patio Set
      },
    ],
    "comments": [],
  },

  {
    "id": "productId_14",
    "name": "Garden Bistro Set",
    "categories": "outdoor",
    "price": 290,
    "discount": 0,
    "extraInfo": "Metal foldable chairs & table",
    "quantity": 5,
    "details":
    "Compact outdoor set perfect for balconies and small patios.",
    "isNewCollection": false,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "Mint Green",
        "hexColor": "#98FF98",
        "imageUrl":
        "https://images.pexels.com/photos/15743452/pexels-photo-15743452/free-photo-of-mint-green-metal-bistro-set.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: Mint Green Bistro Set
      },
    ],
    "comments": [],
  },

  // 6️⃣ More Variety
  {
    "id": "productId_15",
    "name": "Luxury Canopy Bed",
    "categories": "bedroom",
    "price": 750,
    "discount": 25,
    "extraInfo": "King size bed with drapes",
    "quantity": 2,
    "details": "Add a royal touch to your room with this elegant canopy bed.",
    "isNewCollection": true,
    "isfavourite": false,
    "colors": [
      {
        "colorName": "White",
        "hexColor": "#FFFFFF",
        "imageUrl":
        "https://images.pexels.com/photos/2082087/pexels-photo-2082087.jpeg?auto=compress&cs=tinysrgb&w=800", // Pexels: White Canopy Bed
      },
    ],
    "comments": [],
  },
];