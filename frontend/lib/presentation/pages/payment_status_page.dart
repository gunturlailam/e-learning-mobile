import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../data/services/payment_service.dart';
import '../../data/services/access_guard.dart';

class PaymentStatusPage extends StatefulWidget {
  final int paymentId;

  const PaymentStatusPage({
    super.key,
    required this.paymentId,
  });

  @override
  State<PaymentStatusPage> createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends State<PaymentStatusPage> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _paymentData;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await PaymentService.getPaymentStatus(widget.paymentId);

    if (!mounted) return;

    if (result['success'] == true) {
      setState(() {
        _paymentData = result['data'];
        _isLoading = false;
      });

      // Jika status disetujui, daftarkan akses secara lokal
      final status = _paymentData?['status'];
      final menuName = _paymentData?['menu_name'];
      if (status == 'approved' && menuName != null) {
        await AccessGuard.grantAccess(menuName);
      }
    } else {
      setState(() {
        _error = result['message'] ?? 'Gagal mengambil status pembayaran';
        _isLoading = false;
      });
    }
  }

  String _getMethodLabel(String method) {
    if (method == 'bank_transfer') return 'Transfer Bank';
    if (method == 'qr_code') return 'QRIS / QR Code';
    return method;
  }

  String _getStatusLabel(String status) {
    if (status == 'pending') return 'Menunggu';
    if (status == 'approved') return 'Disetujui';
    if (status == 'rejected') return 'Ditolak';
    return status;
  }

  Color _getStatusColor(String status) {
    if (status == 'pending') return Colors.amber;
    if (status == 'approved') return AppColors.primary;
    if (status == 'rejected') return AppColors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final status = _paymentData?['status'] ?? 'pending';
    final menuName = _paymentData?['menu_name'] ?? '-';
    final method = _paymentData?['method'] ?? '-';
    final amount = _paymentData?['amount']?.toString() ?? '-';
    final rejectReason = _paymentData?['reject_reason'] ?? _paymentData?['note'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Status Pembayaran',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 0.2,
          ),
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            // Kembali ke menu utama
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 60, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _fetchStatus,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchStatus,
                  color: AppColors.primary,
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      // Status Info Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Column(
                          children: [
                            // Glowing Status Icon
                            if (status == 'pending') ...[
                              Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: AppColors.softAmber,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.amber.withOpacity(0.18),
                                      blurRadius: 18,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.hourglass_empty_rounded,
                                  color: AppColors.amber,
                                  size: 38,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Menunggu Persetujuan',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.amber,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Bukti transfer sedang diperiksa oleh tim admin. Kami akan memverifikasi pembayaran Anda secepatnya.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ] else if (status == 'approved') ...[
                              Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: AppColors.softGreen,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.18),
                                      blurRadius: 18,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                  size: 38,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Pembayaran Disetujui!',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Pembayaran Anda telah sukses diverifikasi. Sekarang akses materi kursus sudah aktif dan siap dipelajari.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ] else ...[
                              Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: AppColors.softRed,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.red.withOpacity(0.18),
                                      blurRadius: 18,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.cancel_rounded,
                                  color: AppColors.red,
                                  size: 38,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Pembayaran Ditolak',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.red,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                rejectReason != null && rejectReason.isNotEmpty
                                    ? 'Alasan Penolakan: $rejectReason'
                                    : 'Mohon maaf, bukti pembayaran Anda ditolak oleh admin. Silakan periksa kembali bukti transfer Anda.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Detail Pembayaran Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Detail Pembayaran',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Divider(height: 1),
                            const SizedBox(height: 16),
                            _buildDetailRow('Menu', menuName),
                            const SizedBox(height: 12),
                            _buildDetailRow('Jumlah', 'Rp $amount'),
                            const SizedBox(height: 12),
                            _buildDetailRow('Metode', _getMethodLabel(method)),
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              'Status',
                              _getStatusLabel(status),
                              textColor: _getStatusColor(status),
                              fontWeight: FontWeight.w800,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Premium Action Button
                      if (status == 'approved')
                        GestureDetector(
                          onTap: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.25),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Mulai Belajar',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        )
                      else if (status == 'rejected')
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            child: const Text('Kembali ke Menu Utama'),
                          ),
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _fetchStatus,
                            icon: const Icon(Icons.refresh_rounded, size: 20),
                            label: const Text('Perbarui Status'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? textColor,
    FontWeight? fontWeight,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: fontWeight ?? FontWeight.w700,
            color: textColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
