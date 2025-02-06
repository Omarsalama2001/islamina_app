import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flip_card/flip_card.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:islamina_app/constants/constants.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:islamina_app/data/models/asmaullah_model.dart';
import 'package:islamina_app/widgets/asmaulah_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';

import '../data/repository/asmaullah_repository.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/loading_error_text.dart';

class AsmaullahPageView extends GetView {
  List<GlobalKey> shareWidgetKeys = List.generate(100, (index) => GlobalKey());

  AsmaullahPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate('asmaullah'),
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Uthmanic_Script', fontSize: 20.sp),
        ), // App bar title
        titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
      ),
      body: FutureBuilder(
        future: AsmaullahRepository().getAsmaullahData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomCircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(
              child: LoadingErrorText(),
            );
          } else {
            var asmaullah = snapshot.data!;
            return ListView.builder(
                itemCount: asmaullah.length,
                itemBuilder: (context, index) {
                  return FlipCard(
                    fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
                    direction: FlipDirection.HORIZONTAL, // default
                    side: CardSide.FRONT, // The side to initially display.
                    front: AsmaulahWidget(
                      asmaullah: asmaullah[index],
                    ),
                    back: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          RepaintBoundary(
                            key: shareWidgetKeys[index],
                            child: Container(
                              decoration: BoxDecoration(image: const DecorationImage(image: AssetImage('assets/images/asmaullah_back_2.jpg'), fit: BoxFit.cover, opacity: 0.5), borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 5),
                                ),
                              ]),
                              child: Center(
                                child: Text(
                                  asmaullah[index].fontCode!,
                                  style: TextStyle(fontFamily: 'allah_names', fontSize: 50.sp),
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                  onPressed: () async {
                                    _shareWidgetAsImage(shareWidgetKeys[index], asmaullah[index]);
                                  },
                                  icon: Icon(FluentIcons.share_24_regular, size: 20.sp, color: Get.theme.primaryColor.withOpacity(0.8)))),
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  Future<void> _shareWidgetAsImage(GlobalKey shareWidgetKey, AsmaullahModel asmaulah) async {
    try {
      RenderRepaintBoundary boundary = shareWidgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the image to a temporary file
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/shared_image.png');
      await file.writeAsBytes(pngBytes);

      // Create an XFile from the saved file and share it
      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: '${asmaulah.dsc!}\n$islaminaLink');
    } catch (e) {
    }
  }
}
 

// GridView.builder(
//               padding: const EdgeInsets.all(8.0),
//               itemCount: 99,
//               gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                 maxCrossAxisExtent: 75.h > 100.w ? 80.w / 3 : 80.h / 6,
//                 mainAxisSpacing: 8,
//                 crossAxisSpacing: 8,
//               ),
//               itemBuilder: (context, index) {
//                 var name = asmaullah[index];
//                 return Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       width: 1,
//                       color: Theme.of(context).disabledColor.withAlpha(40),
//                     ),
//                   ),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(9),
//                     onTap: () {
//                       Get.dialog(
//                         AlertDialog(
//                           title: Text(name.ttl!),
//                           content: Text(name.dsc!),
//                           actions: <Widget>[
//                             TextButton(
//                               onPressed: () {
//                                 Get.back();
//                               },
//                               child: const Text("حسناََ"),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     child: Center(
//                       child: AutoSizeText(
//                         name.ttl!,
//                         textAlign: TextAlign.center,
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                     ),
//                   ),
//                 );
//               },
            // );