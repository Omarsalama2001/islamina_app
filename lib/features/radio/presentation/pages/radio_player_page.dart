import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/core/network/connection/bloc/connection_bloc.dart';
import 'package:islamina_app/core/widgets/snack_bar.dart';
import 'package:islamina_app/features/radio/domain/entities/radio_entity.dart';
import 'package:islamina_app/features/radio/presentation/blocs/cubit/raido_cubit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RadioPlayerPage extends StatelessWidget {
  final RadioEntity radioEntity;
  const RadioPlayerPage({
    super.key,
    required this.radioEntity,
  });

  @override
  Widget build(BuildContext context) {
    final radioCubit = context.read<RaidoCubit>();
    return BlocListener<ConnectionBloc, ConnectionStates>(
      listener: (context, state) {
        if (state is ConnectedState) {
          SnackBarMessage.showSnackBar(SnackBarTypes.SUCCESS, context.translate('InternetMessage'), context);
        }
        if (state is NotConnectedState) {
          SnackBarMessage.showSnackBar(SnackBarTypes.ERORR, context.translate('noInternetMessage'), context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(radioEntity.title),
          titleTextStyle: Get.theme.primaryTextTheme.titleMedium,
        ),
        body: BlocConsumer<RaidoCubit, RaidoState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none, // Allow positioning outside the Stack
                  children: [
                    ClipPath(
                      clipper: HalfCircleClipper(),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Get.theme.primaryColorLight,
                          BlendMode.multiply,
                        ),
                        child: Image.asset(
                          'assets/images/mosque.jpg',
                          height: Get.height * 0.4,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -(Get.height * 0.05), // Half of the flag height to overlap
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: Get.width * 0.39, // Responsive width for the flag
                            height: Get.width * 0.39, // Make it circular
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.35, // Responsive width for the flag
                            height: Get.width * 0.35, // Make it circular
                            child: Container(
                              width: Get.width * 0.35, // Responsive width for the flag
                              height: Get.width * 0.35, // Make it circular
                              decoration: BoxDecoration(
                                image: DecorationImage(image: CachedNetworkImageProvider("https://dubaiholyquran.ae/new/wp-content/uploads/2023/03/Dubai-Holy-Quran-FM-Logo-Jpeg-1-320x235.jpg"
                                ,errorListener: (p0) {
                                },
                                ), fit: BoxFit.fill),
                                shape: BoxShape.circle,
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black26,
                                //     blurRadius: 5,
                                //     spreadRadius: 2,
                                //     offset: Offset(0, 2),
                                //   ),
                                // ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: Get.height * 0.15,
                      child: Text(
                        radioCubit.radios[radioCubit.selectedRadioIndex].title,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(100),
                Container(
                  width: Get.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 0.3, blurRadius: 3)],
                  ),
                  child: BlocBuilder<RaidoCubit, RaidoState>(
                    builder: (context, state) {
                      return Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        IconButton(
                            onPressed: () {
                              radioCubit.getNextRadio();
                            },
                            icon: Icon(
                              Icons.skip_next_rounded,
                              size: 30.sp,
                              color: Get.theme.primaryColorLight,
                            )),
                        Gap(20),
                        IconButton(
                            onPressed: () {
                              radioCubit.isPlaying ? radioCubit.player.pause() : radioCubit.player.play();
                            },
                            icon: Icon(
                              radioCubit.isPlaying ? Icons.pause_outlined : Icons.play_arrow_outlined,
                              size: 30.sp,
                              color: Get.theme.primaryColorLight,
                            )),
                        Gap(20),
                        IconButton(
                            onPressed: () {
                              radioCubit.getPreviousRadio();
                            },
                            icon: Icon(
                              Icons.skip_previous_rounded,
                              size: 30.sp,
                              color: Get.theme.primaryColorLight,
                            )),
                      ]);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50); // Start from bottom-left, 50px up
    path.quadraticBezierTo(
      size.width / 2, // Control point horizontally centered
      size.height + 50, // Control point 50px below the height
      size.width, // End point at the bottom-right corner
      size.height - 50, // 50px up from the bottom
    );
    path.lineTo(size.width, 0); // Top-right corner
    path.close(); // Connect back to top-left
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
