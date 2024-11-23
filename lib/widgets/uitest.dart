import 'package:flutter/material.dart';
import 'package:seezme/core/utility/constans/constants.dart';

class Uitest extends StatefulWidget {
  const Uitest({super.key});

  @override
  State<Uitest> createState() => _UitestState();
}

class _UitestState extends State<Uitest> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ZoomableCard2(
                          imageString: Assets.profileImage,
                          username: 'Sezar',
                          status: Status.statusAvailable),
                      ZoomableCard2(
                          imageString: Assets.profileImage3,
                          username: 'Nightwish',
                          status: Status.statusBusy),
                      ZoomableCard2(
                          imageString: Assets.profileImage4,
                          username: 'ArmyManiacs',
                          status: Status.statusIdle),
                      ZoomableCard2(
                          imageString: Assets.profileImage2,
                          username: 'DjKavun',
                          status: Status.statusOffline),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ZoomableCard2(
                          imageString: Assets.profileImage5,
                          username: 'EL EX',
                          status: Status.statusAvailable),
                      ZoomableCard2(
                          imageString: Assets.profileImage6,
                          username: 'VNM',
                          status: Status.statusOffline),
                      ZoomableCard2(
                          imageString: Assets.profileImage7,
                          username: 'Azhelm',
                          status: Status.statusIdle),
                      ZoomableCard2(
                          imageString: Assets.profileImage8,
                          username: 'Asmork',
                          status: Status.statusOffline),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ZoomableCard2(
                          imageString: Assets.profileImage9,
                          username: 'Planksabiti',
                          status: Status.statusBusy),
                      ZoomableCard2(
                          imageString: Assets.profileImage10,
                          username: 'Taha',
                          status: Status.statusBusy),
                      ZoomableCard2(
                          imageString: Assets.profileImage11,
                          username: 'Ksuca',
                          status: Status.statusAvailable),
                      ZoomableCard2(
                          imageString: Assets.profileImage12,
                          username: 'Dora',
                          status: Status.statusOffline),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ZoomableCard2 extends StatefulWidget {
  const ZoomableCard2({
    super.key,
    required this.imageString,
    required this.username,
    required this.status,
  });
  final String imageString;
  final String username;
  final String status;
  @override
  State<ZoomableCard2> createState() => _ZoomableCard2State();
}

class _ZoomableCard2State extends State<ZoomableCard2> {
  bool _isZoomed = false;
  final Duration _animationDuration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 250,
      child: GestureDetector(
        onTap: () {
          _isZoomed = !_isZoomed;
          setState(() {});
        },
        child: Padding(
          padding: PaddingSize.paddingSmallSize,
          child: AnimatedScale(
            scale: _isZoomed ? 1.1 : 1.0,
            duration: _animationDuration,
            curve: Curves.easeInOut,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              elevation: 1,
              color: Colors.white,
              child: Padding(
                padding: PaddingSize.paddingSmallSize,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: PaddingSize.paddingStandartSize,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.asset(
                          width: 100,
                          height: 100,
                          widget.imageString,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                        fontSize: FontSize.textFontSize,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
