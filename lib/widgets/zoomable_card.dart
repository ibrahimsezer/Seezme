import 'package:flutter/material.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class ZoomableCard extends StatefulWidget {
  const ZoomableCard(
      {super.key,
      required this.imageString,
      required this.username,
      required this.status});
  final String imageString;
  final String username;
  final String status;
  @override
  State<ZoomableCard> createState() => _ZoomableCardState();
}

class _ZoomableCardState extends State<ZoomableCard> {
  bool _isZoomed = false;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          _isZoomed = !_isZoomed;
          setState(() {});
        },
        child: AnimatedScale(
          scale: _isZoomed ? 1.1 : 1.0,
          duration: _animationDuration,
          curve: Curves.easeInOut,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 1,
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: PaddingSize.paddingSmallSize,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.asset(
                          width: 60,
                          height: 60,
                          widget.imageString,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        overflow: TextOverflow.ellipsis,
                        widget.username,
                        style: TextStyle(
                          fontSize: FontSize.bigTitleFontSize,
                          fontFamily: defaultFontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.status,
                        style: TextStyle(
                          fontSize: FontSize.textFontSizeMedium,
                          fontFamily: defaultFontFamily,
                          fontWeight: FontWeight.bold,
                          color: widget.status == Status.statusAvailable
                              ? ConstColors.green
                              : widget.status == Status.statusBusy
                                  ? ConstColors.redImperial
                                  : widget.status == Status.statusIdle
                                      ? ConstColors.orangeWeb
                                      : ConstColors.greyColor,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
