import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/providers/theme_provider.dart';
import '../../presentation/providers/package_provider.dart';
import '../../presentation/providers/learning_material_provider.dart';
import '../widgets/menu_grid.dart';
import 'topics/topics_screen.dart';
import 'materials/materials_screen.dart';
import 'profile/profile_screen.dart';

/// Home Screen - Main navigation with bottom nav bar
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardTab(),
    TopicsScreen(),
    MaterialsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.topic_outlined),
            selectedIcon: Icon(Icons.topic),
            label: 'Topics',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: 'Materials',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Dashboard Tab - Home screen content (Pilih Kursus)
class DashboardTab extends StatefulWidget {
  const DashboardTab({Key? key}) : super(key: key);

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PackageProvider>().loadPackages();
      context.read<LearningMaterialProvider>().loadMaterials();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<PackageProvider>().loadPackages();
          await context.read<LearningMaterialProvider>().loadMaterials();
        },
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              title: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Image.asset(
                      'assets/images/g-learn.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('E-Learning'),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                  ),
                  onPressed: () => themeProvider.toggleTheme(),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroBanner(),
                    const SizedBox(height: 24),
                    _buildStatsRow(secondaryText),
                    const SizedBox(height: 28),
                    // Header Pilih Kursus + tombol Lihat Lainnya
                    Consumer<PackageProvider>(
                      builder: (context, provider, _) {
                        final hasMore = provider.packages.length > 4;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pilih Kursus',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Mulai perjalanan belajarmu hari ini',
                                  style: TextStyle(
                                      fontSize: 13, color: secondaryText),
                                ),
                              ],
                            ),
                            if (hasMore)
                              GestureDetector(
                                onTap: () => _showAllPackages(context, provider),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.primaryBlue
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Lihat Lainnya',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 14,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // MenuGrid: tampil max 4, sisanya di halaman "Lihat Lainnya"
                    const MenuGrid(maxItems: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pasti Jago Bahasa Inggris\nDengan Biaya Murah!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba gratis sekarang!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Scroll otomatis sudah terlihat; cukup muat ulang paket.
              context.read<PackageProvider>().loadPackages();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2563EB),
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Mulai Belajar',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(Color secondaryText) {
    return Consumer2<PackageProvider, LearningMaterialProvider>(
      builder: (context, pkg, mat, _) {
        return Row(
          children: [
            Expanded(
              child: _statCard(
                Icons.workspace_premium_rounded,
                '${pkg.packages.length}',
                'Paket Kursus',
                AppColors.primaryBlue,
                secondaryText,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _statCard(
                Icons.video_library_rounded,
                '${mat.materials.length}',
                'Total Materi',
                AppColors.primaryPurple,
                secondaryText,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _statCard(
    IconData icon,
    String value,
    String label,
    Color color,
    Color secondaryText,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 13, color: secondaryText)),
        ],
      ),
    );
  }

  Widget _buildPackageGrid(Color secondaryText) {
    // Diganti dengan MenuGrid sesuai modul Pertemuan 15
    return const SizedBox.shrink();
  }

  Widget _buildLoadingGrid() {
    return const SizedBox.shrink();
  }

  Widget _buildMessage({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color secondaryText,
  }) {
    return const SizedBox.shrink();
  }

  void _showAllPackages(BuildContext context, PackageProvider provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          child: const AllPackagesPage(),
        ),
      ),
    );
  }

  void _showPackageDetail(BuildContext context, dynamic package) {}

  Widget _chip(String text, Color color) => const SizedBox.shrink();
}

// ─── Halaman semua paket ─────────────────────────────────────────────────────

class AllPackagesPage extends StatelessWidget {
  const AllPackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Paket Kursus'),
      ),
      body: Consumer<PackageProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: provider.loadPackages,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: MenuGrid(maxItems: provider.packages.length),
            ),
          );
        },
      ),
    );
  }
}
