import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:islamina_app/constants/constants.dart';
import 'package:islamina_app/controllers/azkar_details_controller.dart';
import 'package:islamina_app/controllers/azkar_settings_controller.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';
import 'package:share_plus/share_plus.dart';

class ZkrWidget extends StatelessWidget {
  const ZkrWidget({
    super.key,
    this.title,
    required this.description,
    required this.count,
    this.note,
    required this.counter,
    required this.onCounterButtonPressed,
    required this.onResetButtonPressed,
    required this.isDone,
    required this.azkarTotal,
    required this.index,
    this.fontSize,
  });

  final String? title;
  final String description;
  final String? note;
  final int count;
  final int counter;
  final int azkarTotal;
  final int index;
  final Function() onCounterButtonPressed;
  final Function() onResetButtonPressed;
  final bool isDone;
  final double? fontSize;
  // Helper method for building text with icon buttons
  Widget buildTextIconButton(IconData icon, String text, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
            ),
            const SizedBox(width: 5),
            Text(
              text,
              style: Theme.of(Get.context!).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);
    // var sharetext = '$description\n التكرار: $count';

    return _ZkrWidget(
      index: index,
      azkarTotal: azkarTotal,
      count: count,
      counter: counter,
      description: description,
      title: title,
      isDone: isDone,
      onCounterButtonPressed: onCounterButtonPressed,
      onResetButtonPressed: onResetButtonPressed,
      fontSize: fontSize,
      note: note,
    );
    //   return Container(
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(10),
    //       border: Border.all(
    //         width: 1,
    //         color: theme.disabledColor.withAlpha(40),
    //       ),
    //     ),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         // Top row with action buttons
    //         Material(
    //           borderRadius: const BorderRadius.only(
    //               topRight: Radius.circular(9), topLeft: Radius.circular(9)),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               // Copy, Share, Reset buttons
    //               Row(
    //                 children: [
    //                   buildTextIconButton(
    //                     FluentIcons.copy_16_regular,
    //                     'نسخ',
    //                     () async {
    //                       await Clipboard.setData(
    //                         ClipboardData(text: '$sharetext\n$islaminaLink'),
    //                       );
    //                     },
    //                   ),
    //                   const SizedBox(
    //                       height: 45, child: VerticalDivider(width: 1)),
    //                   buildTextIconButton(
    //                     FluentIcons.share_16_regular,
    //                     'مشاركة',
    //                     () async {
    //                       await Share.share('$sharetext\n$islaminaLink');
    //                     },
    //                   ),
    //                   const SizedBox(
    //                       height: 45, child: VerticalDivider(width: 1)),
    //                   buildTextIconButton(
    //                     Icons.refresh_rounded,
    //                     'إعادة',
    //                     onResetButtonPressed,
    //                   ),
    //                   const SizedBox(
    //                       height: 45, child: VerticalDivider(width: 1)),
    //                 ],
    //               ),
    //               // Display the count
    //               Row(
    //                 children: [
    //                   const SizedBox(
    //                       height: 45, child: VerticalDivider(width: 1)),
    //                   Padding(
    //                     padding: const EdgeInsets.all(12.0),
    //                     child: Text(
    //                       // 'التكرار : ${ArabicNumbers().convert(count)}',
    //                       'التكرار : $count',
    //                       style: theme.textTheme.bodyLarge,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //         const Divider(height: 1, thickness: 0.8),

    //         // Main content
    //         Padding(
    //           padding: const EdgeInsets.all(10.0),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [
    //               if (title != null)
    //                 Text(
    //                   title!,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: fontSize != null ? fontSize! - 2 : fontSize),
    //                 ),
    //               SizedBox(height: title != null ? 10 : 0),
    //               Text(
    //                 description,
    //                 style: TextStyle(fontSize: fontSize, height: 2),
    //               ),
    //               SizedBox(height: note != null ? 10 : 0),
    //               if (note != null)
    //                 Text(
    //                   '($note)',
    //                   textAlign: TextAlign.justify,
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: fontSize != null ? fontSize! - 2 : fontSize),
    //                 ),
    //               const SizedBox(height: 10),
    //             ],
    //           ),
    //         ),
    //         const Divider(
    //           height: 1,
    //           thickness: 0.8,
    //         ),

    //         // Bottom row with the counter button
    //         Material(
    //           borderRadius: const BorderRadius.only(
    //               bottomLeft: Radius.circular(9),
    //               bottomRight: Radius.circular(9)),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 child: Material(
    //                   color: isDone
    //                       ? Get.isDarkMode
    //                           ? theme.primaryColorDark
    //                           : theme.primaryColor.withAlpha(200)
    //                       : Colors.transparent,
    //                   borderRadius: const BorderRadius.only(
    //                       bottomRight: Radius.circular(9),
    //                       bottomLeft: Radius.circular(9)),
    //                   child: InkWell(
    //                     borderRadius: const BorderRadius.only(
    //                         bottomRight: Radius.circular(9),
    //                         bottomLeft: Radius.circular(9)),
    //                     onTap: isDone ? null : onCounterButtonPressed,
    //                     child: Padding(
    //                       padding: const EdgeInsets.symmetric(
    //                           vertical: 13, horizontal: 80),
    //                       child: isDone
    //                           ? const Icon(
    //                               Icons.check,
    //                               size: 20,
    //                               color: Colors.white,
    //                             )
    //                           : AutoSizeText(
    //                               // ArabicNumbers().convert(counter),
    //                               counter.toString(),
    //                               presetFontSizes: const [14, 20, 25],
    //                               textAlign: TextAlign.center,
    //                               style: TextStyle(
    //                                 color: isDone
    //                                     ? Colors.white
    //                                     : theme.colorScheme.onBackground,
    //                               ),
    //                               maxLines: 1,
    //                             ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
  }
}

class TextIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() onTap;
  final Color? color;
  const TextIconButton(this.icon, this.text, this.onTap, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: color ?? context.theme.primaryColor,
            ),
            const SizedBox(width: 5),
            Text(
              context.translate(text),
              style: Theme.of(Get.context!).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _ZkrWidget extends GetView<AzkarDetailsController> {
  const _ZkrWidget({
    this.title,
    required this.description,
    required this.count,
    this.note,
    required this.counter,
    required this.azkarTotal,
    required this.index,
    required this.onCounterButtonPressed,
    required this.onResetButtonPressed,
    required this.isDone,
    this.fontSize,
  });

  final String? title;
  final String description;
  final String? note;
  final int count;
  final int counter;
  final int azkarTotal;
  final int index;
  final Function() onCounterButtonPressed;
  final Function() onResetButtonPressed;
  final bool isDone;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var sharetext = description;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (title != null)
                  Text(
                    title!,
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize != null ? fontSize! - 2 : fontSize,
                      color: Colors.blue,
                    ),
                  ),
                SizedBox(height: title != null ? 10 : 0),
                Text(
                  description,
                  style: TextStyle(fontSize: fontSize, height: 2),
                ),
                SizedBox(height: note != null ? 10 : 0),
                if (note != null)
                  Text(
                    '( $note )',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize != null ? fontSize! - 2 : fontSize,
                      color: theme.primaryColor,
                    ),
                  ),
                const Gap(20),
              ],
            ),
          ),
          Column(
            children: [
              // TextIconButton
              Material(
                borderRadius: const BorderRadius.all(Radius.circular(9)),
                // color: context.theme.primaryColor.withOpacity(.1),
                child: Row(
                  children: [
                    const Spacer(),
                    TextIconButton(
                      FluentIcons.copy_16_regular,
                      'copy',
                      () async {
                        await Clipboard.setData(
                          ClipboardData(text: '$sharetext\n$islaminaLink'),
                        );
                      },
                      color: Colors.amber,
                    ),
                    const Spacer(),
                    const SizedBox(
                      height: 45,
                      child: VerticalDivider(width: 1),
                    ),
                    const Spacer(),
                    TextIconButton(
                      FluentIcons.share_16_regular,
                      'share',
                      () async {
                        await Share.share('$sharetext\n$islaminaLink');
                      },
                      color: Colors.blue,
                    ),
                    const Spacer(),
                    const SizedBox(
                      height: 45,
                      child: VerticalDivider(width: 1),
                    ),
                    const Spacer(),
                    TextIconButton(
                      Icons.refresh_rounded,
                      're',
                      onResetButtonPressed,
                      color: Colors.green,
                    ),
                    const Spacer(),
                    const SizedBox(
                      height: 45,
                      child: VerticalDivider(width: 1),
                    ),
                    const Spacer(),
                    TextIconButton(
                      FluentIcons.text_font_size_16_regular,
                      'fontSize',
                      () => _updateFontSize(context),
                      color: theme.primaryColor,
                    ),
                    const Spacer(),
                    // const SizedBox(height: 45, child: VerticalDivider(width: 1)),
                  ],
                ),
              ),

              const Gap(20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                     context.translate(   'numOfzekr'),
                        style: theme.textTheme.bodyLarge,
                      ),
                      const Gap(10),
                      Text(
                        count.toString(),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: isDone
                  //         ? Get.isDarkMode
                  //             ? theme.primaryColorDark
                  //             : theme.primaryColor.withAlpha(200)
                  //         : Colors.transparent,
                  //   ),
                  //   child: InkWell(
                  //     borderRadius: const BorderRadius.only(
                  //         bottomRight: Radius.circular(9),
                  //         bottomLeft: Radius.circular(9)),
                  //     onTap: isDone ? null : onCounterButtonPressed,
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //           vertical: 13, horizontal: 80),
                  //       child: isDone
                  //           ? const Icon(
                  //               Icons.check,
                  //               size: 20,
                  //               color: Colors.white,
                  //             )
                  //           : AutoSizeText(
                  //               // ArabicNumbers().convert(counter),
                  //               counter.toString(),
                  //               presetFontSizes: const [14, 20, 25],
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(
                  //                 color: isDone
                  //                     ? Colors.white
                  //                     : theme.colorScheme.onBackground,
                  //               ),
                  //               maxLines: 1,
                  //             ),
                  //     ),
                  //   ),
                  // ),
                  isDone
                      ? Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            // color: theme.primaryColor,
                            color: Colors.blue,
                            // border: Border.all(
                            //   color: theme.primaryColor,
                            //   width: 3,
                            // ),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 40,
                            // color: theme.primaryColor,
                            color: theme.scaffoldBackgroundColor,
                          ),
                        )
                      : GestureDetector(
                          onTap: onCounterButtonPressed,
                          // onTap: () {
                          //   controller.incrementProgress(count);
                          // },
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                  // color: theme.primaryColor,
                                  color: Colors.transparent,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    // counter.toString(),
                                    controller.counter.toString(),
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 85,
                                    height: 85,
                                    child: Obx(() {
                                      final controller = Get.find<AzkarDetailsController>();
                                      return CircularProgressIndicator(
                                        value: controller.counterPrgress.value,
                                        strokeWidth: 10,
                                        color: Colors.blue,
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                  // isDone
                  //     ? Stack(
                  //         alignment: Alignment.center,
                  //         children: [
                  //           Material(
                  //             borderRadius: BorderRadius.circular(100),
                  //             child: WaveBall(
                  //               progress: 1.0,
                  //               size: 85,
                  //               circleColor: Colors.transparent,
                  //               backgroundColor: theme.primaryColor,
                  //               foregroundColor:
                  //                   theme.primaryColor.withOpacity(0.5),
                  //             ),
                  //           ),
                  //           Text(
                  //             count.toString(),
                  //             style: theme.textTheme.headlineSmall?.copyWith(
                  //               fontWeight: FontWeight.bold,
                  //               color: theme.scaffoldBackgroundColor,
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     : GestureDetector(
                  //         onTap: onCounterButtonPressed,
                  //         child: Stack(
                  //           alignment: Alignment.center,
                  //           children: [
                  //             Material(
                  //               borderRadius: BorderRadius.circular(100),
                  //               child: WaveBall(
                  //                 progress: Get.put(AzkarDetailsController())
                  //                     .counterPrgress
                  //                     .value,
                  //                 size: 85,
                  //                 circleColor: Colors.transparent,
                  //                 backgroundColor: theme.primaryColor,
                  //                 foregroundColor:
                  //                     theme.primaryColor.withOpacity(0.5),
                  //               ),
                  //             ),
                  //             Text(
                  //               controller.counter.toString(),
                  //               style: theme.textTheme.headlineSmall?.copyWith(
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Get.put(AzkarDetailsController())
                  //                             .counterPrgress
                  //                             .value >
                  //                         0.5
                  //                     ? theme.scaffoldBackgroundColor
                  //                     : null,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  Column(
                    children: [
                      Text(
                        context.translate("totalNumOfzekr"),
                        style: theme.textTheme.bodyLarge,
                      ),
                      const Gap(10),
                      Text(
                        '$azkarTotal / $index',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// show dialog with contain slider

_updateFontSize(BuildContext context) {
  Get.dialog(
    Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'حجم الخط',
              style: Get.theme.textTheme.headlineSmall,
            ),
            const Gap(10),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: context.theme.colorScheme.primaryContainer,
                inactiveTickMarkColor: context.theme.colorScheme.primary,
                inactiveTrackColor: context.theme.colorScheme.primaryContainer,
              ),
              child: GetBuilder(
                  init: AzkarSettingsController(),
                  builder: (controller) {
                    return Slider(
                      value: controller.azkarSettings.fontSize,
                      min: 16,
                      max: 32,
                      // label: ArabicNumbers()
                      //     .convert('${controller.azkarSettings.fontSize}'),
                      label: '${controller.azkarSettings.fontSize}',
                      onChanged: controller.updateFontSize,
                      divisions: 4,
                    );
                  }),
            ),
          ],
        ),
      ),
    ),
  );
}
