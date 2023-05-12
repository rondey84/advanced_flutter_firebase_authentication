import 'dart:ui';

import 'package:advanced_flutter_firebase_authentication/core/utils/country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/dialog/dialog_route.dart';

enum TransitionType {
  scale_fadeIn,
  fadeTransition;

  RouteTransitionsBuilder get _transitionBuilder {
    return (_, animation, __, child) {
      switch (this) {
        case TransitionType.scale_fadeIn:
          return ScaleTransition(
            scale: Tween<double>(begin: 0.2, end: 1.0).animate(animation),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.4, end: 1.0).animate(animation),
              child: child,
            ),
          );
        case TransitionType.fadeTransition:
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.linear),
            child: child,
          );
      }
    };
  }
}

extension CustomDialogExtension on GetInterface {
  Future<T?> customDialog<T>({
    required Widget? child,
    // Barrier Related
    bool barrierDismissible = false,
    String? barrierLabel,
    Color? barrierColor,
    double? filterBlur,

    // Dialog UI related
    EdgeInsetsGeometry? contentPadding,
    Color? dialogColor,
    Color? borderColor,
    double? borderRadius,

    // Dialog Utils Related
    Duration? transitionDuration,
    GlobalKey<NavigatorState>? navigatorKey,
    RouteSettings? routeSettings,
    TransitionType transition = TransitionType.scale_fadeIn,
    bool removeDuplicateDialog = true,
  }) async {
    assert(!barrierDismissible || barrierLabel != null);

    if (removeDuplicateDialog && (Get.isDialogOpen ?? false)) {
      Get.back(closeOverlays: true);
    }

    final nav = navigatorKey?.currentState ??
        Navigator.of(overlayContext!, rootNavigator: true);

    return await nav.push<T>(
      _CustomDialogRoute<T>(
        pageBuilder: (_, __, ___) => _CustomDialogBody(
          child,
          contentPadding: contentPadding,
          dialogColor: dialogColor,
          borderColor: borderColor,
          borderRadius: borderRadius,
        ),
        transitionBuilder: transition._transitionBuilder,
        transitionDuration: transitionDuration,
        settings: routeSettings,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        barrierColor: barrierColor,
        filterBlur: filterBlur,
      ),
    );
  }

  Future<T?> countrySelectDropDown<T>({
    // Dialog Utils Related
    required GlobalKey<NavigatorState> navigatorKey,
    RouteSettings? routeSettings,
    // Barrier Related
    // Dialog UI related
    EdgeInsetsGeometry? contentPadding,
    Color? dialogColor,
    double? borderRadius,
  }) async {
    final nav = navigatorKey.currentState ??
        Navigator.of(overlayContext!, rootNavigator: true);

    final countryData = await readCountryData();

    return await nav.push<T>(
      _CustomDialogRoute(
        pageBuilder: (_, __, ___) => _CustomDialogBody.positioned(
          CountryPicker(countryCodes: countryData),
          targetContext: navigatorKey.currentContext,
          contentPadding: contentPadding ?? const EdgeInsets.all(10),
          dialogColor: dialogColor ?? const Color(0xFF1E1E1E),
          borderRadius: borderRadius ?? 8,
          borderColor: Colors.transparent,
        ),
        transitionBuilder: TransitionType.fadeTransition._transitionBuilder,
        barrierDismissible: true,
        barrierLabel: 'Country Picker',
        filterBlur: 0,
      ),
    );
  }
}

class _CustomDialogBody extends StatefulWidget {
  const _CustomDialogBody(
    this.child, {
    this.contentPadding,
    this.dialogColor,
    this.borderRadius,
    this.borderColor,
  })  : _isPositioned = false,
        targetContext = null;

  const _CustomDialogBody.positioned(
    this.child, {
    required this.targetContext,
    this.contentPadding,
    this.dialogColor,
    this.borderRadius,
    this.borderColor,
  }) : _isPositioned = true;

  final Widget? child;
  final EdgeInsetsGeometry? contentPadding;
  final Color? dialogColor;
  final double? borderRadius;
  final Color? borderColor;

  final bool _isPositioned;
  final BuildContext? targetContext;

