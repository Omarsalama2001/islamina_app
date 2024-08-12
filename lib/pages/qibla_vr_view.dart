import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_compass/utils/src/compass_ui.dart';
import 'package:smooth_compass/utils/src/widgets/error_widget.dart';
import 'package:vibration/vibration.dart';

int globalCambossIndex = -1;

class QiblaVrPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  // final VoidCallback onQiblaCameraExit;
  const QiblaVrPage({
    super.key,
    required this.cameras,
    // required this.onQiblaCameraExit,
  });

  @override
  State<QiblaVrPage> createState() => _QiblaVrPageState();
}

class _QiblaVrPageState extends State<QiblaVrPage> {
  double begin = 0.0;
  bool showRow = false;
  double end = 0.0;
  double qiblahPercentage = 0;
  @override
  void initState() {
    initCamera();
    super.initState();
  }

  late CameraController _cameraController;
  @override
  void dispose() {
    _cameraController.dispose();
    // widget.onQiblaCameraExit();
    super.dispose();
  }

  Future initCamera() async {
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SmoothCompass(
        isQiblahCompass: false,
        loadingAnimation: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
        errorDecoration: ErrorDecoration(
            spaceBetween: 20,
            permissionMessage: PermissionMessage(
              denied: "location permission is denied",
              permanentlyDenied: "location permission is permanently denied",
            ),
            buttonStyle: ErrorButtonStyle(
                borderRadius: BorderRadius.circular(10),
                buttonColor: Colors.red,
                textColor: Colors.white,
                buttonHeight: 40,
                buttonWidth: 150),
            messageTextStyle: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
        height: 100,
        width: 100,
        compassBuilder: (context, snapshot, child) {
          // bool isSuccessQibla =
          //     snapshot!.data!.angle < snapshot.data!.qiblahOffset + 5 &&
          //         snapshot.data!.angle > snapshot.data!.qiblahOffset - 5;

          bool isSuccessQibla =
              snapshot!.data!.angle < snapshot.data!.qiblahOffset + 3 &&
                  snapshot.data!.angle > snapshot.data!.qiblahOffset - 3;
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          qiblahPercentage =
              ((snapshot.data!.angle % 180) / 180).clamp(0.0, 1.0);

          return Stack(
            children: [
              if (_cameraController.value.isInitialized) ...[
                Center(
                  child: SizedBox(
                    width: screenWidth,
                    height: screenHeight,
                    child: CameraPreview(_cameraController),
                  ),
                ),
              ],
              Align(
                alignment: Alignment.center,
                child: Container(
                  // padding: EdgeInsets.all(16.w),
                  padding: EdgeInsets.all(8.w),
                  width: double.infinity,
                  // height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0),
                  ),
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: EdgeInsetsDirectional.only(top: 30.h),
                      //   child: Image.asset(
                      //     'assets/images/app_logo.png',
                      //     height: Get.height / 8,
                      //   ),
                      // ),
                      const Spacer(),
                      // if (snapshot.data!.angle > 90 && qiblahPercentage <= 0.89)
                      //   arrownavRightmethod(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          snapshot.data!.angle > 90 && qiblahPercentage >= 0.89
                              ? isSuccessQibla
                                  ? const Icon(
                                      Icons.home,
                                      size: 80,
                                      color: Colors.transparent,
                                    )
                                  : arrownavRightmethod()
                              : const Icon(
                                  Icons.home,
                                  size: 80,
                                  color: Colors.transparent,
                                ),
                          Expanded(
                            child: Column(
                              children: [
                                isSuccessQibla
                                    ? _buildCompassIcon()
                                    : const SizedBox.shrink(),
                                if (isSuccessQibla) const Gap(20),
                                Text(
                                  "درجة القبلة ${snapshot.data!.qiblahOffset.toStringAsFixed(1)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "إتجاهك ${snapshot.data!.angle.toStringAsFixed(1)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          snapshot.data!.angle < 90 && qiblahPercentage <= 0.89
                              ? isSuccessQibla
                                  ? const Icon(
                                      Icons.home,
                                      size: 80,
                                      color: Colors.transparent,
                                    )
                                  : arrownavrLeftmethod()
                              : const Icon(
                                  Icons.home,
                                  size: 80,
                                  color: Colors.transparent,
                                ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildCircleAvatar(
                            imageUrl: 'assets/images/pngwing.com (16).png',
                            index: 0,
                            color: null,
                            iconData: null,
                          ),
                          buildCircleAvatar(
                            imageUrl: 'assets/images/pngwing.com.png',
                            index: 1,
                            color: null,
                            iconData: null,
                          ),
                          buildCircleAvatar(
                            imageUrl: 'assets/images/pngwing.com (19).png',
                            index: 2,
                            color: null,
                            iconData: null,
                          ),
                          buildCircleAvatar(
                            imageUrl: 'assets/images/sajdah.png',
                            index: 3,
                            color: null,
                            iconData: null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  arrownavRightmethod() {
    return const Icon(
      Icons.arrow_back_ios,
      color: Colors.white,
      size: 80.0,
    );
  }

  arrownavrLeftmethod() {
    return const Icon(
      Icons.arrow_forward_ios,
      color: Colors.white,
      size: 80.0,
    );
  }

  Widget _buildCompassIcon() {
    Vibration.vibrate(duration: 200);
    switch (globalCambossIndex) {
      case 0:
        return const ImageBuilder(
          // height: 230,
          // width: 300,
          height: 200,
          width: 200,
          boxFit: BoxFit.fill,
          borderRadius: null,
          imageUrl: 'assets/images/pngwing.com (16).png',
        );
      case 1:
        return const ImageBuilder(
          // height: 260,
          // width: 400,
          height: 200,
          width: 200,
          boxFit: BoxFit.fill,
          borderRadius: null,
          imageUrl: 'assets/images/pngwing.com.png',
        );
      case 2:
        return const ImageBuilder(
          // height: 260,
          // width: 200,
          height: 200,
          width: 200,
          boxFit: BoxFit.fill,
          borderRadius: null,
          imageUrl: 'assets/images/pngwing.com (19).png',
        );
      case 3:
        return const ImageBuilder(
          // height: 230,
          // width: 300,
          height: 200,
          width: 200,
          boxFit: BoxFit.fill,
          borderRadius: null,
          imageUrl: 'assets/images/sajdah.png',
        );
      default:
        return const ImageBuilder(
          // height: 300,
          // width: 300,
          height: 200,
          width: 200,
          boxFit: BoxFit.fill,
          borderRadius: null,
          imageUrl: 'assets/images/pngwing.com (16).png',
        );
    }
  }

  Widget buildCircleAvatar({
    String? imageUrl,
    required int index,
    Color? color,
    IconData? iconData,
  }) {
    // bool isPressed = globalCambossIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          globalCambossIndex = index;
        });
      },
      child: imageUrl != null
          ? ImageBuilder(
              height: 60,
              width: 60,
              boxFit: BoxFit.cover,
              borderRadius: null,
              imageUrl: imageUrl,
            )
          : Icon(
              iconData,
              size: 25,
              color: color,
            ),
    );
    // return SizedBox(
    //   height: 100,
    //   width: 80,
    //   child: InkWell(
    //     onTap: () {
    //       setState(() {
    //         globalCambossIndex = index;
    //       });
    //     },
    //     child: Container(
    //       decoration: const BoxDecoration(
    //         // borderRadius: BorderRadius.circular(25),
    //         shape: BoxShape.circle,
    //         // border: Border.all(
    //         // color: isPressed ? AppColors.primary : Colors.black,
    //         // width: isPressed ? 2 : 0,
    //         // ),
    //       ),
    //       child: CircleAvatar(
    //         backgroundColor:
    //             isPressed ? context.theme.primaryColor : Colors.transparent,
    //         child: imageUrl != null
    //             ? ImageBuilder(
    //                 height: 60,
    //                 width: 60,
    //                 boxFit: BoxFit.cover,
    //                 borderRadius: null,
    //                 imageUrl: imageUrl,
    //               )
    //             : Icon(
    //                 iconData,
    //                 size: 25,
    //                 color: color,
    //               ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class ImageBuilder extends StatefulWidget {
  const ImageBuilder(
      {super.key,
      required this.height,
      this.shape,
      required this.width,
      required this.boxFit,
      this.color,
      required this.borderRadius,
      required this.imageUrl});
  final double height;
  final double width;
  final String imageUrl;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? boxFit;
  final BoxShape? shape;
  final Color? color;

  @override
  State<ImageBuilder> createState() => _ImageBuilderState();
}

class _ImageBuilderState extends State<ImageBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: widget.height, maxWidth: widget.width),
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.color,
        shape: widget.shape ?? BoxShape.rectangle,
        borderRadius: widget.borderRadius,
      ),
      child: widget.imageUrl.contains("http")
          ? Image.network(
              widget.imageUrl,
              fit: widget.boxFit ?? BoxFit.none,
            )
          : Image.asset(
              widget.imageUrl,
              fit: widget.boxFit ?? BoxFit.none,
            ),
    );
  }
}
