import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/colors.dart';

class UploadProduct extends StatefulWidget {
  static const routeName = '/upload_product';

  const UploadProduct({Key? key}) : super(key: key);

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

// for fields
enum Field {
  title,
  price,
  quantity,
  description,
}

class _UploadProductState extends State<UploadProduct> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _subCategoryController = TextEditingController();
  List<XFile>? productImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> category = [
    'Men',
    'Women',
    'Children',
    'Sneakers',
    'Others'
  ];

  final menCategories = [
    'Sub Category',
    'Jeans',
    'Suit',
    'Short',
    'Jacket',
    'Coat',
    'Shirt',
    'Vest',
    'T-shirt',
  ];

  final childrenCategories = [
    'Sub Category',
    'Jeans',
    'Inner',
    'Jacket',
    'Cardigan',
    'Joggers',
    'T-shirt',
    'Gown',
  ];

  final womenCategories = [
    'Sub Category',
    'Gown',
    'Sandals',
    'Cooperate',
    'Blouse',
    'Shirt',
    'Trousers',
    'Jeans'
  ];

  final otherCategories = [
    'Sub Category',
    'Headset',
    'Laptop',
    'Gaming',
    'Camera',
    'Bag',
    'Watch',
  ];

  final sneakersCategories = [
    'Sub Category',
    'Adidas',
    'Fila',
    'Nike',
    'Reebok',
  ];

  var isInit = true;
  var currentImage = 0;
  var currentCategory = '';
  var currentSubCategory = '';
  var isLoading = false;
  List<String> subCategory = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      subCategory = menCategories;
      currentCategory = category[0];
      currentSubCategory = menCategories[0];
    }
    setState(() {
      isInit = false;
    });

    super.didChangeDependencies();
  }

  // for selecting photo
  Future _selectPhoto() async {
    List<XFile>? pickedImage;

    pickedImage = await _picker.pickMultiImage(
      maxWidth: 600,
      maxHeight: 600,
    );

    if (pickedImage == null) {
      return null;
    }

    // assign the picked image to the profileImage
    setState(() {
      productImage = pickedImage;
    });
  }

  // custom dropdown
  Widget kDropDownField(
    List<String> list,
    String currentValue,
    String label,
  ) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: primaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 2,
            color: primaryColor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
      value: currentValue,
      borderRadius: BorderRadius.circular(20),
      items: list
          .map(
            (data) => DropdownMenuItem(
              value: data,
              child: Text(data),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          currentValue = value.toString();
        });

        switch (value) {
          case 'Men':
            setState(() {
              subCategory = menCategories;
            });
            break;
          case 'Women':
            setState(() {
              subCategory = womenCategories;
            });
            break;

          case 'Children':
            setState(() {
              subCategory = childrenCategories;
            });
            break;

          case 'Others':
            setState(() {
              subCategory = otherCategories;
            });
            break;

          case 'Sneakers':
            setState(() {
              subCategory = sneakersCategories;
            });
            break;
        }
      },
    );
  }

  // custom textfield for all form fields
  Widget kTextField(
    TextEditingController controller,
    String hint,
    String label,
    Field field,
    int maxLines,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: field == Field.price || field == Field.quantity
          ? TextInputType.number
          : TextInputType.text,
      textInputAction: field == Field.description
          ? TextInputAction.done
          : TextInputAction.next,
      autofocus: field == Field.title ? true : false,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: primaryColor),
        hintText: hint,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 2,
            color: primaryColor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
      validator: (value) {
        switch (field) {
          case Field.title:
            if (value!.isEmpty) {
              return 'Title can not be empty';
            }
            break;

          case Field.price:
            if (value!.isEmpty) {
              return 'Price is not valid';
            }
            break;

          case Field.quantity:
            if (value!.isEmpty) {
              return 'Quantity is not valid';
            }
            break;

          case Field.description:
            if (value!.isEmpty) {
              return 'Description is not valid';
            }
            break;
        }
        return null;
      },
    );
  }

// snackbar for error message
  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        action: SnackBarAction(
          onPressed: () => Navigator.of(context).pop(),
          label: 'Dismiss',
          textColor: Colors.white,
        ),
      ),
    );
  }

  // loading fnc
  isLoadingFnc() {
    setState(() {
      isLoading = true;
    });
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pop();
    });
  }

  _uploadProduct() {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var valid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!valid || productImage == null) {
      showSnackBar('Product image can not be empty!');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: litePrimary,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.grey,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Upload Product',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _uploadProduct(),
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 18.0,
          left: 18,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white,
                    child: Center(
                      child: productImage == null
                          ? Image.asset(
                              'assets/images/holder.png',
                              color: primaryColor,
                            )
                          // this will load imgUrl from firebase
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.file(
                                File(productImage![currentImage].path),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => _selectPhoto(),
                      child: CircleAvatar(
                        backgroundColor: litePrimary,
                        child: const Icon(
                          Icons.photo,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  productImage == null
                      ? const SizedBox.shrink()
                      : Positioned(
                          bottom: 10,
                          left: 10,
                          child: GestureDetector(
                            onTap: () => setState(() {
                              productImage = null;
                            }),
                            child: CircleAvatar(
                              backgroundColor: litePrimary,
                              child: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                ],
              ),
              const SizedBox(height: 10),
              productImage == null
                  ? const SizedBox.shrink()
                  : SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productImage!.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () => setState(() {
                              currentImage = index;
                            }),
                            child: Container(
                              height: 60,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: FileImage(
                                    File(productImage![index].path),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      kTextField(
                        _titleController,
                        'Gucci Bag',
                        'Product Title',
                        Field.title,
                        1,
                      ),
                      const SizedBox(height: 20),
                      kDropDownField(
                        category,
                        currentCategory,
                        'Category',
                      ),
                      const SizedBox(height: 20),
                      kDropDownField(
                        subCategory,
                        currentSubCategory,
                        'Sub Category',
                      ),
                      const SizedBox(height: 20),
                      kTextField(
                        _priceController,
                        '100',
                        'Product Price',
                        Field.price,
                        1,
                      ),
                      const SizedBox(height: 20),
                      kTextField(
                        _quantityController,
                        '10',
                        'Product Quantity',
                        Field.quantity,
                        1,
                      ),
                      const SizedBox(height: 20),
                      kTextField(
                        _descriptionController,
                        'This product is...',
                        'Product Description',
                        Field.description,
                        3,
                      ),
                      const SizedBox(height: 20),
                    ],
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
