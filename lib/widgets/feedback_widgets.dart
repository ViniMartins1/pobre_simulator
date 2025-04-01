import 'package:flutter/material.dart';
import 'package:pobre_simulator/utils/style_presets.dart';

enum SnackbarAction {
  success(StylePresets.cGreen),
  error(StylePresets.cRed),
  warning(StylePresets.cYellow),
  info(StylePresets.cBlue);

  final Color color;
  const SnackbarAction(this.color);
}

class FeedbackWidgets {
  static Future<void> showProgressSnackBar({
    required BuildContext context,
    required String message,
    required SnackbarAction action,
    Duration duration = const Duration(seconds: 3),
  }) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.hideCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _ProgressBar(duration: duration),
              ],
            ),
          ],
        ),
        duration: duration,
        backgroundColor: action.color,
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _ProgressBar extends StatefulWidget {
  final Duration duration;
  const _ProgressBar({required this.duration});

  @override
  State<_ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<_ProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _controller.value,
          backgroundColor: Colors.white24,
          valueColor: const AlwaysStoppedAnimation<Color>(StylePresets.cAccentColor),
        );
      },
    );
  }
}
