import 'dart:async';

import 'package:advanced_flutter_firebase_authentication/core/helper/text_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import 'color_extensions.dart';

enum StatusType {
  error(
    'Error',
    Color(0xffc72c41),
    Color(0xffef5350),
  ),
  warning(
    'Warning',
    Color(0xffFCA652),
    Color(0xffffca28),
  ),
  success(
    'Success',
    Color(0xFF3E914C),
    Color(0xff9ccc65),
  ),
  help(
    'Help',
    Color(0xff3282B8),
    Color(0xff0077CC),
  );

  const StatusType(
    this._title,
    this._defaultColor,
    this._vibrantColor,
  );
  final String _title;
  final Color _defaultColor;
  final Color _vibrantColor;
}

enum SnackDesign {
  iconFocus('Icon Focus'),
  line('Line Design');

  const SnackDesign(this.name);

  final String name;
}

class _SnackTypeClass {
  final String title;
  final Color color;
  final String iconCodes;

  _SnackTypeClass({
    required this.title,
    required this.color,
    required this.iconCodes,
  });
}

extension ExtensionSnackbar on GetInterface {
  SnackbarController customSnackBar({
    required StatusType statusType,
    SnackDesign designType = SnackDesign.iconFocus,
    String? title,
    String? message,
    Duration? duration,
    SnackPosition? snackPosition,
    double? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    Color? backgroundColor,
    Border? border,
    List<BoxShadow>? boxShadow,
    double? iconSize,
    bool compact = false,
  }) {
    final snackDuration = duration ?? SNACKBAR_DURATION_MS;

    final Color snackColor = designType == SnackDesign.line
        ? statusType._vibrantColor
        : statusType._defaultColor;

    final String iconColor = snackColor.toRGBACode();

    final statusTypeClass = _SnackTypeClass(
      title: statusType._title,
      color: snackColor,
      iconCodes: statusType == StatusType.error
          ? _IconCodes.error(iconColor)
          : statusType == StatusType.warning
              ? _IconCodes.warning(iconColor)
              : statusType == StatusType.success
                  ? _IconCodes.success(iconColor)
                  : _IconCodes.help(iconColor),
    );

    Get.closeAllSnackbars();

    final snackbarController = Get.rawSnackbar(
      duration: snackDuration,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      messageText: designType == SnackDesign.line
          ? _VibrantSnackStyle(
              statusType: statusTypeClass,
              title: title,
              message: message,
              borderRadius: borderRadius,
              contentPadding: contentPadding,
              backgroundColor: backgroundColor,
              iconSize: iconSize,
              isCompact: compact,
            )
          : _DefaultSnackStyle(
              statusType: statusTypeClass,
              title: title,
              message: message,
              borderRadius: borderRadius,
              contentPadding: contentPadding,
              backgroundColor: backgroundColor,
              border: border,
              boxShadow: boxShadow,
              iconSize: iconSize,
              isCompact: compact,
            ),
      snackStyle: SnackStyle.FLOATING,
    );
    return snackbarController;
  }
}

class _DefaultSnackStyle extends StatelessWidget {
  const _DefaultSnackStyle({
    required this.statusType,
    this.title,
    this.message,
    this.borderRadius,
    this.contentPadding,
    this.backgroundColor,
    this.border,
    this.boxShadow,
    this.iconSize,
    this.isCompact = false,
  });

