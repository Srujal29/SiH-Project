import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final ShapeBorder? shape;
  final double? elevation;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.margin,
    this.color,
    this.shape,
    this.elevation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 4,
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      // Let the theme decide the color unless one is provided
      color: color, 
      surfaceTintColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: onTap == null
          ? child
          : InkWell(
              onTap: onTap,
              child: child,
            ),
    );
  }
}