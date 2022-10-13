import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multivendor_shop/components/loading.dart';
import '../../../../constants/colors.dart';
import '../../../../utilities/categories_list.dart';
import 'package:path/path.dart' as path;

class EditProduct extends StatefulWidget {
  static const routeName = '/edit_product';

  const EditProduct({
    Key? key,
    required this.product,
  }) : super(key: key);
  final dynamic product;

  @override
  State<EditProduct> createState() => _EditProductState();
}

// for fields
enum Field {
  title,
  price,
  quantity,
  description,
}

enum DropDownType { category, subCategory }

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<dynamic>? productImages;
  List<String> imageDownloadLinks = [];
  final ImagePicker _picker = ImagePicker();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  var isInit = true;
  var currentImage = 0;
  var currentCategory = '';
  var currentSubCategory = '';
  var isLoading = false;
  List<String> subCategory = [];
  var isImagePicked = false;  // this will hold when a new image is picked or not

  void assignValues() {
    _titleController.text = widget.product['title'];
    _priceController.text = widget.product['price'];
    _quantityController.text = widget.product['quantity'];
    _descriptionController.text = widget.product['description'];
    currentCategory = widget.product['category'];
    currentSubCategory = widget.product['sub_category'];
    productImages = widget.product['images'];
    imageDownloadLinks = widget.product['images'];
    switch (widget.product['category']) {
      case 'Men':
        subCategory = menCategories;
        break;
      case 'Women':
        subCategory = womenCategories;
        break;
      case 'Children':
        subCategory = childrenCategories;
        break;

      case 'Sneakers':
        subCategory = sneakersCategories;
        break;

      case 'Others':
        subCategory = otherCategories;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      assignValues();
    }
    setState(() {
      isInit = false;
    });

    super.didChangeDependencies();
  }

  // for selecting photo
  Future _selectPhoto() async {
    List<XFile>? pickedImages;

    pickedImages = await _picker.pickMultiImage(
      maxWidth: 600,
      maxHeight: 600,
    );

    if (pickedImages == null) {
      return null;
    } else if (pickedImages.length < 2) {
      showSnackBar('Select more than one image');
      return null;
    }

    // assign the picked image to the profileImage
    setState(() {
      productImages = pickedImages;
      isImagePicked = true;
    });
  }

  // custom dropdown
  Widget kDropDownField(
    DropDownType dropDownType,
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
          if (dropDownType == DropDownType.category) {
            currentCategory = value.toString();
          } else {
            currentSubCategory = value.toString();
          }
        });

        switch (value) {
          case 'Men':
            setState(() {
              subCategory = menCategories;
              currentSubCategory = menCategories[0];
            });
            break;
          case 'Women':
            setState(() {
              subCategory = womenCategories;
              currentSubCategory = womenCategories[0];
            });
            break;

          case 'Children':
            setState(() {
              subCategory = childrenCategories;
              currentSubCategory = childrenCategories[0];
            });
            break;

          case 'Others':
            setState(() {
              subCategory = otherCategories;
              currentSubCategory = otherCategories[0];
            });
            break;

          case 'Sneakers':
            setState(() {
              subCategory = sneakersCategories;
              currentSubCategory = sneakersCategories[0];
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

  _uploadProduct() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var valid = _formKey.currentState!.validate();
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();

    if (!valid) {
      showSnackBar('Fill all fields completely!');
      return null;
    }

    // if (productImages == null) {
    //   showSnackBar('Product image can not be empty!');
    //   return null;
    // }

    setState(() {
      isLoading = true;
    });

    try {
      if (isImagePicked) {
        for (var image in productImages!) {
          var storageRef = FirebaseStorage.instance
              .ref('product-images/${path.basename(image.path)}');

          await storageRef.putFile(File(image.path)).whenComplete(() async {
            await storageRef.getDownloadURL().then(
                  (value) => imageDownloadLinks.add(value),
                );
          });
        }
      }

      FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
          .update({
        'title': _titleController.text.trim(),
        'price': _priceController.text.trim(),
        'quantity': _quantityController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': currentCategory,
        'sub_category': currentSubCategory,
        'images': imageDownloadLinks,
      }).then((value) => {
                // _formKey.currentState!.reset(),
                setState(() {
                  productImages = [];
                  imageDownloadLinks = [];
                  isLoading = false;
                }),
              });
    } on FirebaseException catch (e) {
      showSnackBar('Error occurred! ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('An error just occurred :)');
      }
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
        title: Text(
          'Editing ${widget.product['title']}',
          style: const TextStyle(
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
        child: isLoading
            ? const Loading(color: primaryColor, kSize: 50)
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          child: Center(
                            child: productImages == null
                                ? Image.asset(
                                    'assets/images/holder.png',
                                    color: primaryColor,
                                  )
                                // this will load imgUrl from firebase
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: isImagePicked
                                        ? Image.file(
                                            File(productImages![currentImage]
                                                .path),
                                          )
                                        : Image.network(
                                            productImages![currentImage]),
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
                        productImages == null
                            ? const SizedBox.shrink()
                            : Positioned(
                                bottom: 10,
                                left: 10,
                                child: GestureDetector(
                                  onTap: () => setState(() {
                                    productImages = null;
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
                    productImages == null
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: productImages!.length,
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
                                      image: isImagePicked
                                          ? DecorationImage(
                                              image: FileImage(
                                                File(
                                                    productImages![index].path),
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : DecorationImage(
                                              image: NetworkImage(
                                                productImages![index],
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
                              DropDownType.category,
                              category,
                              currentCategory,
                              'Category',
                            ),
                            const SizedBox(height: 20),
                            kDropDownField(
                              DropDownType.subCategory,
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
