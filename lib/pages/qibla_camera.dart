import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:islamina_app/widgets/custom_progress_indicator.dart';
import 'package:islamina_app/widgets/loading_error_text.dart';
import 'package:smooth_compass/utils/src/compass_ui.dart';
import 'package:smooth_compass/utils/src/widgets/error_widget.dart';

int globalCambossIndex = -1;

class QiblaCamera extends StatefulWidget {
  final List<CameraDescription> cameras;
  // final VoidCallback onQiblaCameraExit;
  const QiblaCamera({
    super.key,
    required this.cameras,
    // required this.onQiblaCameraExit,
  });

  @override
  State<QiblaCamera> createState() => _QiblaCameraState();
}

class _QiblaCameraState extends State<QiblaCamera>
    with SingleTickerProviderStateMixin {
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
    // _cameraController =
    //     CameraController(cameraDescription, ResolutionPreset.high);
    // try {
    //   await _cameraController.initialize().then((_) {
    //     if (!mounted) return;
    //     setState(() {});
    //   });
    // } on CameraException catch (e) {
    //   debugPrint("Camera error: $e");
    // }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    // return const Scaffold(
    //   backgroundColor: Colors.black,
    //   body: SmoothCompass(
    //     isQiblahCompass: false,
    //   ),
    // );
    return SmoothCompass(
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

        // bool isSuccessQibla =
        //     snapshot!.data!.angle < snapshot.data!.qiblahOffset + 7 &&
        //         snapshot.data!.angle > snapshot.data!.qiblahOffset - 7;

        // bool isSuccessQibla =
        //     snapshot!.data!.angle > snapshot.data!.qiblahOffset + 3 &&
        //         snapshot.data!.angle < snapshot.data!.qiblahOffset - 3;
        if (!snapshot!.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        qiblahPercentage = ((snapshot.data!.angle % 180) / 180).clamp(0.0, 1.0);

        return StreamBuilder<QiblahDirection>(
            stream: FlutterQiblah.qiblahStream,
            builder: (context, snapshotData) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CustomCircularProgressIndicator();
              } else if (!snapshot.hasData || snapshot.hasError) {
                return const Center(child: LoadingErrorText());
              }
              int kabba = ((snapshotData.data?.offset ?? 0) -
                      (snapshotData.data?.direction ?? 0))
                  .toInt();
              bool isSuccessQibla = kabba == 0 ||
                  kabba == 1 ||
                  kabba == 2 ||
                  kabba == -1 ||
                  kabba == -2;
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
                      padding: const EdgeInsetsDirectional.only(
                        bottom: 16,
                        start: 8,
                        end: 8,
                      ),
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
                              // snapshot.data!.angle > 90 &&
                              //         qiblahPercentage >= 0.89
                              //     ? isSuccessQibla
                              //         ? const Icon(
                              //             Icons.home,
                              //             size: 80,
                              //             color: Colors.transparent,
                              //           )
                              //         : arrownavRightmethod()
                              //     : const Icon(
                              //         Icons.home,
                              //         size: 80,
                              //         color: Colors.transparent,
                              //       ),
                              Expanded(
                                child: Column(
                                  children: [
                                    isSuccessQibla
                                        ? _buildCompassIcon()
                                        : const SizedBox.shrink(),
                                    Text(
                                      // "درجة القبلة ${snapshot.data!.qiblahOffset.toStringAsFixed(1)}",
                                      "درجة القبلة $kabba",
                                      style: context.textTheme.titleLarge!
                                          .copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    // Text(
                                    //   "إتجاهك ${snapshot.data!.angle.toStringAsFixed(1)}",
                                    //   style: context.textTheme.titleLarge!
                                    //       .copyWith(
                                    //     color: Colors.white,
                                    //   ),
                                    // ),
                                    // isSuccessQibla
                                    //     // ? CircleAvatar(
                                    //     //     radius: 40.r,
                                    //     //     backgroundColor: Colors.green,
                                    //     //     child: const Icon(Icons.check_circle),
                                    //     //   )
                                    //     ? const Icon(
                                    //         Icons.check_circle,
                                    //         color: AppColors.primary,
                                    //         size: 60,
                                    //       )
                                    //     : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              // snapshot.data!.angle < 90 &&
                              //         qiblahPercentage <= 0.89
                              //     ? isSuccessQibla
                              //         ? const Icon(
                              //             Icons.home,
                              //             size: 80,
                              //             color: Colors.transparent,
                              //           )
                              //         : arrownavrLeftmethod()
                              //     : const Icon(
                              //         Icons.home,
                              //         size: 80,
                              //         color: Colors.transparent,
                              //       ),
                            ],
                          ),
                          const Spacer(),
                          FittedBox(
                            child: Text(
                              // "درجة القبلة ${snapshot.data!.qiblahOffset.toStringAsFixed(1)}",
                              "يجب التحريك حتى تصبح درجة القبلة ( 0 )",
                              style: context.textTheme.titleLarge!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Gap(25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildCircleAvatar(
                                imageUrl: 'assets/images/pngwing.com (16).png',
                                index: 0,
                                color: null,
                                iconData: null,
                              ),
                              const Gap(10),
                              buildCircleAvatar(
                                imageUrl: 'assets/images/pngwing.com.png',
                                index: 1,
                                color: null,
                                iconData: null,
                              ),
                              const Gap(10),
                              buildCircleAvatar(
                                imageUrl: 'assets/images/pngwing.com (19).png',
                                index: 2,
                                color: null,
                                iconData: null,
                              ),
                              const Gap(10),
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
            });
      },
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
    // Vibration.vibrate(duration: 200);
    switch (globalCambossIndex) {
      case 0:
        return const ImageBuilder(
          height: 230,
          width: 300,
          boxFit: BoxFit.fill,
          borderRadius: null,
          imageUrl: 'assets/images/pngwing.com (16).png',
        );
      case 1:
        return const ImageBuilder(
          height: 260,
          width: 400,
          boxFit: BoxFit.fill,
          borderRadius: null,
          imageUrl: 'assets/images/pngwing.com.png',
        );
      case 2:
        return const ImageBuilder(
          height: 260,
          width: 200,
          boxFit: BoxFit.fill,
          borderRadius: null,
          imageUrl: 'assets/images/pngwing.com (19).png',
        );
      case 3:
        return const ImageBuilder(
          height: 230,
          width: 300,
          boxFit: BoxFit.fill,
          borderRadius: null,
          imageUrl: 'assets/images/sajdah.png',
        );
      default:
        return const ImageBuilder(
          height: 300,
          width: 300,
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

    return SizedBox(
      height: 100,
      width: 60,
      child: InkWell(
        onTap: () {
          setState(() {
            globalCambossIndex = index;
          });
        },
        child: Container(
          decoration: const BoxDecoration(
            // borderRadius: BorderRadius.circular(25),
            shape: BoxShape.circle,
            // border: Border.all(
            // color: isPressed ? AppColors.primary : Colors.black,
            // width: isPressed ? 2 : 0,
            // ),
          ),
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
        ),
      ),
    );
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
