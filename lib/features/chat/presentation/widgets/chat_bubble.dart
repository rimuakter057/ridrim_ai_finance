import 'dart:io';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../domain/entities/chat_message.dart';

/// A single chat message bubble.
/// User messages are blue and aligned right (with timestamp and double checkmark).
/// AI messages have official app logo avatar on the left, dark container, and tap-to-reveal
/// action buttons (Like, Dislike, Copy, Regenerate) which are HIDDEN BY DEFAULT.
class ChatBubble extends StatefulWidget {
  const ChatBubble({super.key, required this.message, this.onRegenerate});

  final ChatMessage message;
  final VoidCallback? onRegenerate;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  // AI message actions are HIDDEN BY DEFAULT. Tapping the bubble reveals them.
  bool _showActions = false;
  bool? _isLiked;

  void _toggleActions() {
    if (widget.message.isFromUser) return;
    setState(() => _showActions = !_showActions);
  }

  void _copyToClipboard(BuildContext context) {
    context.showSnackBar('Message copied to clipboard');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final bool isUser = widget.message.isFromUser;

    if (isUser) {
      final bool hasImage = widget.message.hasImage;
      final bool hasText = widget.message.content.isNotEmpty;
      final BorderRadius bubbleRadius = BorderRadius.only(
        topLeft: Radius.circular(responsive.radius(AppRadius.lg)),
        topRight: Radius.circular(responsive.radius(AppRadius.lg)),
        bottomLeft: Radius.circular(responsive.radius(AppRadius.lg)),
        bottomRight: Radius.circular(responsive.radius(AppRadius.xs)),
      );

      // ── User Message Bubble (Right aligned, clean, no action buttons) ──
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(maxWidth: responsive.widthPercent(76)),
          margin: EdgeInsets.only(bottom: responsive.spacing(AppSpacing.md)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasImage)
                ClipRRect(
                  borderRadius: bubbleRadius,
                  child: Stack(
                    children: [
                      Image.file(
                        File(widget.message.imagePath!),
                        width: responsive.width(200),
                        height: responsive.width(200),
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: responsive.spacing(AppSpacing.xs),
                        bottom: responsive.spacing(AppSpacing.xs),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.message.timestamp.toFormattedTime(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.white,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.done_all_rounded,
                                size: 12,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (hasText) ...[
                if (hasImage)
                  SizedBox(height: responsive.spacing(AppSpacing.xs)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.spacing(AppSpacing.lg),
                    vertical: responsive.spacing(AppSpacing.md),
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: bubbleRadius,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.message.content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.white,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: responsive.spacing(AppSpacing.xs / 2)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.message.timestamp.toFormattedTime(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.white.withValues(alpha: 0.75),
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.done_all_rounded,
                            size: 14,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // ── AI Message Bubble (Left aligned, glassmorphic) ──────────────────
    final BorderRadius aiBubbleRadius = BorderRadius.only(
      topLeft: Radius.circular(responsive.radius(AppRadius.lg)),
      topRight: Radius.circular(responsive.radius(AppRadius.lg)),
      bottomLeft: Radius.circular(responsive.radius(AppRadius.xs)),
      bottomRight: Radius.circular(responsive.radius(AppRadius.lg)),
    );
    final bool isDark = theme.brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: responsive.spacing(AppSpacing.md)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gradient AI Avatar Icon
            Container(
              width: responsive.width(36),
              height: responsive.width(36),
              margin: EdgeInsets.only(right: responsive.spacing(AppSpacing.sm)),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: responsive.iconSize(16),
                color: Colors.white,
              ),
            ),

            // Message Bubble Box
            Flexible(
              child: GestureDetector(
                onTap: _toggleActions,
                child: ClipRRect(
                  borderRadius: aiBubbleRadius,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: responsive.widthPercent(76),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.spacing(AppSpacing.lg),
                        vertical: responsive.spacing(AppSpacing.md),
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.glassOverlayDark
                            : AppColors.glassOverlayLight,
                        borderRadius: aiBubbleRadius,
                        border: Border.all(
                          color: isDark
                              ? AppColors.glassBorderDark
                              : AppColors.glassBorderLight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.message.content,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(
                            height: responsive.spacing(AppSpacing.xs / 2),
                          ),
                          Text(
                            widget.message.timestamp.toFormattedTime(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),

                          if (widget.message.hasChart) ...[
                            SizedBox(height: responsive.spacing(AppSpacing.sm)),
                            _AiInsightChart(
                              values: widget.message.chartValues!,
                              labels: widget.message.chartLabels,
                            ),
                          ],

                          // Actions Row (Shown ONLY when user taps this AI message)
                          if (_showActions) ...[
                            SizedBox(height: responsive.spacing(AppSpacing.sm)),
                            Divider(
                              height: 1,
                              color: colorScheme.outline.withValues(alpha: 0.2),
                            ),
                            SizedBox(height: responsive.spacing(AppSpacing.xs)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Thumbs Up
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    _isLiked == true
                                        ? Icons.thumb_up_rounded
                                        : Icons.thumb_up_outlined,
                                    size: 18,
                                    color: _isLiked == true
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isLiked = _isLiked == true ? null : true;
                                    });
                                  },
                                ),
                                // Thumbs Down
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    _isLiked == false
                                        ? Icons.thumb_down_rounded
                                        : Icons.thumb_down_outlined,
                                    size: 18,
                                    color: _isLiked == false
                                        ? Colors.red
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isLiked = _isLiked == false
                                          ? null
                                          : false;
                                    });
                                  },
                                ),
                                // Copy
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.copy_rounded,
                                    size: 18,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () => _copyToClipboard(context),
                                ),
                                // Regenerate
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.refresh_rounded,
                                    size: 18,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: widget.onRegenerate,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small bar chart rendered inline under an AI reply that answers a
/// chart-worthy question (spending trend, cash flow) -- the "graph chart"
/// surface of the AI-first assistant.
class _AiInsightChart extends StatelessWidget {
  const _AiInsightChart({required this.values, this.labels});

  final List<double> values;
  final List<String>? labels;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final double maxAbs = values
        .map((v) => v.abs())
        .fold<double>(0, (max, v) => v > max ? v : max);
    final double axisPad = (maxAbs * 0.2).clamp(1, double.infinity);

    return SizedBox(
      height: responsive.width(96),
      child: BarChart(
        BarChartData(
          maxY: maxAbs + axisPad,
          minY: -(maxAbs + axisPad),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: labels != null,
                reservedSize: 18,
                getTitlesWidget: (value, meta) {
                  final int index = value.toInt();
                  if (labels == null || index < 0 || index >= labels!.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    labels![index],
                    style: theme.textTheme.labelSmall?.copyWith(fontSize: 9),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (int i = 0; i < values.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: values[i],
                    width: 10,
                    borderRadius: BorderRadius.circular(3),
                    color: values[i] >= 0
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
