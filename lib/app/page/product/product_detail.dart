import 'package:app_api/app/route/Tutorial.dart';
import 'package:flutter/material.dart';
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/model/favourite.dart';
import 'package:app_api/app/model/product.dart';
import 'package:app_api/app/data/sqlite.dart';
import 'package:intl/intl.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel product;
  const ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  int _quantity = 1;
  bool _isExpanded = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    final favorites = await databaseHelper.favourites();
    setState(() {
      _isFavorite = favorites.any((fav) => fav.productID == widget.product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductInfo(),
                  const SizedBox(height: 16),
                  _buildAirQualityIndicator(),
                  const SizedBox(height: 24),
                  _buildDescription(),
                  const SizedBox(height: 24),
                  _buildTags(),
                  const SizedBox(height: 24),
                  _buildCareInstructions(),
                  const SizedBox(height: 24),
                  _buildQuantitySelector(),
                  const SizedBox(height: 24),
                  _buildAddToCartButton(),
                  const SizedBox(height: 32),
                  _buildReviewsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          widget.product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
            if (_isFavorite) {
              databaseHelper.insertFavourite(Favourite(
                productID: widget.product.id,
                name: widget.product.name,
                price: widget.product.price,
                img: widget.product.imageUrl,
                des: widget.product.description,
              ));
            } else {
              databaseHelper.deleteFavourite(widget.product.id);
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.green[700]),
          onPressed: () {
            // Implement share functionality
          },
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPrice(),
            const Spacer(),
            Row(
              children: List.generate(5, (index) {
                return const Icon(Icons.star, color: Colors.orange, size: 24);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrice() {
    return Row(
      children: [
        Text(
          '${NumberFormat('#,###').format(widget.product.price)} VND',
          style: TextStyle(fontSize: 24, color: Colors.green[700], fontWeight: FontWeight.bold),
        ),
      
      ],
    );
  }

  Widget _buildAirQualityIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.eco, color: Colors.green[700]),
          SizedBox(width: 8),
          Text(
            'Improves Air Quality',
            style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[800]),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            widget.product.description,
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    List<String> tags = ['Indoor', 'Low Light', 'Pet Friendly'];
    return Wrap(
      spacing: 8,
      children: tags.map((tag) => Chip(
        label: Text(tag),
        backgroundColor: Colors.green[100],
        labelStyle: TextStyle(color: Colors.green[700]),
      )).toList(),
    );
  }

  Widget _buildCareInstructions() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Care Instructions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
            ),
            SizedBox(height: 12),
            _buildCareItem(Icons.wb_sunny_outlined, 'Light', 'Bright indirect'),
            _buildCareItem(Icons.water_drop_outlined, 'Water', 'Weekly'),
            _buildCareItem(Icons.thermostat_outlined, 'Temperature', '18-24°C'),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
               Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PlantCareGuide()));
              },
              icon: Icon(Icons.book),
              label: Text('Detailed Care Guide'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green[700], backgroundColor: Colors.green[50],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCareItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green[600]),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(description),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text(
          'Quantity:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.green),
                onPressed: () {
                  setState(() {
                    if (_quantity > 1) _quantity--;
                  });
                },
              ),
              Text(
                _quantity.toString(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                onPressed: () {
                  setState(() {
                    _quantity++;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          databaseHelper.insertProduct(Cart(
            productID: widget.product.id,
            name: widget.product.name,
            des: widget.product.description,
            price: widget.product.price,
            img: widget.product.imageUrl,
            count: _quantity,
          ));
          Navigator.pop(context);
        },
        icon: const Icon(Icons.shopping_cart,color:  Colors.white),
        label: const Text('Add to Cart',style: TextStyle(fontSize: 18, color: Colors.white) ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

 
  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Reviews',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[800]),
        ),
        const SizedBox(height: 16),
        _buildDummyComment('John Doe', 'Great product, highly recommend!', 4),
        _buildDummyComment('Jane Smith', 'Good quality, but a bit expensive.', 3),
        _buildDummyComment('Alice Johnson', 'Exactly what I was looking for!', 5),
      ],
    );
  }

  Widget _buildDummyComment(String name, String comment, int rating) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(name[0], style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.green[700],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.orange,
                            size: 18,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}