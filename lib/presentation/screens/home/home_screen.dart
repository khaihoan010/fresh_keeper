import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../config/routes.dart';
import '../../../config/constants.dart';
import '../../providers/product_provider.dart';

/// Home Screen / Dashboard
/// Shows overview of products and quick stats
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load dashboard data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🧊', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(
              AppConstants.appName,
              style: AppTheme.h2,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ProductProvider>().refresh(),
        child: Consumer<ProductProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading && provider.products.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      style: AppTheme.body1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.refresh(),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Stats Cards
                _buildStatsSection(provider),

                const SizedBox(height: 24),

                // Primary CTA
                _buildAddProductButton(),

                const SizedBox(height: 24),

                // Quick Access
                _buildQuickAccessSection(provider),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addProduct);
        },
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _navigateToTab(index);
        },
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.warning_amber_outlined),
                if (context.watch<ProductProvider>().expiringSoonCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${context.watch<ProductProvider>().expiringSoonCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: const Icon(Icons.warning_amber),
            label: 'Gần hết hạn',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Tất cả',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(ProductProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tổng quan',
          style: AppTheme.h3,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.inventory_2_outlined,
                title: 'Tổng sản phẩm',
                value: provider.totalCount.toString(),
                color: AppTheme.primaryColor,
                onTap: () => Navigator.pushNamed(context, AppRoutes.allItems),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.warning_amber_outlined,
                title: 'Gần hết hạn',
                value: provider.expiringSoonCount.toString(),
                color: provider.expiringSoonCount > 0
                    ? AppTheme.errorColor
                    : AppTheme.successColor,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.expiringSoon),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                value,
                style: AppTheme.h2.copyWith(color: color),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: AppTheme.body2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddProductButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addProduct);
        },
        icon: const Icon(Icons.add, size: 28),
        label: const Text('Thêm Sản Phẩm', style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection(ProductProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thêm gần đây',
              style: AppTheme.h3,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.allItems);
              },
              child: const Text('Xem tất cả →'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (provider.recentProducts.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    const Text('📦', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    Text(
                      'Chưa có sản phẩm nào',
                      style: AppTheme.body1.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...provider.recentProducts.take(5).map((product) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Text(
                  AppConstants.categoryIcons[product.category] ?? '📦',
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(product.name, style: AppTheme.h3),
                subtitle: Text(
                  '${product.daysRemainingText} • ${product.quantity} ${product.unit}',
                  style: AppTheme.body2,
                ),
                trailing: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: product.getStatusColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.productDetail,
                    arguments: product,
                  );
                },
              ),
            );
          }),
      ],
    );
  }

  void _navigateToTab(int index) {
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.expiringSoon);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.allItems);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.settings);
        break;
    }
  }
}
