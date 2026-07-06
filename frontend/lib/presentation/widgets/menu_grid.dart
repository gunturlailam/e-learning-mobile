import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/package_model.dart';
import '../../data/services/access_guard.dart';
import '../../routes/app_routes.dart';
import '../../presentation/providers/package_provider.dart';
import '../pages/package_detail_page.dart';
import '../pages/payment_method_page.dart';

/// MenuGrid - Widget grid menu paket kursus dari API
/// Sesuai modul Pertemuan 15 — pakai PackageProvider agar sinkron dengan stat card
class MenuGrid extends StatefulWidget {
  final int maxItems; // -1 = tampil semua

  const MenuGrid({super.key, this.maxItems = -1});

  @override
  State<MenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> {
  @override
  void initState() {
    super.initState();
    // Load via provider agar data sinkron dengan stat card
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PackageProvider>();
      if (provider.packages.isEmpty && !provider.isLoading) {
        provider.loadPackages();
      }
    });
  }

  IconData _getIcon(String name) {
    switch (name.toLowerCase()) {
      case 'speaking':
        return Icons.record_voice_over;
      case 'vocabulary':
        return Icons.menu_book;
      case 'grammar':
        return Icons.edit_note;
      case 'listening':
        return Icons.headphones;
      case 'quiz':
        return Icons.quiz;
      case 'daily practice':
        return Icons.auto_stories;
      default:
        return Icons.school;
    }
  }

  Color _getColor(int index) {
    final colors = [
      const Color(0xFF00897B),
      const Color(0xFFFFF8E1),
      const Color(0xFF6A1B9A),
      const Color(0xFF00ACC1),
      const Color(0xFFE53935),
      const Color(0xFF43A047),
      const Color(0xFF5C6BC0),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PackageProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.packages.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            ),
          );
        }

        if (provider.hasError && provider.packages.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    'Gagal memuat paket\n${provider.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.loadPackages(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.packages.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Icon(Icons.inbox_rounded, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum ada paket tersedia',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.loadPackages(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          );
        }

        final packages = widget.maxItems > 0 && provider.packages.length > widget.maxItems
            ? provider.packages.sublist(0, widget.maxItems)
            : provider.packages;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: packages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final package = packages[index];
            return _PackageTile(
              packageId: package.id,
              title: package.name,
              displayName: package.displayName,
              icon: _getIcon(package.name),
              color: _getColor(index),
              isFree: package.isFree,
            );
          },
        );
      },
    );
  }
}

// ─── _PackageTile ────────────────────────────────────────────────────────────

class _PackageTile extends StatefulWidget {
  final int packageId;
  final String title;
  final String displayName;
  final IconData icon;
  final Color color;
  final bool isFree;

  const _PackageTile({
    required this.packageId,
    required this.title,
    required this.displayName,
    required this.icon,
    required this.color,
    required this.isFree,
  });

  @override
  State<_PackageTile> createState() => _PackageTileState();
}

class _PackageTileState extends State<_PackageTile> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    // Paket gratis langsung masuk
    if (widget.isFree) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PackageDetailPage(
              packageId: widget.packageId,
              packageName: widget.displayName,
            ),
          ));
      return;
    }

    setState(() => _isLoading = true);
    final result = await AccessGuard.checkAccess(widget.title);
    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case 'granted':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PackageDetailPage(
                packageId: widget.packageId,
                packageName: widget.displayName,
              ),
            ));
        break;
      case 'login_required':
        Navigator.pushNamed(context, AppRoutes.login);
        break;
      case 'payment_required':
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentMethodPage(
                menuName: widget.title,
                packageId: widget.packageId,
              ),
            ));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan.'),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        HSLColor.fromColor(widget.color).lightness > 0.7
            ? Colors.black87
            : Colors.white;

    return GestureDetector(
      onTap: _isLoading ? null : _handleTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
          border: Border(
            bottom: BorderSide(
              color: HSLColor.fromColor(widget.color)
                  .withLightness(
                    (HSLColor.fromColor(widget.color).lightness - 0.15)
                        .clamp(0.0, 1.0),
                  )
                  .toColor(),
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.3),
              blurRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Icon(widget.icon, color: textColor, size: 30),
                ),
                // Lock badge untuk paket berbayar
                if (!widget.isFree)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.displayName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
