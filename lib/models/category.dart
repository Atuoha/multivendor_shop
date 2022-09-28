class CategoryItem {
  String title;
  String imgUrl;
  bool isActive;

  CategoryItem({
    required this.title,
    required this.imgUrl,
    this.isActive = false,
  });

  setActive(bool status) {
    isActive = status;
  }


}
