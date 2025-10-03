
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop_app/providers/purchase_provider.dart';
import 'package:coffee_shop_app/models/purchase_model.dart';
import 'package:coffee_shop_app/config/database_helper.dart';

class PurchaseManagementScreen extends StatefulWidget {
  const PurchaseManagementScreen({super.key});

  @override
  State<PurchaseManagementScreen> createState() =>
      _PurchaseManagementScreenState();
}

class _PurchaseManagementScreenState extends State<PurchaseManagementScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  List<Purchase> _filteredPurchases = [];
  
  

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loadInitialData();
    _animationController.forward();
  }


  Future<void> _refreshPurchases() async {
  final purchaseProvider = Provider.of<PurchaseProvider>(
    context,
    listen: false,
  );
  await purchaseProvider.fetchPurchases();
  setState(() {
    _filteredPurchases = purchaseProvider.purchases;
  });
}


  Future<void> _loadInitialData() async {
  final purchaseProvider = Provider.of<PurchaseProvider>(
    context,
    listen: false,
  );
  await purchaseProvider.fetchPurchases();

  // Insert sample purchases if none exist
  if (purchaseProvider.purchases.isEmpty) {
    await _insertSamplePurchases();
    // Refresh again after inserting samples
    await purchaseProvider.fetchPurchases();
  }

  setState(() {
    _filteredPurchases = purchaseProvider.purchases;
  });
}

  Future<void> _insertSamplePurchases() async {
    final purchaseProvider = Provider.of<PurchaseProvider>(
      context,
      listen: false,
    );
    final dbHelper = DatabaseHelper();

    final samplePurchases = [
      Purchase(
        supplierName: 'Coffee Bean Suppliers Co.',
        totalPrice: 1250.75,
        purchaseDate: DateTime.now()
            .subtract(const Duration(days: 2))
            .toIso8601String(),
        status: 'Completed',
        notes: 'Monthly coffee bean supply - Premium Arabica',
        phone: '+1-555-0101',
        address: '123 Supplier St, Coffee City',
        paymentMethod: 'Bank Transfer',
        deliveryDate: DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
        taxAmount: 125.08,
        discount: 50.00,
      ),
      Purchase(
        supplierName: 'Milk & Dairy Products Ltd.',
        totalPrice: 345.50,
        purchaseDate: DateTime.now()
            .subtract(const Duration(days: 1))
            .toIso8601String(),
        status: 'Pending',
        notes: 'Organic milk and cream supply',
        phone: '+1-555-0102',
        address: '456 Dairy Ave, Farm Town',
        paymentMethod: 'Credit Card',
        deliveryDate: DateTime.now()
            .add(const Duration(days: 2))
            .toIso8601String(),
        taxAmount: 34.55,
        discount: 15.00,
      ),
    ];

    for (final purchase in samplePurchases) {
      await dbHelper.insertPurchase(purchase);
    }

    // Refresh the purchase list
    await purchaseProvider.fetchPurchases();
  }

  void _filterPurchases(String query) {
    final purchaseProvider = Provider.of<PurchaseProvider>(
      context,
      listen: false,
    );
    setState(() {
      if (query.isEmpty) {
        _filteredPurchases = purchaseProvider.purchases;
      } else {
        _filteredPurchases = purchaseProvider.purchases.where((purchase) {
          return purchase.supplierName.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              purchase.status?.toLowerCase().contains(query.toLowerCase()) ==
                  true ||
              purchase.phone?.toLowerCase().contains(query.toLowerCase()) ==
                  true;
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: const Text(
          'Purchase Management',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Consumer<PurchaseProvider>(
        builder: (context, purchaseProvider, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Header Stats
                _buildHeaderStats(purchaseProvider),
                const SizedBox(height: 16),

                // Search Bar
                _buildSearchBar(),
                const SizedBox(height: 16),

                // Purchase List
                Expanded(
                  child: purchaseProvider.isLoading
                      ? _buildLoadingState()
                      : _filteredPurchases.isEmpty
                      ? _buildEmptyState()
                      : _buildPurchaseList(purchaseProvider),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _animationController,
          curve: Curves.elasticOut,
        ),
        child: FloatingActionButton(
          onPressed: () {
            _showAddPurchaseDialog(context);
          },
          backgroundColor: const Color(0xFF4A90E2),
          elevation: 8,
          child: const Icon(
            Icons.add_shopping_cart_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  // In your purchase_management_screen.dart, update these methods:

  Widget _buildHeaderStats(PurchaseProvider purchaseProvider) {
    final completedCount = purchaseProvider.purchases
        .where((p) => p.status?.toLowerCase() == 'completed')
        .length;
    final pendingCount = purchaseProvider.purchases
        .where((p) => p.status?.toLowerCase() == 'pending')
        .length;
    final processingCount = purchaseProvider.purchases
        .where((p) => p.status?.toLowerCase() == 'processing')
        .length;
    final totalAmount = purchaseProvider.purchases.fold(
      0.0,
      (sum, purchase) => sum + purchase.totalPrice,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A90E2), Color(0xFF5D9CEC)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            value: purchaseProvider.purchases.length.toString(),
            label: 'Total Purchases',
            icon: Icons.shopping_cart_rounded,
            color: Colors.white,
          ),
          _buildStatItem(
            value: completedCount.toString(),
            label: 'Completed',
            icon: Icons.check_circle_rounded,
            color: Colors.white, // Green for completed
          ),
          _buildStatItem(
            value: pendingCount.toString(),
            label: 'Pending',
            icon: Icons.pending_actions_rounded,
            color: Colors.white, // Orange for pending
          ),
          _buildStatItem(
            value: '\$${totalAmount.toStringAsFixed(0)}',
            label: 'Total Amount',
            icon: Icons.attach_money_rounded,
            color: Colors.white, // Green for money
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: color.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Update the status color method with better colors
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return const Color(0xFF27AE60); // Green - success
      case 'processing':
        return const Color(0xFF3498DB); // Blue - in progress
      case 'pending':
        return const Color(0xFFF39C12); // Orange - waiting
      case 'cancelled':
        return const Color(0xFFE74C3C); // Red - error
      case 'shipped':
        return const Color(0xFF9B59B6); // Purple - shipped
      case 'delivered':
        return const Color(0xFF27AE60); // Green - delivered
      default:
        return const Color(0xFF7F8C8D); // Gray - unknown
    }
  }

  // Update the purchase card to use new colors
  Widget _buildPurchaseCard(
    Purchase purchase,
    int index,
    PurchaseProvider purchaseProvider,
  ) {
    final statusColor = _getStatusColor(purchase.status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showPurchaseDetails(context, purchase, purchaseProvider);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.inventory_2_rounded,
                        color: statusColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PO-${purchase.id?.toString().padLeft(4, '0') ?? 'N/A'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            purchase.supplierName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7F8C8D),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (purchase.phone != null &&
                              purchase.phone!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              purchase.phone!,
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF7F8C8D).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${purchase.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF27AE60), // Green for money amount
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: statusColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            purchase.status ?? 'Pending',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // ... rest of your card code
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _filterPurchases,
          decoration: InputDecoration(
            hintText: 'Search by supplier, status, or phone...',
            hintStyle: const TextStyle(color: Color(0xFF7F8C8D)),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF4A90E2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFFE0E0E0),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseList(PurchaseProvider purchaseProvider) {
    return RefreshIndicator(
      onRefresh: _refreshPurchases,
      child: ListView.builder(
        itemCount: _filteredPurchases.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) {
          final purchase = _filteredPurchases[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 400 + (index * 100)),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.only(bottom: 12),
            child: _buildPurchaseCard(purchase, index, purchaseProvider),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16, color: color),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF4A90E2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading Purchases...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF5D9CEC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_cart_rounded,
                size: 70,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No Purchases Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Add your first purchase order to get started\nwith inventory management',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7F8C8D),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                _showAddPurchaseDialog(context);
              },
              icon: const Icon(Icons.add_shopping_cart_rounded),
              label: const Text(
                'Add First Purchase',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseDetails(
    BuildContext context,
    Purchase purchase,
    PurchaseProvider purchaseProvider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            // FIX: Added SingleChildScrollView to prevent overflow
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    color: Color(0xFF4A90E2),
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'PO-${purchase.id?.toString().padLeft(4, '0') ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  purchase.supplierName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailItem(
                  Icons.attach_money_rounded,
                  'Total: \$${purchase.totalPrice.toStringAsFixed(2)}',
                ),
                _buildDetailItem(
                  Icons.calendar_today_rounded,
                  'Order Date: ${_formatDate(purchase.purchaseDate)}',
                ),
                if (purchase.deliveryDate != null)
                  _buildDetailItem(
                    Icons.local_shipping_rounded,
                    'Delivery: ${_formatDate(purchase.deliveryDate!)}',
                  ),
                if (purchase.paymentMethod != null)
                  _buildDetailItem(
                    Icons.payment_rounded,
                    'Payment: ${purchase.paymentMethod}',
                  ),
                if (purchase.phone != null)
                  _buildDetailItem(Icons.phone_rounded, purchase.phone!),
                if (purchase.address != null)
                  _buildDetailItem(
                    Icons.location_on_rounded,
                    purchase.address!,
                  ),
                if (purchase.notes != null && purchase.notes!.isNotEmpty)
                  _buildDetailItem(Icons.notes_rounded, purchase.notes!),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showEditPurchaseDialog(context, purchase: purchase);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                        ),
                        child: const Text('Edit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4A90E2), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(color: Color(0xFF7F8C8D))),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Purchase purchase,
    int index,
    PurchaseProvider purchaseProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE74C3C).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFE74C3C),
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Purchase?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to delete purchase order PO-${purchase.id?.toString().padLeft(4, '0')} from ${purchase.supplierName}?',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF7F8C8D), height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                        try {
                          await purchaseProvider.deletePurchase(purchase.id!);
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Purchase PO-${purchase.id?.toString().padLeft(4, '0')} has been deleted',
                                ),
                                backgroundColor: const Color(0xFF27AE60),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error deleting purchase: $e'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE74C3C),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  

  void _showAddPurchaseDialog(BuildContext context) {
    final supplierController = TextEditingController();
    final totalPriceController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final notesController = TextEditingController();

    String selectedStatus = 'Pending';
    String selectedPaymentMethod = 'Cash';
    int selectedEmployeeId = 1; // Default to first employee

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
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A90E2).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_rounded,
                              color: Color(0xFF4A90E2),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Add New Purchase',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Supplier Name
                      _buildFormField(
                        controller: supplierController,
                        label: 'Supplier Name *',
                        icon: Icons.business_rounded,
                      ),
                      const SizedBox(height: 16),

                      // Total Price
                      _buildFormField(
                        controller: totalPriceController,
                        label: 'Total Price *',
                        icon: Icons.attach_money_rounded,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Phone
                      _buildFormField(
                        controller: phoneController,
                        label: 'Phone',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Address
                      _buildFormField(
                        controller: addressController,
                        label: 'Address',
                        icon: Icons.location_on_rounded,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Status Dropdown
                      _buildDropdown(
                        value: selectedStatus,
                        label: 'Status',
                        icon: Icons.stairs_rounded,
                        items: const [
                          'Pending',
                          'Processing',
                          'Completed',
                          'Cancelled',
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Payment Method Dropdown
                      _buildDropdown(
                        value: selectedPaymentMethod,
                        label: 'Payment Method',
                        icon: Icons.payment_rounded,
                        items: const [
                          'Cash',
                          'Credit Card',
                          'Bank Transfer',
                          'Check',
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      _buildFormField(
                        controller: notesController,
                        label: 'Notes',
                        icon: Icons.notes_rounded,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),

                      // Buttons
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
                                if (supplierController.text.isEmpty ||
                                    totalPriceController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please fill in required fields',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  final purchaseProvider =
                                      Provider.of<PurchaseProvider>(
                                        context,
                                        listen: false,
                                      );

                                  final newPurchase = Purchase(
                                    supplierName: supplierController.text,
                                    totalPrice: double.parse(
                                      totalPriceController.text,
                                    ),
                                    purchaseDate: DateTime.now()
                                        .toIso8601String(),

                                    status: selectedStatus,
                                    phone: phoneController.text.isNotEmpty
                                        ? phoneController.text
                                        : null,
                                    address: addressController.text.isNotEmpty
                                        ? addressController.text
                                        : null,
                                    paymentMethod: selectedPaymentMethod,
                                    notes: notesController.text.isNotEmpty
                                        ? notesController.text
                                        : null,
                                  );

                                  

                                  final details = <PurchaseDetail>[];
                                  await purchaseProvider.addPurchase(
                                    newPurchase,
                                    details,
                                  );

                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Purchase added successfully',
                                      ),
                                      backgroundColor: const Color(0xFF27AE60),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error adding purchase: $e',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
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
                              child: const Text(
                                'Save Purchase',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
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

  // Update form field with color parameter
  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Color iconColor = const Color(0xFF4A90E2), // Default blue
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: iconColor,
              ), // Use the color parameter
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF4A90E2)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  

  void _showEditPurchaseDialog(BuildContext context, {Purchase? purchase}) {
    if (purchase == null) return;

    final supplierController = TextEditingController(
      text: purchase.supplierName,
    );
    final totalPriceController = TextEditingController(
      text: purchase.totalPrice.toString(),
    );
    final phoneController = TextEditingController(text: purchase.phone ?? '');
    final addressController = TextEditingController(
      text: purchase.address ?? '',
    );
    final notesController = TextEditingController(text: purchase.notes ?? '');

    String selectedStatus = purchase.status ?? 'Pending';
    String selectedPaymentMethod = purchase.paymentMethod ?? 'Cash';

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
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A90E2).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              color: Color(0xFF4A90E2),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Edit Purchase',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Supplier Name
                      _buildFormField(
                        controller: supplierController,
                        label: 'Supplier Name *',
                        icon: Icons.business_rounded,
                      ),
                      const SizedBox(height: 16),

                      // Total Price
                      _buildFormField(
                        controller: totalPriceController,
                        label: 'Total Price *',
                        icon: Icons.attach_money_rounded,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),

                      // Phone
                      _buildFormField(
                        controller: phoneController,
                        label: 'Phone',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Address
                      _buildFormField(
                        controller: addressController,
                        label: 'Address',
                        icon: Icons.location_on_rounded,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Status Dropdown
                      _buildDropdown(
                        value: selectedStatus,
                        label: 'Status',
                        icon: Icons.stairs_rounded,
                        items: const [
                          'Pending',
                          'Processing',
                          'Completed',
                          'Cancelled',
                          'Shipped',
                          'Delivered',
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Payment Method Dropdown
                      _buildDropdown(
                        value: selectedPaymentMethod,
                        label: 'Payment Method',
                        icon: Icons.payment_rounded,
                        items: const [
                          'Cash',
                          'Credit Card',
                          'Bank Transfer',

                          'Mobile Payment',
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      _buildFormField(
                        controller: notesController,
                        label: 'Notes',
                        icon: Icons.notes_rounded,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),

                      // Buttons
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
                                if (supplierController.text.isEmpty ||
                                    totalPriceController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please fill in required fields',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  final purchaseProvider =
                                      Provider.of<PurchaseProvider>(
                                        context,
                                        listen: false,
                                      );

                                  final updatedPurchase = purchase.copyWith(
                                    supplierName: supplierController.text,
                                    totalPrice: double.parse(
                                      totalPriceController.text,
                                    ),
                                    status: selectedStatus,
                                    phone: phoneController.text.isNotEmpty
                                        ? phoneController.text
                                        : null,
                                    address: addressController.text.isNotEmpty
                                        ? addressController.text
                                        : null,
                                    paymentMethod: selectedPaymentMethod,
                                    notes: notesController.text.isNotEmpty
                                        ? notesController.text
                                        : null,
                                  );

                                  await purchaseProvider.updatePurchase(
                                    updatedPurchase,
                                  );

                                  if (mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Purchase PO-${purchase.id?.toString().padLeft(4, '0')} updated successfully',
                                        ),
                                        backgroundColor: const Color(
                                          0xFF27AE60,
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Error updating purchase: $e',
                                        ),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                }
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
                              child: const Text(
                                'Save',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
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
}

Color _getStatusColor(String? status) {
  switch (status?.toLowerCase()) {
    case 'completed':
      return const Color(0xFF27AE60);
    case 'processing':
      return const Color(0xFF3498DB);
    case 'pending':
      return const Color(0xFFF39C12);
    case 'cancelled':
      return const Color(0xFFE74C3C);
    default:
      return const Color(0xFF7F8C8D);
  }
}