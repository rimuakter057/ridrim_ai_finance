import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Premium animated voice input overlay, backed by real on-device speech
/// recognition (via `speech_to_text`).
///
/// Shows waveform-style animated bars around the mic icon while actively
/// listening. Call [showVoiceInputSheet] to display it -- it resolves to
/// the recognized text (or `null` if permission was denied, recognition
/// failed, or the user cancelled).
class VoiceInputSheet extends StatefulWidget {
  const VoiceInputSheet({super.key});

  @override
  State<VoiceInputSheet> createState() => _VoiceInputSheetState();
}

class _VoiceInputSheetState extends State<VoiceInputSheet>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _waveController;
  late final List<AnimationController> _barControllers;
  late final List<Animation<double>> _barAnimations;

  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  String _statusText = 'Getting ready…';
  String _recognizedText = '';
  final int _barCount = 7;

  @override
  void initState() {
    super.initState();

    // Outer pulse ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Wave controller
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: false);

    // Individual bar controllers (staggered)
    _barControllers = List.generate(
      _barCount,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + i * 60),
      ),
    );

    _barAnimations = _barControllers
        .map((c) => Tween<double>(begin: 0.2, end: 1.0).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();

    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final bool available = await _speech.initialize(
      onStatus: _onSpeechStatus,
      onError: (_) => _finishWithError('Something went wrong. Please try again.'),
    );
    if (!mounted) return;

    if (!available) {
      _finishWithError('Microphone permission denied.');
      return;
    }

    setState(() {
      _isListening = true;
      _statusText = 'Listening…';
    });

    // Stagger bar start times, same as the original design.
    for (int i = 0; i < _barControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 60), () {
        if (mounted) _barControllers[i].repeat(reverse: true);
      });
    }

    unawaited(_speech.listen(onResult: _onSpeechResult));
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() => _recognizedText = result.recognizedWords);
  }

  void _onSpeechStatus(String status) {
    // The engine can stop itself on end-of-speech/timeout -- treat that the
    // same as the user tapping the mic to stop.
    if (status == 'notListening' && _isListening) {
      _finishListening();
    }
  }

  void _stopBarAnimations() {
    for (final c in _barControllers) {
      c.stop();
    }
  }

  /// User (or the recognizer) stopped listening normally -- return whatever
  /// text was recognized so far.
  void _finishListening() {
    if (!mounted) return;
    setState(() {
      _isListening = false;
      _statusText = 'Processing…';
    });
    _stopBarAnimations();
    unawaited(_speech.stop());

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final String text = _recognizedText.trim();
      Navigator.of(context).pop(text.isEmpty ? null : text);
    });
  }

  /// Permission denied, recognizer unavailable, or an error occurred --
  /// show the reason in the existing status text, then close with no result.
  void _finishWithError(String message) {
    if (!mounted) return;
    setState(() {
      _isListening = false;
      _statusText = message;
    });
    _stopBarAnimations();

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    unawaited(_speech.cancel());
    _pulseController.dispose();
    _waveController.dispose();
    for (final c in _barControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ResponsiveHelper responsive = ResponsiveHelper.of(context);
    final Color primary = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        responsive.spacing(AppSpacing.xl),
        responsive.spacing(AppSpacing.lg),
        responsive.spacing(AppSpacing.xl),
        responsive.spacing(AppSpacing.xxl) +
            MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),

          Text(
            'Voice Input',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: responsive.spacing(AppSpacing.xs)),
          Text(
            'Speak your message clearly',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: responsive.spacing(AppSpacing.xxl)),

          // ── Animated Waveform Bars ──────────────────────────────────────
          SizedBox(
            height: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(_barCount, (i) {
                final double maxHeight = i == _barCount ~/ 2
                    ? 72
                    : (i == _barCount ~/ 2 - 1 || i == _barCount ~/ 2 + 1)
                        ? 58
                        : (i == _barCount ~/ 2 - 2 || i == _barCount ~/ 2 + 2)
                            ? 44
                            : 28;
                return AnimatedBuilder(
                  animation: _barAnimations[i],
                  builder: (context, _) {
                    final double h =
                        _isListening ? maxHeight * _barAnimations[i].value : 6;
                    return Container(
                      width: 5,
                      height: h.clamp(6, 72),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            primary,
                            primary.withValues(alpha: 0.4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                    );
                  },
                );
              }),
            ),
          ),

          SizedBox(height: responsive.spacing(AppSpacing.xl)),

          // ── Pulsing Mic Button ──────────────────────────────────────────
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulse ring
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  return Container(
                    width: 90 + 20 * _pulseController.value,
                    height: 90 + 20 * _pulseController.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary
                          .withValues(alpha: 0.08 * (1 - _pulseController.value)),
                    ),
                  );
                },
              ),
              // Middle ring
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.12),
                ),
              ),
              // Core mic button
              GestureDetector(
                onTap: _isListening ? _finishListening : null,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primary,
                        AppColors.primaryDeep,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.45),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isListening
                        ? Icons.mic_rounded
                        : Icons.stop_rounded,
                    color: AppColors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: responsive.spacing(AppSpacing.lg)),

          Text(
            _statusText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: responsive.spacing(AppSpacing.lg)),

          // ── Cancel Button ───────────────────────────────────────────────
          TextButton(
            onPressed: () {
              unawaited(_speech.cancel());
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                side: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// Shows the voice input bottom sheet and starts listening immediately.
/// Resolves to the recognized text, or `null` if the sheet was cancelled,
/// permission was denied, or nothing was recognized.
Future<String?> showVoiceInputSheet(BuildContext context) {
  return showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => const VoiceInputSheet(),
  );
}
