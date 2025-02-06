import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamina_app/core/extensions/translation_extension.dart';

class DefultKhatmaWidget extends StatelessWidget {
  final String image;
  final String title;
  const DefultKhatmaWidget({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image),
        Text(
         context.translate(title), 
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
