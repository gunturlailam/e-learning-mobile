import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

/// Shimmer Loading Widget - Beautiful skeleton loading
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  
  const ShimmerLoading({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBase : Colors.grey.shade300,
      highlightColor: isDark ? AppColors.shimmerHighlight : Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer Card Loading - For list items
class ShimmerCardLoading extends StatelessWidget {
  const ShimmerCardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerLoading(width: double.infinity, height: 200, borderRadius: 16),
          const SizedBox(height: 12),
          const ShimmerLoading(width: 200, height: 20, borderRadius: 4),
          const SizedBox(height: 8),
          const ShimmerLoading(width: double.infinity, height: 16, borderRadius: 4),
          const SizedBox(height: 8),
          Row(
            children: const [
              ShimmerLoading(width: 80, height: 16, borderRadius: 4),
              SizedBox(width: 16),
              ShimmerLoading(width: 80, height: 16, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shimmer List Loading - For list views
class ShimmerListLoading extends StatelessWidget {
  final int itemCount;
  
  const ShimmerListLoading({
    Key? key,
    this.itemCount = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ShimmerCardLoading(),
    );
  }
}