  final _SnackTypeClass statusType;
  final String? title;
  final String? message;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final double? iconSize;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      margin: const EdgeInsets.only(bottom: 8),
      padding: contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ??
            Color.alphaBlend(
              statusType.color.withOpacity(0.04),
              Colors.white,
            ),
        borderRadius: BorderRadius.circular(borderRadius ?? 24),
        border: border ??
            Border.all(
              width: 2.r,
              color: statusType.color.withOpacity(0.4),
            ),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: statusType.color.withOpacity(0.24),
                blurRadius: 32.r,
                spreadRadius: -4.r,
                offset: Offset(0, 8.r),
              ),
              BoxShadow(
                color: statusType.color.withOpacity(0.44),
                blurRadius: 12.r,
                spreadRadius: -2.r,
                offset: Offset(0, 4.r),
              ),
            ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(isCompact ? 8 : 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusType.color.withOpacity(0.2),
            ),
            child: SizedBox(
              height: iconSize ?? (isCompact ? 14 : 20),
              width: iconSize ?? (isCompact ? 14 : 20),
              child: SvgPicture.string(statusType.iconCodes),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? statusType.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextHelper.snackBarTitleTextStyle.copyWith(
                    color: Color.alphaBlend(
                      statusType.color.withOpacity(0.6),
                      TextHelper.buttonTextStyle.color!,
                    ),
                  ),
                ),
                if (message != null && !isCompact)
                  Flexible(
                    child: Text(
                      message!,
                      style: TextHelper.snackBarMessageTextStyle.copyWith(
                        color: Color.alphaBlend(
                          statusType.color.withOpacity(0.6),
                          TextHelper.snackBarMessageTextStyle.color!,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VibrantSnackStyle extends StatefulWidget {
  const _VibrantSnackStyle({
    required this.statusType,
    this.title,
    this.message,
    this.borderRadius,
    this.contentPadding,
    this.backgroundColor,
    this.iconSize,
    this.isCompact = false,
  });

  final _SnackTypeClass statusType;
  final String? title;
  final String? message;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;
  final double? iconSize;
  final bool isCompact;

  @override
  State<_VibrantSnackStyle> createState() => _VibrantSnackStyleState();
}

class _VibrantSnackStyleState extends State<_VibrantSnackStyle> {
  final _backgroundBoxKey = GlobalKey();
  final Completer<Size> _boxHeightCompleter = Completer<Size>();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final keyContext = _backgroundBoxKey.currentContext;
      if (keyContext != null) {
        final box = keyContext.findRenderObject() as RenderBox;
        _boxHeightCompleter.complete(box.size);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(
      horizontal: 11,
      vertical: 11,
    );

    return Container(
      key: _backgroundBoxKey,
      width: 1.sw,
      margin: const EdgeInsets.only(bottom: 8),
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white.withOpacity(0.3)),
        color: widget.backgroundColor ?? Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          FutureBuilder<Size>(
              future: _boxHeightCompleter.future,
              builder: (_, snapShot) {
                if (snapShot.hasData) {
                  final calcHeight =
                      snapShot.data!.height - padding.vertical - 8;

                  return Container(
                    width: 6.5,
                    height: calcHeight,
                    decoration: ShapeDecoration(
                      shape: const StadiumBorder(),
                      color: widget.statusType.color,
                    ),
                  );
                }
                return Container(
                  width: 6.5,
                  height: 6,
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: widget.statusType.color,
                  ),
                );
              }),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 8,
                top: 4,
                bottom: widget.isCompact ? 4 : 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title ?? widget.statusType.title,
                          maxLines: widget.isCompact ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: GoogleFonts.poppins(
                            color: widget.statusType.color,
                            fontSize: widget.isCompact ? 14.r : 18.r,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.statusType.color.withOpacity(0.2),
                        ),
                        child: SizedBox(
                          height: widget.iconSize ?? 14,
                          width: widget.iconSize ?? 14,
                          child: SvgPicture.string(widget.statusType.iconCodes),
                        ),
                      ),
                    ],
                  ),
                  if (widget.message != null && !widget.isCompact) ...[
                    const SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        widget.message!,
                        style: GoogleFonts.nunito(
                          color: TextHelper.snackBarMessageTextStyle.color,
                          fontSize: 14.r,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

abstract class _IconCodes {
  static String warning(String color) {
    return '''
      <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path fill-rule="evenodd" clip-rule="evenodd" d="M12.8696 18.5652C12.8696 20.222 14.2128 21.5652 15.8696 21.5652H16.1305C17.7874 21.5652 19.1305 20.222 19.1305 18.5652L19.1305 5.08691C19.1305 3.43006 17.7874 2.08691 16.1305 2.08691H15.8696C14.2128 2.08691 12.8696 3.43006 12.8696 5.08691V18.5652ZM16.0001 29.913C17.729 29.913 19.1305 28.5115 19.1305 26.7826C19.1305 25.0537 17.729 23.6521 16.0001 23.6521C14.2712 23.6521 12.8696 25.0537 12.8696 26.7826C12.8696 28.5115 14.2712 29.913 16.0001 29.913Z" fill="$color"/>
    </svg>
    ''';
  }

  static String help(String color) {
    return '''
    <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
      <ellipse cx="15.8215" cy="28.8696" rx="2.43478" ry="2.43478" fill="$color"/>
      <path d="M20.6304 2.43161C18.8412 1.54923 16.8304 1.21726 14.8525 1.47766C12.8745 1.73806 11.0182 2.57914 9.51829 3.89455C8.54448 4.74856 7.74928 5.7776 7.16993 6.92178C6.64927 7.95007 7.32836 9.10945 8.44168 9.40777L9.11362 9.58782C10.2269 9.88613 11.3448 9.18129 12.0532 8.27202C12.2544 8.01367 12.4805 7.77365 12.729 7.55568C13.5048 6.8753 14.465 6.44026 15.4881 6.30557C16.5111 6.17088 17.5512 6.34259 18.4767 6.79899C19.4022 7.25538 20.1715 7.97597 20.6875 8.86963C21.2034 9.76328 21.4428 10.7899 21.3753 11.8196C21.3078 12.8492 20.9365 13.8358 20.3083 14.6545C19.6801 15.4731 18.8233 16.0871 17.8462 16.4188C17.0433 16.6957 16.8273 16.6957 15.9998 16.6957L15.3042 16.6957C14.1516 16.6957 13.2172 17.6301 13.2172 18.7827V22.2609C13.2172 23.4135 14.1516 24.3479 15.3042 24.3479H15.9999C17.1524 24.3479 18.0868 23.4135 18.0868 22.2609C18.0868 21.7503 18.4568 21.3184 18.9473 21.1763C19.0974 21.1329 19.2518 21.0841 19.4114 21.03C21.3006 20.3887 22.9571 19.2016 24.1716 17.6189C25.3861 16.0361 26.104 14.1288 26.2344 12.138C26.3649 10.1473 25.9021 8.16257 24.9046 6.43484C23.9071 4.70711 22.4197 3.31398 20.6304 2.43161Z" fill="$color"/>
    </svg>
    ''';
  }

  static String error(String color) => '''
    <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M25.8137 9.6379C26.6421 8.8095 26.6421 7.46638 25.8137 6.63797L25.3622 6.18649C24.5338 5.35808 23.1907 5.35808 22.3623 6.18649L16.0002 12.5486L9.63815 6.18649C8.80974 5.35809 7.46662 5.35808 6.63822 6.18649L6.18673 6.63797C5.35833 7.46638 5.35833 8.80949 6.18674 9.6379L12.5488 16L6.18674 22.362C5.35833 23.1904 5.35833 24.5336 6.18674 25.362L6.63822 25.8134C7.46662 26.6419 8.80974 26.6419 9.63814 25.8134L16.0002 19.4514L22.3623 25.8134C23.1907 26.6418 24.5338 26.6419 25.3622 25.8134L25.8137 25.362C26.6421 24.5336 26.6421 23.1904 25.8137 22.362L19.4516 16L25.8137 9.6379Z" fill="$color"/>
    </svg>
    ''';

  static String success(String color) => '''
    <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path fill-rule="evenodd" clip-rule="evenodd" d="M27.3012 6.34639C28.3603 7.15845 28.5625 8.6745 27.7531 9.7357L15.7428 25.4829C15.3193 26.0382 14.6774 26.3832 13.9817 26.4295C13.2861 26.4758 12.6044 26.2189 12.1114 25.7246L4.48838 18.0815C3.54564 17.1363 3.54564 15.6064 4.48838 14.6612C5.43464 13.7124 6.97147 13.7124 7.91773 14.6612L13.5784 20.3368L23.9033 6.79944C24.7155 5.73443 26.2382 5.5314 27.3012 6.34639Z" fill="$color"/>
    </svg>
    ''';
}
