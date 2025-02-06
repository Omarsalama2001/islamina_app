import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/main.dart';
import 'package:islamina_app/pages/qibla_camera.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:smooth_compass/utils/src/compass_ui.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/custom_progress_indicator.dart';
import '../controllers/qibla_page_controller.dart';
import '../widgets/custom_message_button_widget.dart';
import '../widgets/loading_error_text.dart';

class QiblaPage extends GetView<QiblaController> {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(context.translate('qibla')), // App bar title
        titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
        actions: const [
          IconButton(
            onPressed: showQiblaCompassCalibrationDialog,
            icon: Icon(FluentIcons.info_12_regular),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              top: 8,
              start: 32,
              end: 32,
              bottom: 8,
            ),
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: TabBar(
                controller: controller.tabController,
                indicatorColor: context.theme.primaryColor,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: context.theme.primaryColor,
                labelColor: context.theme.primaryColor,
                dividerColor: context.theme.primaryColor.withOpacity(0.5),
                // dividerHeight: 0.5,
                indicatorWeight: 2.5,
                unselectedLabelStyle: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                labelStyle: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                onTap: (value) {
                  // controller.animateTo(value);
                  controller.tabController.index = value;
                  controller.update();
                },
                tabs:  [
                  Tab(
                    text: context.translate('qiblaCompass'),
                  ),
                  Tab(
                    text:context.translate('qiblaVr'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<QiblaController>(
              init: QiblaController(),
              builder: (context) {
                return IndexedStack(
                  index: controller.tabController.index,
                  children: [
                    const QiblaWidget(),
                    QiblaCamera(cameras: controller.cameras),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QiblaWidget extends StatefulWidget {
  const QiblaWidget({super.key});

  @override
  State<QiblaWidget> createState() => _QiblaWidgetState();
}

class _QiblaWidgetState extends State<QiblaWidget> {
  double? _x, _y, _z;
  bool _isDeviceHorizontal = false;
  final double _threshold = 3.5; // عتبة للتسارع (يمكن تعديلها)

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;

        setState(() {
          _isDeviceHorizontal = _x!.abs() < _threshold && _y!.abs() < _threshold;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QiblaController>(
        init: QiblaController(),
        builder: (controller) {
          return controller.hasPermission
              ? StreamBuilder(
                  stream: FlutterQiblah.qiblahStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (snapshot.hasData) {
                      final qiblahDirection = snapshot.data;
                      var diffAngle = (qiblahDirection!.direction - qiblahDirection.offset);

                      return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 15.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Card.outlined(
                                  color: Colors.white,
                                  elevation: 5,
                                  child: Padding(
                                    padding:  EdgeInsets.all(15.0.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [Text("${controller.distanceToKaaba.toInt()} ${ context.translate('km')}"), Gap(5), Image.asset('assets/images/ka3ba_activited.png', height: 5.h, width: 5.w)],
                                        ),
                                        Text(
                                          context.translate('distance_from_kaaba'),
                                          style: GoogleFonts.readexPro(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Card.outlined(
                                  color: Colors.white,
                                  elevation: 5,
                                  child: Padding(
                                    padding:  EdgeInsets.all(15.0.sp),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [Text('${qiblahDirection.offset.toInt()}'), Gap(5), Image.asset('assets/images/direction.png', height: 5.h, width: 5.w)],
                                        ),
                                        Text(
                                         context.translate('qibladirectionfrom'),
                                          style: GoogleFonts.readexPro(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset((diffAngle.toInt() <= 10 && diffAngle.toInt() >= -10) ? 'assets/images/ka3ba_activited.png' : 'assets/images/ka3ba_not_activited.png', height: 8.h, width: 15.w),
                        SizedBox(
                          height: 250,
                          width: 250,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Transform.rotate(
                                  angle: (qiblahDirection.direction * (pi / 180) * -1),
                                  child: Image.asset(
                                    'assets/images/compass_new.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 3,
                                child: Transform.rotate(
                                    angle: (qiblahDirection.qiblah * (pi / 180) * -1),
                                    child: Image.asset(
                                      'assets/images/needle_2.png',
                                      height: 20.h,
                                      width: 20.w,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        const Gap(4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                           context.translate(   qiblaStatusMessage(
                                _isDeviceHorizontal,
                                (qiblahDirection.direction - qiblahDirection.offset),
                              )['text']),
                              style: GoogleFonts.readexPro().copyWith(fontSize: 15.sp),
                            ),
                            const Gap(10),
                            Image.asset(qiblaStatusMessage(_isDeviceHorizontal, diffAngle)['icon'], height: 8.h, width: 8.w),
                          ],
                        )
                      ]);
                    } else {
                      return Text("Not supported");
                    }
                  })
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: MessageWithButtonWidget(
                        title: 'الرجاء السماح بصلاحيات الموقع للحصول على اتجاه القبلة',
                        buttonText: 'إعطاء صلاحية',
                        onTap: controller.checkLocationStatus,
                      ),
                    ),
                  ],
                );
        });
  }
}

qiblaStatusMessage(bool isDeviceHorizontal, var diffAngle) {
  if (!isDeviceHorizontal) {
    return {'text': "Pleaseplacethephonehorizontally", 'icon': 'assets/images/smartphone.png'};
  } else {
    if (diffAngle <= 10 && diffAngle >= -10) {
      return {'text': 'ThedeviceindicatesthedirectionoftheQibla', 'icon': 'assets/images/ka3ba_activited.png'};
    } else {
      if (diffAngle < 0) {
        return {'text': '${Get.context!.translate('move_phone')} ${diffAngle.abs().toInt()} ${Get.context!.translate('degrees_to_right')}', 'icon': 'assets/images/rotate_phone.png'};
      } else {
        return {'text': '${Get.context!.translate('move_phone')} ${diffAngle.abs().toInt()} ${Get.context!.translate('degrees_to_left')}', 'icon': 'assets/images/rotate_phone.png'};
      }
    }
  }
}


// class QiblaTest extends StatelessWidget {
//   const QiblaTest({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<QiblaController>(
//         init: QiblaController(),
//         builder: (controller) {
//           return controller.hasPermission ?
//           Center(
//             child: SmoothCompass(
//               isQiblahCompass: true,
//               compassBuilder: (context, compassData, compassAsset) {
//                 return AnimatedRotation(
//                   turns: (compassData?.data?.turns ?? 0),
//                   duration: Duration(milliseconds: 400),
//                   child: SizedBox(
//                     height: 200,
//                     width: 200,
//                     child: Stack(children: [
//                       Positioned(
//                           top: 0,
//                           left: 0,
//                           right: 0,
//                           child: Image.asset(
//                             'assets/images/compass_new.png',
//                             fit: BoxFit.fill,
//                           )),
//                       Positioned(
//                           top: 0,
//                           left: 0,
//                           right: 0,
//                           bottom: 20,
//                           child: AnimatedRotation(
//                               turns: (compassData?.data?.qiblahOffset) ?? 0 / 360,
//                               duration: Duration(milliseconds: 400),
//                               child: SvgPicture.asset(
//                                 'assets/images/needle.svg',
//                                 fit: BoxFit.fitHeight,
//                               )))
//                     ]),
//                   ),
//                 );
//               },
//             ),
//           ) : Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Center(
//                       child: MessageWithButtonWidget(
//                         title: 'الرجاء السماح بصلاحيات الموقع للحصول على اتجاه القبلة',
//                         buttonText: 'إعطاء صلاحية',
//                         onTap: controller.checkLocationStatus,
//                       ),
//                     ),
//                   ],
//                 );
//         });
//   }
// }
