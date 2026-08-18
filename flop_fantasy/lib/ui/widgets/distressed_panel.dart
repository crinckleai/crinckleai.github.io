import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// A bordered panel with optional title bar — used everywhere to keep the
/// "ransom note" / distressed feel consistent.
class DistressedPanel extends StatelessWidget {
  const DistressedPanel({
    super.key,
    this.title,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.accent,
  });

  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final stripe = accent ?? AppTheme.accentRust;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgPanel,
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Container(
              decoration: BoxDecoration(
                color: AppTheme.bgRaised,
                border: Border(
                  bottom: BorderSide(color: AppTheme.border),
                  left: BorderSide(color: stripe, width: 3),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}