  @override
  State<_CustomDialogBody> createState() => _CustomDialogBodyState();
}

class _CustomDialogBodyState extends State<_CustomDialogBody> {
  final dialogKey = GlobalKey();
  Size dialogSize = Size.zero;
  late final Offset targetCenter;
  late final Size targetSize;

  final Size triangleSize = const Size(20, 15);

  @override
  void initState() {
    super.initState();
    _beforeLayout();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _beforeLayout() {
    if (!widget._isPositioned) return;

    final renderBox = widget.targetContext!.findRenderObject() as RenderBox;
    targetSize = renderBox.size;
    targetCenter = renderBox.localToGlobal(
      renderBox.size.center(Offset.zero),
      ancestor: Overlay.of(widget.targetContext!).context.findRenderObject()
          as RenderBox?,
    );
  }

  void _afterLayout(_) {
    if (!widget._isPositioned) return;

    final dialogRenderBox =
        dialogKey.currentContext?.findRenderObject() as RenderBox;

    setState(() {
      dialogSize = dialogRenderBox.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dialogParentPadding = Get.mediaQuery.viewInsets +
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0);
    final contentPadding = widget.contentPadding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 32);

    return AnimatedPadding(
      padding: dialogParentPadding,
      duration: 100.milliseconds,
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: Get.context!,
        child: _positionedDialog(
          ConstrainedBox(
            key: dialogKey,
            constraints: BoxConstraints(
              minWidth: widget._isPositioned ? 0 : 280,
            ),
            child: Material(
              color: Colors.transparent,
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.dialogColor ?? Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 32,
                  ),
                  border: widget._isPositioned
                      ? null
                      : Border.all(
                          color: widget.borderColor ??
                              Colors.black.withOpacity(0.2),
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                  boxShadow: widget._isPositioned
                      ? null
                      : [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.07),
                            blurRadius: 20,
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                ),
                child: Padding(padding: contentPadding, child: widget.child),
              ),
            ),
          ),
          dialogParentPadding,
        ),
      ),
    );
  }

  Widget _positionedDialog(
    Widget dialog,
    EdgeInsetsGeometry dialogParentPadding,
  ) {
    if (widget._isPositioned) {
      return Stack(
        children: [
          Positioned(
            left: targetCenter.dx -
                triangleSize.width / 2 -
                dialogParentPadding.resolve(TextDirection.ltr).left,
            top: targetCenter.dy,
            child: CustomPaint(
              painter: _TrianglePainter(
                strokeColor:
                    widget.dialogColor ?? Colors.black.withOpacity(0.5),
                strokeWidth: 10,
                paintingStyle: PaintingStyle.fill,
              ),
              size: triangleSize,
            ),
          ),
          Positioned(
            left: targetCenter.dx -
                (dialogSize.width / 2) -
                dialogParentPadding.resolve(TextDirection.ltr).left,
            top: targetCenter.dy +
                targetSize.height / 2 -
                dialogParentPadding.resolve(TextDirection.ltr).top +
                triangleSize.height,
            child: dialog,
          ),
        ],
      );
    }

    return Align(alignment: Alignment.center, child: dialog);
  }
}

class _CustomDialogRoute<T> extends GetDialogRoute<T> {
  _CustomDialogRoute({
    required super.pageBuilder,
    required super.transitionBuilder,
    super.barrierDismissible,
    super.barrierLabel,
    Color? barrierColor,
    double? filterBlur,
    Duration? transitionDuration,
    super.settings,
  })  : _barrierColor = barrierColor,
        _transitionDuration = transitionDuration ?? 275.milliseconds,
        _filterBlur = filterBlur ?? 18.0;

  @override
  Color get barrierColor => _barrierColor ?? Colors.black.withOpacity(0.01);
  final Color? _barrierColor;

  @override
  Duration get transitionDuration => _transitionDuration;
  final Duration _transitionDuration;

  @override
  ImageFilter? get filter =>
      ImageFilter.blur(sigmaX: _filterBlur, sigmaY: _filterBlur);
  final double _filterBlur;
}

class _TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  _TrianglePainter({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
