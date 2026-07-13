import 'package:flutter/material.dart';
import '../../data/models/certificate_model.dart';
import '../../data/services/certificate_service.dart';

/// Halaman untuk menampilkan sertifikat kelulusan secara full-screen
class CertificateViewPage extends StatefulWidget {
  final int packageId;
  final String packageName;
  final CertificateModel? certificate; // opsional, bisa diisi langsung

  const CertificateViewPage({
    super.key,
    required this.packageId,
    required this.packageName,
    this.certificate,
  });

  @override
  State<CertificateViewPage> createState() => _CertificateViewPageState();
}

class _CertificateViewPageState extends State<CertificateViewPage>
    with SingleTickerProviderStateMixin {
  CertificateModel? _cert;
  bool _loading = true;
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    if (widget.certificate != null) {
      _cert = widget.certificate;
      _loading = false;
      _controller.forward();
    } else {
      _load();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final certs = await CertificateService.getMyCertificates();
    if (!mounted) return;
    final found = certs.where((c) => c.packageId == widget.packageId).toList();
    setState(() {
      _cert = found.isNotEmpty ? found.first : null;
      _loading = false;
    });
    if (_cert != null) _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        title: const Text('Sertifikat Kelulusan',
            style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
          : _cert == null
              ? _buildNotEarned()
              : _buildCertificate(),
    );
  }

  Widget _buildNotEarned() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium_outlined,
                size: 72, color: Colors.white24),
            const SizedBox(height: 20),
            const Text('Sertifikat Belum Tersedia',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text(
              'Selesaikan quiz "${widget.packageName}" dengan nilai lulus untuk mendapatkan sertifikat.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Kembali'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B1FA2),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificate() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: _CertificateCard(
            recipientName: 'Peserta',
            packageName: widget.packageName,
            certCode: _cert!.certificateCode,
            issuedDate: _cert!.formattedIssuedDate,
          ),
        ),
      ),
    );
  }
}

// ─────────────── Certificate Card Widget ───────────────────────────────────

class _CertificateCard extends StatelessWidget {
  final String recipientName;
  final String packageName;
  final String certCode;
  final String issuedDate;

  const _CertificateCard({
    required this.recipientName,
    required this.packageName,
    required this.certCode,
    required this.issuedDate,
  });

  static const _gold = Color(0xFFD4AF37);
  static const _darkGold = Color(0xFFB8860B);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFAF5E4), Color(0xFFFFF9ED), Color(0xFFFAF5E4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _gold, width: 3),
        boxShadow: [
          BoxShadow(
              color: _gold.withOpacity(0.35),
              blurRadius: 30,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          // Corner ornaments
          _cornerOrnament(top: 12, left: 12, flip: false),
          _cornerOrnament(top: 12, right: 12, flip: true),
          _cornerOrnament(bottom: 12, left: 12, flip: true),
          _cornerOrnament(bottom: 12, right: 12, flip: false),

          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header logo
                const Icon(Icons.school_rounded, size: 48, color: _gold),
                const SizedBox(height: 6),
                const Text(
                  'E-LEARNING',
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w800,
                    color: _darkGold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                    height: 2, width: 160, color: _gold.withOpacity(0.5)),
                const SizedBox(height: 20),

                // Certificate title
                const Text(
                  'SERTIFIKAT\nKELULUSAN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF3B2A00),
                    letterSpacing: 2,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Dengan bangga diberikan kepada',
                  style: TextStyle(
                      color: Colors.brown, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 14),

                // Recipient name
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: _gold.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: _gold.withOpacity(0.5), width: 1),
                  ),
                  child: Text(
                    recipientName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF3B2A00),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  'atas keberhasilannya menyelesaikan kelas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.brown, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 10),

                // Package name
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFD4AF37), Color(0xFFB8860B)]),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '"$packageName"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Divider with ornament
                Row(
                  children: [
                    Expanded(
                        child: Divider(color: _gold.withOpacity(0.5), thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.stars_rounded,
                          color: _gold, size: 20),
                    ),
                    Expanded(
                        child: Divider(color: _gold.withOpacity(0.5), thickness: 1)),
                  ],
                ),
                const SizedBox(height: 20),

                // Date and signature row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tanggal Terbit',
                            style:
                                TextStyle(color: Colors.brown, fontSize: 11)),
                        const SizedBox(height: 4),
                        Text(issuedDate,
                            style: const TextStyle(
                              color: Color(0xFF3B2A00),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            )),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Signature line
                        SizedBox(
                          width: 110,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                'Administrator',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: _darkGold.withOpacity(0.5),
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                            color: _gold.withOpacity(0.7),
                            thickness: 1.5,
                            endIndent: 0),
                        const Text('E-Learning Admin',
                            style: TextStyle(
                                color: Colors.brown,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Medal seal
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFD4AF37)],
                    ),
                    border: Border.all(color: _darkGold, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                          color: _gold.withOpacity(0.6), blurRadius: 12),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.verified_rounded,
                      color: Colors.white, size: 38),
                ),
                const SizedBox(height: 16),

                // Certificate code
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.brown.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.qr_code_2_rounded,
                          color: _darkGold, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        certCode,
                        style: const TextStyle(
                          color: Color(0xFF3B2A00),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornerOrnament(
      {double? top, double? bottom, double? left, double? right, required bool flip}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform(
        transform: flip
            ? (Matrix4.identity()..rotateZ(1.5708))
            : Matrix4.identity(),
        child: const Text('✦',
            style: TextStyle(color: Color(0xFFD4AF37), fontSize: 20)),
      ),
    );
  }
}
