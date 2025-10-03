import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop_app/providers/product_provider.dart';
import 'package:coffee_shop_app/models/product_model.dart';
import 'package:coffee_shop_app/services/image_service.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    await productProvider.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                      color: const Color(0xFF4A90E2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'All Products',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${productProvider.products.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadProducts,
                child: productProvider.isLoading
                    ? _buildLoadingState()
                    : productProvider.products.isEmpty
                    ? _buildEmptyState()
                    : _buildProductList(productProvider),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog(context);
        },
        backgroundColor: const Color(0xFF4A90E2),
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Loading products...',
            style: TextStyle(color: Color(0xFF7F8C8D), fontFamily: 'Inter'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 50,
              color: Color(0xFF4A90E2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Products Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first product to get started',
            style: TextStyle(color: Color(0xFF7F8C8D), fontFamily: 'Inter'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _showAddProductDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Add Product',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(ProductProvider productProvider) {
    return Column(
      children: [
        // Stats Cards
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total Products',
                  value: productProvider.products.length.toString(),
                  icon: Icons.inventory_2_outlined,
                  color: const Color(0xFF4A90E2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'Total Value',
                  value:
                      '\$${_calculateTotalValue(productProvider).toStringAsFixed(2)}',
                  icon: Icons.attach_money_outlined,
                  color: const Color(0xFF27AE60),
                ),
              ),
            ],
          ),
        ),

        // Products List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: productProvider.products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return _buildProductCard(product, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF7F8C8D),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Product Image
            _buildProductImage(product),
            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: TextStyle(
                      color: const Color(0xFF7F8C8D),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A90E2),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Row(
              children: [
                _buildActionButton(
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF3498DB),
                  onPressed: () {
                    _showEditProductDialog(context, product);
                  },
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  color: const Color(0xFFE74C3C),
                  onPressed: () async {
                    await _showDeleteConfirmation(context, product);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return FutureBuilder<bool>(
      future: ImageService.imageFileExists(product.imagePath),
      builder: (context, snapshot) {
        final bool imageExists = snapshot.data ?? false;

        // Check if we have a local image
        final bool hasLocalImage = imageExists && product.imagePath != null;
        // Check if we have a network image
        final bool hasNetworkImage =
            product.image != null && product.image!.isNotEmpty;

        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _getCategoryColor(product.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            image: hasLocalImage
                ? DecorationImage(
                    image: FileImage(File(product.imagePath!)),
                    fit: BoxFit.cover,
                  )
                : hasNetworkImage
                ? DecorationImage(
                    image: NetworkImage(product.image!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: hasLocalImage || hasNetworkImage
              ? null
              : Icon(
                  _getCategoryIcon(product.category),
                  color: _getCategoryColor(product.category),
                  size: 28,
                ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: color),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  double _calculateTotalValue(ProductProvider productProvider) {
    return productProvider.products.fold(
      0,
      (sum, product) => sum + product.price,
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    Product product,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFE74C3C)),
            SizedBox(width: 8),
            Text('Delete Product'),
          ],
        ),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await Provider.of<ProductProvider>(
                context,
                listen: false,
              ).deleteProduct(product.id!);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'coffee':
        return Icons.coffee_rounded;
      case 'tea':
        return Icons.emoji_food_beverage_rounded;
      case 'bakery':
        return Icons.bakery_dining_rounded;
      case 'beverage':
        return Icons.local_drink_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'coffee':
        return const Color(0xFF8B4513);
      case 'tea':
        return const Color(0xFF27AE60);
      case 'bakery':
        return const Color(0xFFF39C12);
      case 'beverage':
        return const Color(0xFF3498DB);
      default:
        return const Color(0xFF9B59B6);
    }
  }

  void _showAddProductDialog(BuildContext context) {
    _showProductDialog(context);
  }

  void _showEditProductDialog(BuildContext context, Product product) {
    _showProductDialog(context, product: product);
  }

  void _showProductDialog(BuildContext context, {Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    final categoryController = TextEditingController(
      text: product?.category ?? '',
    );
    final priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );

    File? selectedImageFile;
    String? currentImagePath = product?.imagePath;
    bool removeCurrentImage = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A90E2).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.inventory_2_rounded,
                              color: Color(0xFF4A90E2),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            product == null ? 'Add Product' : 'Edit Product',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Image Upload Section
                      _buildImageUploadSection(
                        currentImagePath: currentImagePath,
                        selectedImageFile: selectedImageFile,
                        removeCurrentImage: removeCurrentImage,
                        onImageSelected: (File? file) {
                          setState(() {
                            selectedImageFile = file;
                            removeCurrentImage = false;
                          });
                        },
                        onImageRemoved: () {
                          setState(() {
                            selectedImageFile = null;
                            removeCurrentImage = true;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildFormField(
                        controller: nameController,
                        label: 'Product Name',
                        icon: Icons.title_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildFormField(
                        controller: descriptionController,
                        label: 'Description',
                        icon: Icons.description_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildFormField(
                        controller: categoryController,
                        label: 'Category',
                        icon: Icons.category_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildFormField(
                        controller: priceController,
                        label: 'Price',
                        icon: Icons.attach_money_rounded,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (nameController.text.isEmpty ||
                                    priceController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please fill in all required fields',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final price = double.tryParse(
                                  priceController.text,
                                );
                                if (price == null || price <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter a valid price',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Handle image path for new product
                                String? finalImagePath;
                                if (product == null) {
                                  // For new product, save the selected image
                                  if (selectedImageFile != null) {
                                    finalImagePath =
                                        await ImageService.saveImageToAppDirectory(
                                          selectedImageFile!,
                                        );
                                  }
                                } else {
                                  // For existing product, use the current path unless removed
                                  finalImagePath = removeCurrentImage
                                      ? null
                                      : currentImagePath;
                                  // If new image selected, save it
                                  if (selectedImageFile != null) {
                                    finalImagePath =
                                        await ImageService.saveImageToAppDirectory(
                                          selectedImageFile!,
                                        );
                                  }
                                }

                                // final newProduct = Product(
                                //   id: product?.id,
                                //   name: nameController.text,
                                //   description: descriptionController.text,
                                //   category: categoryController.text,
                                //   price: price,
                                //   imagePath: finalImagePath,
                                // );
                                // When saving a product
                                final newProduct = Product(
                                  id: product?.id,
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  category: categoryController.text,
                                  price: price,
                                  imagePath: finalImagePath, // Local image path
                                  image: finalImagePath == null
                                      ? product?.image
                                      : null, // Keep network image if no local image
                                );

                                if (product == null) {
                                  await Provider.of<ProductProvider>(
                                    context,
                                    listen: false,
                                  ).addProduct(newProduct);
                                } else {
                                  await Provider.of<ProductProvider>(
                                    context,
                                    listen: false,
                                  ).updateProduct(newProduct);
                                }
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A90E2),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImageUploadSection({
    required String? currentImagePath,
    required File? selectedImageFile,
    required bool removeCurrentImage,
    required Function(File?) onImageSelected,
    required VoidCallback onImageRemoved,
  }) {
    final hasImage =
        (currentImagePath != null && !removeCurrentImage) ||
        selectedImageFile != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Image',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),

        // Image Preview
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
          ),
          child: hasImage
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: selectedImageFile != null
                          ? Image.file(
                              selectedImageFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : FutureBuilder<bool>(
                              future: ImageService.imageFileExists(
                                currentImagePath,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.data == true) {
                                  return Image.file(
                                    File(currentImagePath!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  );
                                } else {
                                  return _buildImagePlaceholder();
                                }
                              },
                            ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: onImageRemoved,
                        ),
                      ),
                    ),
                  ],
                )
              : _buildImagePlaceholder(),
        ),

        const SizedBox(height: 12),

        // Upload Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.photo_library, size: 18),
                label: const Text('Gallery'),
                onPressed: () async {
                  final File? image = await ImageService.pickImageFromGallery();
                  if (image != null) {
                    onImageSelected(image);
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.camera_alt, size: 18),
                label: const Text('Camera'),
                onPressed: () async {
                  final File? image = await ImageService.pickImageFromCamera();
                  if (image != null) {
                    onImageSelected(image);
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
        SizedBox(height: 8),
        Text('Add Product Image', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF4A90E2)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
