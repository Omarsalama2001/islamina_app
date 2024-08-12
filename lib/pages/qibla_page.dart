import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:islamina_app/pages/qibla_camera.dart';
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
        title: const Text('القبلة'), // App bar title
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
                tabs: const [
                  Tab(
                    text: 'البوصلة',
                  ),
                  Tab(
                    text: 'الواقع المعزز',
                  ),
                ],
              ),
            ),
          ),
          // Expanded(
          //   child: TabBarView(
          //     controller: controller.tabController,
          //     children: [
          //       const _QiblaCompress(),
          //       // QiblaCamera(cameras: Get.arguments),
          //       Container(color: Colors.red),
          //     ],
          //   ),
          // ),
          Expanded(
            child: GetBuilder<QiblaController>(
              init: QiblaController(),
              builder: (context) {
                return IndexedStack(
                  index: controller.tabController.index,
                  children: [
                    // const _QiblaCompress(),
                    const QiblaView(),
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

  // Widget for requesting location permissions
}

class QiblaView extends StatelessWidget {
  const QiblaView({super.key});

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
                      child: const CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    );
                  }

                  final qiblahDirection = snapshot.data;
                  controller.animations = Tween(
                    begin: controller.begin,
                    end: (qiblahDirection!.qiblah * (pi / 180) * -1),
                  ).animate(controller.animationsController!);
                  controller.begin = (qiblahDirection.qiblah * (pi / 180) * -1);
                  controller.animationsController!.forward(from: 0);

                  return Center(
                    child: SizedBox(
                      child: AnimatedBuilder(
                        animation: controller.animations!,
                        builder: (context, child) => Transform.rotate(
                          angle: controller.animations!.value,
                          // child: Image.asset(
                          //   'images/qibla_image.png',
                          // ),
                          child: SvgPicture.asset(
                            'assets/svg/qibla.svg',
                            // ignore: deprecated_member_use
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Center(
                  //   child: MessageWithButtonWidget(
                  //     title:
                  //         'الرجاء السماح بصلاحيات الموقع مرة واحدة على الاقل',
                  //     buttonText: 'إعطاء صلاحية',
                  //     onTap: () async {
                  //       await controller.getPermission();
                  //       controller.update();
                  //     },
                  //   ),
                  // ),
                  Center(
                    child: MessageWithButtonWidget(
                      title:
                          'الرجاء السماح بصلاحيات الموقع للحصول على اتجاه القبلة',
                      buttonText: 'إعطاء صلاحية',
                      onTap: controller.checkLocationStatus,
                    ),
                  ),
                ],
              );
      },
    );
  }
}

class _QiblaCompress extends GetView<QiblaController> {
  const _QiblaCompress();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.stream,
      builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CustomCircularProgressIndicator();
        }

        if (snapshot.data?.enabled == true) {
          switch (snapshot.data?.status) {
            case LocationPermission.always:
            case LocationPermission.whileInUse:
              var qiblahTurns = 0.0;
              var preValue = 0.0;
              var direction = 0.0;

              return StreamBuilder<QiblahDirection>(
                stream: FlutterQiblah.qiblahStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CustomCircularProgressIndicator();
                  } else if (!snapshot.hasData || snapshot.hasError) {
                    return const Center(
                      child: LoadingErrorText(),
                    );
                  } else {
                    // Adjust direction value
                    direction = direction < 0
                        ? (360 + direction)
                        : snapshot.data?.qiblah ?? 0;

                    // Calculate difference and adjust if needed
                    double diff = direction - preValue;
                    if (diff.abs() > 180) {
                      if (preValue > direction) {
                        diff = 360 - (direction - preValue).abs();
                      } else {
                        diff = (360 - (preValue - direction).abs()).toDouble();
                        diff = diff * -1;
                      }
                    }

                    // Calculate turns
                    final kabba = ((snapshot.data?.offset ?? 0) -
                            (snapshot.data?.direction ?? 0))
                        .toInt();
                    qiblahTurns += (diff / 360);
                    preValue = snapshot.data?.qiblah ?? 0;

                    // Build UI
                    return OrientationBuilder(builder: (context, orientation) {
                      if (orientation == Orientation.portrait) {
                        return Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Text('الكعبة',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                    Text(
                                      '$kabba°',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                                Transform.flip(
                                  flipX: true,
                                  child: AnimatedRotation(
                                    duration: const Duration(milliseconds: 400),
                                    turns: qiblahTurns,
                                    child: SvgPicture.asset(
                                      'assets/svg/qibla.svg',
                                      // ignore: deprecated_member_use
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/kaaba.png',
                                          width: 40,
                                        ),
                                        const Gap(5),
                                        Text(
                                          '${controller.distanceToKaaba.toStringAsFixed(1)} كم',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Transform.flip(
                              flipX: true,
                              child: AnimatedRotation(
                                duration: const Duration(milliseconds: 400),
                                turns: qiblahTurns,
                                child: SvgPicture.asset(
                                  'assets/svg/qibla.svg',
                                  // ignore: deprecated_member_use
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text('الكعبة',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                    Text(
                                      '$kabba°',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/kaaba.png',
                                      width: 40,
                                    ),
                                    const Gap(5),
                                    Text(
                                      '${controller.distanceToKaaba.toStringAsFixed(1)} كم',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    });
                  }
                },
              );

            case LocationPermission.denied:
            case LocationPermission.deniedForever:
              // Display widget for denied location permissions
              return MessageWithButtonWidget(
                  title:
                      'الرجاء السماح بصلاحيات الموقع للحصول على اتجاه القبلة',
                  buttonText: 'إعطاء صلاحية',
                  onTap: controller.checkLocationStatus);

            default:
              return const Center(child: LoadingErrorText());
          }
        } else {
          // Display widget when location settings are disabled
          return MessageWithButtonWidget(
              title: "تم إيقاف إعدادات الموقع. يرجى تمكينها للمتابعة",
              buttonText: "تفعيل إعدادات الموقع",
              onTap: controller.checkLocationStatus);
        }
      },
    );
  }
}
