import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:islamina_app/controllers/e_tasbih_controller.dart';

class SebhaAnimation extends StatefulWidget {
  const SebhaAnimation({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SebhaAnimationState createState() => _SebhaAnimationState();
}

class _SebhaAnimationState extends State<SebhaAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Offset> beadPositions = [];
  int activeBeadIndex = 0; // Track the index of the active bead
  final controller = Get.find<ElectronicTasbihController>();
  late AudioPlayer _audioPlayer;
  double radius = 20.h; // Circle radius for beads
  int get beadCount => (2 * pi * radius / 65).floor(); // Dynamically calculate bead count

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setAsset('assets/audio/sebha_sound_2.wav');
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _initBeadPositions();
  }

  void _initBeadPositions() {
    double centerX = 100.w / 2; // Center X at half width of the Stack
    double centerY = 50.h / 2; // Center Y at half height of the Stack

    // Adjust offset for center alignment if needed
    double adjustmentX = 35; // Adjust these values if beads are offset
    double adjustmentY = 35;

    // Distribute beads in a circular formation
    for (int i = 0; i < beadCount - 1; i++) {
      double angle = 2 * pi * (i / beadCount); // Angle for each bead
      double x = centerX + radius * cos(angle) - adjustmentX;
      double y = centerY + radius * sin(angle) - adjustmentY;
      beadPositions.add(Offset(x, y));
    }
  }

  void moveBead() async {
    controller.counterIncrement(eTasbihModel: controller.eTasbihModel);
    if (_controller.isAnimating) return;

    _controller.forward().then((_) async {
      await _audioPlayer.setVolume(0.05);
      await _audioPlayer.seek(Duration.zero); // Restart the audio to the beginning
      await _audioPlayer.play();

      setState(() {
        // Move the last bead to the front
        Offset movedBead = beadPositions.removeLast();
        beadPositions.insert(0, movedBead);

        // Update the active bead index to the next bead in the list
        activeBeadIndex++;
        if (activeBeadIndex == beadCount - 1) {
          activeBeadIndex = 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double offsetX = -(context.width * 0.5); // Calculate translation offset

    return GetBuilder<ElectronicTasbihController>(
      builder: (controller) => 
     InkWell(
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        overlayColor: MaterialStatePropertyAll(Colors.transparent),
        splashColor: Colors.transparent,
        onTap: moveBead,
        child: SizedBox(
          width: 100.w,
          height: 50.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 10.5,
                right: 10.w,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: controller.beads
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: GestureDetector(
                                onTap: () => controller.changeBead(e.index),
                                child: Image.asset(
                                  e.beadPath,
                                  height: 6.h,
                                  width: 11.w,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              // Apply translation to the background image
              GestureDetector(
                onTap: moveBead,
                child: Transform(
                  transform: Matrix4.translationValues(offsetX, 0, 0),
                  child: Image.asset(
                    controller.beads[controller.beadIndex].mandalaPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      
              // Circular frame with applied translation
              Transform(
                transform: Matrix4.translationValues(offsetX, 0, 0),
                child: Container(
                  width: radius * 2 + 20,
                  height: radius * 2 + 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: controller.beads[controller.beadIndex].wireColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
      
              // Beads with applied translation to each position
              ...beadPositions.asMap().entries.map((entry) {
                Offset position = entry.value;
      
                return GetBuilder<ElectronicTasbihController>(
                  builder: (_) => AnimatedPositioned(
                    duration: _controller.duration!,
                    left: position.dx + offsetX, // Apply offsetX to each bead position
                    top: position.dy,
                    child: Bead(
                      color: Colors.blue,
                      number: activeBeadIndex == entry.key ? controller.eTasbihModel.totalCounter.value : null,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class Bead extends StatelessWidget {
  final Color color;
  final int? number;
  const Bead({super.key, required this.color, this.number});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ElectronicTasbihController>(
      builder: (controller) => Container(
        width: 85,
        height: 85,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(controller.beads[controller.beadIndex].beadPath), fit: BoxFit.cover),
          shape: BoxShape.circle,
        ),
        child: number == null
            ? null
            : Center(
                child: Text(
                  '$number',
                  style: GoogleFonts.tajawal(
                    color: controller.beads[controller.beadIndex].textColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}

class BeadModel {
  final String beadPath;
  final String mandalaPath;
  final Color wireColor;
  final Color textColor;
  final int index;

  BeadModel({required this.beadPath, required this.textColor, required this.wireColor, required this.mandalaPath , required this.index});
}
