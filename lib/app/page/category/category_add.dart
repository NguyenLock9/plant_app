import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/category.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryAdd extends StatefulWidget {
  final bool isUpdate;
  final CategoryModel? categoryModel;
  const CategoryAdd({super.key, this.isUpdate = false, this.categoryModel});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String titleText = "";

  Future<void> _onSave() async {
    final name = _nameController.text;
    final description = _descController.text;
    final image = _imageController.text;
    var pref = await SharedPreferences.getInstance();
    await APIRepository().addCategory(
        CategoryModel(id: 0, name: name, imageUrl: image, desc: description),
        pref.getString('accountID').toString(),
        pref.getString('token').toString());
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> _onUpdate(int id) async {
    final name = _nameController.text;
    final description = _descController.text;
    final image = _imageController.text;
    var pref = await SharedPreferences.getInstance();
    await APIRepository().updateCategory(
        id,
        CategoryModel(id: widget.categoryModel!.id, name: name, imageUrl: image, desc: description),
        pref.getString('accountID').toString(),
        pref.getString('token').toString());
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.categoryModel != null && widget.isUpdate) {
      _nameController.text = widget.categoryModel!.name;
      _descController.text = widget.categoryModel!.desc;
      _imageController.text = widget.categoryModel!.imageUrl;
    }
    titleText = widget.isUpdate ? "Update Category" : "Add New Category";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter name',
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter imageURL',
                prefixIcon: Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter description',
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  widget.isUpdate ? _onUpdate(widget.categoryModel!.id) : _onSave();
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
