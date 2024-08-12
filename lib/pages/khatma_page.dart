import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:islamina_app/controllers/khatma_controller.dart';
import 'package:islamina_app/pages/add_khatma_page.dart';

class KhatmaPage extends StatelessWidget {
  const KhatmaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الختمة'),
        titleTextStyle: context.theme.primaryTextTheme.titleMedium,
      ),
      body: const _BodyView(),
      floatingActionButton: const _FloatingActionButtonForAddKhatma(),
    );
  }
}

class _FloatingActionButtonForAddKhatma extends GetView<KhatmaController> {
  const _FloatingActionButtonForAddKhatma();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Get.to(() => const AddKhatmaPage()),
      elevation: 0,
      backgroundColor: context.theme.primaryColor,
      child: Icon(
        FluentIcons.add_circle_24_regular,
        color: context.theme.scaffoldBackgroundColor,
      ),
    );
  }
}

class _BodyView extends StatelessWidget {
  const _BodyView();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: KhatmaController(),
      builder: (controller) {
        return controller.khatmas.isEmpty
            ? Center(
                child: Text(
                  'ابدأ ختمتك الآن',
                  style: context.theme.textTheme.headlineSmall,
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: 10,
                separatorBuilder: (_, __) => const Gap(15),
                itemBuilder: (_, index) {
                  return const _KhatmaItem();
                },
              );
      },
    );
  }
}

class _KhatmaItem extends StatelessWidget {
  const _KhatmaItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        // border: Border.all(
        //   color: context.theme.primaryColor.withOpacity(0.3),
        // ),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: const Offset(0, 0),
            color: context.theme.primaryColor.withOpacity(0.3),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'تنتهي بعد 36 يوم - حزب يومياً',
              style: context.textTheme.bodyLarge?.copyWith(
                color: Colors.deepOrange,
              ),
            ),
            subtitle: const Text('ختمة خاصة'),
          ),
        ],
      ),
    );
  }
}
