import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/category.dart';
import 'package:app_api/app/model/product.dart';

class ProductAdd extends StatefulWidget {
  final bool isUpdate;
  final ProductModel? productModel;

  const ProductAdd({Key? key, this.isUpdate = false, this.productModel}) : super(key: key);

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  String? selectedCate;
  List<CategoryModel> categorys = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imgController = TextEditingController();
  final TextEditingController _catIdController = TextEditingController();
  String titleText = "";

  Future<void> _onSave() async {
    final name = _nameController.text;
    final des = _desController.text;
    final price = double.parse(_priceController.text);
    final img = _imgController.text;
    final catId = _catIdController.text;
    var pref = await SharedPreferences.getInstance();
    await APIRepository().addProduct(
      ProductModel(
        id: 0,
        name: name,
        imageUrl: img,
        categoryId: int.parse(catId),
        categoryName: '',
        price: price,
        description: des,
      ),
      pref.getString('token').toString(),
    );
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> _onUpdate() async {
    final name = _nameController.text;
    final des = _desController.text;
    final price = double.parse(_priceController.text);
    final img = _imgController.text;
    final catId = _catIdController.text;
    var pref = await SharedPreferences.getInstance();
    await APIRepository().updateProduct(
      ProductModel(
        id: widget.productModel!.id,
        name: name,
        imageUrl: img,
        categoryId: int.parse(catId),
        categoryName: '',
        price: price,
        description: des,
      ),
      pref.getString('accountID').toString(),
      pref.getString('token').toString(),
    );
    setState(() {});
    Navigator.pop(context);
  }

  _getCategorys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = await APIRepository().getCategory(
      prefs.getString('accountID').toString(),
      prefs.getString('token').toString(),
    );
    setState(() {
      selectedCate = temp.first.id.toString();
      _catIdController.text = selectedCate.toString();
      categorys = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategorys();

    if (widget.productModel != null && widget.isUpdate) {
      _nameController.text = widget.productModel!.name;
      _desController.text = widget.productModel!.description;
      _priceController.text = widget.productModel!.price.toString();
      _imgController.text = widget.productModel!.imageUrl;
      _catIdController.text = widget.productModel!.categoryId.toString();
    }
    if (widget.isUpdate) {
      titleText = "Update Product";
    } else {
      titleText = "Add New Product";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              widget.isUpdate ? _onUpdate() : _onSave();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Name:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter name',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Price:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter price',
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Image:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _imgController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter imageURL',
                  prefixIcon: Icon(Icons.image),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _desController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter description',
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Category:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCate,
                items: categorys.map((item) => DropdownMenuItem<String>(
                  value: item.id.toString(),
                  child: Text(item.name, style: TextStyle(fontSize: 18)),
                )).toList(),
                onChanged: (item) {
                  setState(() {
                    selectedCate = item;
                    _catIdController.text = item.toString();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    widget.isUpdate ? _onUpdate() : _onSave();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
