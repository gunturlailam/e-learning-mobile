import 'package:flutter/material.dart';
import '../../data/models/topic_model.dart';
import '../../data/models/speaking_material_model.dart';

// ─── Dark Mode Theme Colors ───────────────────────────────────────────────────
class DarkTheme {
  static const bgPrimary = Color(0xFF0A0E27);
  static const bgSecondary = Color(0xFF151932);
  static const bgTertiary = Color(0xFF1E2139);
  static const accentBlue = Color(0xFF00D9FF);
  static const accentMint = Color(0xFF7FFFD4);
  static const accentPurple = Color(0xFF8B5CF6);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF94A3B8);
  static const textTertiary = Color(0xFF64748B);
}

// ─── Daily Streak Card (Bento) ────────────────────────────────────────────────

class DailyStreakCard extends StatelessWidget {
  final int streak;
  final AnimationController pulseController;

  const DailyStreakCard({
    super.key,
    required this.streak,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DarkTheme.bgSecondary,
            DarkTheme.bgTertiary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DarkTheme.accentBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '🔥',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Streak',
                style: TextStyle(
                  color: DarkTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (pulseController.value * 0.1),
                    child: Text(
                      '$streak',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [
                              Colors.orange,
                              Colors.deepOrange,
                            ],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                    ),
                  );
                },
              ),
              Text(
                'Hari Berturut-turut',
                style: TextStyle(
                  color: DarkTheme.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Course Progress Card (Bento) ─────────────────────────────────────────────

class CourseProgressCard extends StatelessWidget {
  final double progress;

  const CourseProgressCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DarkTheme.bgSecondary,
            DarkTheme.bgTertiary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DarkTheme.accentMint.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      DarkTheme.accentMint.withOpacity(0.3),
                      DarkTheme.accentBlue.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: DarkTheme.accentMint,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Progress',
                style: TextStyle(
                  color: DarkTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: DarkTheme.bgTertiary,
                      valueColor: const AlwaysStoppedAnimation(
                        DarkTheme.accentMint,
                      ),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: DarkTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Hero Card - Continue Learning (Bento) ────────────────────────────────────

class HeroCard extends StatelessWidget {
  final List<SpeakingMaterialModel> materials;
  final VoidCallback onTap;

  const HeroCard({
    super.key,
    required this.materials,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              DarkTheme.accentBlue,
              DarkTheme.accentMint,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: DarkTheme.accentBlue.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_circle_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Lanjutkan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lanjutkan Belajar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      materials.isNotEmpty
                          ? materials.first.title
                          : 'Tidak ada materi',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Play icon
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stat Bento Card ──────────────────────────────────────────────────────────

class StatBentoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<Color> gradient;

  const StatBentoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DarkTheme.bgSecondary,
            DarkTheme.bgTertiary,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: gradient.first.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: gradient.map((c) => c.withOpacity(0.2)).toList()),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: gradient.first, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: gradient.first,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: DarkTheme.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Section Header Dark ──────────────────────────────────────────────────────

class SectionHeaderDark extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const SectionHeaderDark({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                DarkTheme.accentBlue.withOpacity(0.2),
                DarkTheme.accentMint.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: DarkTheme.accentBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: DarkTheme.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: DarkTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Material Card Dark ───────────────────────────────────────────────────────

class MaterialCardDark extends StatelessWidget {
  final SpeakingMaterialModel material;
  final VoidCallback onTap;

  const MaterialCardDark({super.key, required this.material, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              DarkTheme.bgSecondary,
              DarkTheme.bgTertiary,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: DarkTheme.accentBlue.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 110,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [DarkTheme.accentBlue, DarkTheme.accentMint],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (material.pdf != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.picture_as_pdf,
                                size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'PDF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: DarkTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(
                        Icons.videocam_rounded,
                        size: 14,
                        color: DarkTheme.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Video Materi',
                        style: TextStyle(
                          fontSize: 11,
                          color: DarkTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Topic Card Dark ──────────────────────────────────────────────────────────

class TopicCardDark extends StatelessWidget {
  final TopicModel topic;

  const TopicCardDark({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DarkTheme.bgSecondary,
            DarkTheme.bgTertiary,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: DarkTheme.accentBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [DarkTheme.accentBlue, DarkTheme.accentMint],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: DarkTheme.textPrimary,
                  ),
                ),
                if (topic.description != null && topic.description!.isNotEmpty)
                  Text(
                    topic.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: DarkTheme.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: topic.isFree
                  ? LinearGradient(
                      colors: [
                        DarkTheme.accentMint.withOpacity(0.3),
                        DarkTheme.accentMint.withOpacity(0.2),
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        DarkTheme.accentPurple.withOpacity(0.3),
                        DarkTheme.accentPurple.withOpacity(0.2),
                      ],
                    ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: topic.isFree
                    ? DarkTheme.accentMint.withOpacity(0.5)
                    : DarkTheme.accentPurple.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Text(
              topic.isFree ? 'Gratis' : '\$${topic.price.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: topic.isFree ? DarkTheme.accentMint : DarkTheme.accentPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
