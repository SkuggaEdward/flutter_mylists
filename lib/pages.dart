import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Font> _loadIcons() async {
  final data = await rootBundle.load('assets/fonts/material.ttf');
  return Font.ttf(data);
}

Font? _iconFont;
Map<String, IconData> _icons = {};

Future<Uint8List> generatePdf(PdfPageFormat format, String title) async {
  final pdf = Document();

  _iconFont = await _loadIcons();

  pdf.addPage(
    Page(
      theme: ThemeData.withFont(icons: _iconFont),
      orientation: PageOrientation.landscape,
      margin: EdgeInsets.zero,
      build: (context) {
        final iconList = <IconData>[];
        final pdfFont = _iconFont!.getFont(context);
        if (pdfFont is PdfTtfFont) {
          iconList.addAll(
            pdfFont.font.charToGlyphIndexMap.keys.where((e) => e > 0x7f && e < 0xe05d).map((e) => IconData(e)),
          );
        }
        return Transform.rotate(
          angle: format.height > format.width ? 0 : math.pi / 2,
          child: Stack(
            children: [
              grid(),
              GridView(
                crossAxisCount: 4,
                children: List.generate(8, (index) => page(context, index)),
              ),
            ],
          ),
        );
      },
    ),
  );

  return pdf.save();
}

Widget page(Context context, int index) {
  final order = [
    1,
    2,
    3,
    4,
    0,
    7,
    6,
    5,
  ];
  // ignore: unused_local_variable
  final colors = [
    PdfColors.red,
    PdfColors.green,
    PdfColors.blue,
    PdfColors.yellow,
    PdfColors.purple,
    PdfColors.red,
    PdfColors.green,
    PdfColors.blue,
  ];
  return Container(
    //color: colors[index],
    child: Transform.rotate(
      angle: index > 3 ? math.pi : 0,
      child: _page(order[index]),
    ),
  );
}

Widget _gridRowTop(int num) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 2 * PdfPageFormat.mm,
        height: 2 * PdfPageFormat.mm,
        decoration: BoxDecoration(
          border: Border(
            right: _border,
            bottom: _border,
          ),
        ),
      ),
      ...List.generate(
        num - 2,
        (index) => Container(
          width: 5 * PdfPageFormat.mm,
          height: 2 * PdfPageFormat.mm,
          decoration: BoxDecoration(
            border: Border(
              right: _border,
              bottom: _border,
            ),
          ),
        ),
      ),
      Container(
        width: 2 * PdfPageFormat.mm,
        height: 2 * PdfPageFormat.mm,
        decoration: BoxDecoration(
          border: Border(
            bottom: _border,
          ),
        ),
      )
    ],
  );
}

Widget _gridRow(int num) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 2 * PdfPageFormat.mm,
        height: 5 * PdfPageFormat.mm,
        decoration: BoxDecoration(
          border: Border(
            right: _border,
            bottom: _border,
          ),
        ),
      ),
      ...List.generate(
        num - 2,
        (index) => Container(
          width: 5 * PdfPageFormat.mm,
          height: 5 * PdfPageFormat.mm,
          decoration: BoxDecoration(
            border: Border(
              right: _border,
              bottom: _border,
            ),
          ),
        ),
      ),
      Container(
        width: 2 * PdfPageFormat.mm,
        height: 5 * PdfPageFormat.mm,
        decoration: BoxDecoration(
          border: Border(
            bottom: _border,
          ),
        ),
      )
    ],
  );
}

Widget _gridRowBottom(int num) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 2 * PdfPageFormat.mm,
        height: 2 * PdfPageFormat.mm,
        decoration: BoxDecoration(
          border: Border(
            right: _border,
          ),
        ),
      ),
      ...List.generate(
        num - 2,
        (index) => Container(
          width: 5 * PdfPageFormat.mm,
          height: 2 * PdfPageFormat.mm,
          decoration: BoxDecoration(
            border: Border(
              right: _border,
            ),
          ),
        ),
      ),
      Container(
        width: 2 * PdfPageFormat.mm,
        height: 2 * PdfPageFormat.mm,
      )
    ],
  );
}

Widget _gridPage() {
  return Center(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _gridRowTop(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRow(15),
          _gridRowBottom(15),
        ],
      ),
    ),
  );
}

BorderSide get _border => const BorderSide(
      color: PdfColors.black,
      width: 0.1,
    );
BorderSide get _dashedBorder => const BorderSide(
      color: PdfColors.black,
      width: 0.1,
      style: BorderStyle(pattern: [4, 4]),
    );

Widget grid() {
  return GridView(
    crossAxisCount: 4,
    children: [
      // 1
      Container(
        decoration: BoxDecoration(
          border: Border(
            right: _border,
          ),
        ),
      ),
      // 2
      Container(
        decoration: BoxDecoration(
          border: Border(
            right: _border,
          ),
        ),
      ),
      // 3
      Container(
        decoration: BoxDecoration(
          border: Border(
            right: _border,
          ),
        ),
      ),
      // 4
      Container(),
      // 0
      Container(
        decoration: BoxDecoration(
          border: Border(
            top: _border,
            right: _border,
          ),
        ),
      ),
      // 7
      Container(
        decoration: BoxDecoration(
          border: Border(
            top: _dashedBorder,
            right: _border,
          ),
        ),
      ),
      // 6
      Container(
        decoration: BoxDecoration(
          border: Border(
            top: _dashedBorder,
            right: _border,
          ),
        ),
      ),
      // 5
      Container(
        decoration: BoxDecoration(
          border: Border(
            top: _border,
          ),
        ),
      ),
    ],
  );
}

const _iconSize = 16.0;
const _dividerSize = 10.0;

Widget _checkboxPage() {
  return Container(
    padding: EdgeInsets.all(2 * PdfPageFormat.mm),
    width: double.infinity,
    child: Column(
      children: [
        // Get 'Code point'
        // https://fonts.google.com/icons?icon.query=check
        Row(children: [Text('TODO:')]),
        Divider(thickness: 0.1, height: _dividerSize),
        Row(children: [Icon(const IconData(0xe835), size: _iconSize), Spacer()]),
        Divider(thickness: 0.1, height: _dividerSize),
        Row(children: [Icon(const IconData(0xe835), size: _iconSize), Spacer()]),
        Divider(thickness: 0.1, height: _dividerSize),
        Row(children: [Icon(const IconData(0xe835), size: _iconSize), Spacer()]),
        Divider(thickness: 0.1, height: _dividerSize),
        Row(children: [Icon(const IconData(0xe835), size: _iconSize), Spacer()]),
        Divider(thickness: 0.1, height: _dividerSize),
        Row(children: [Icon(const IconData(0xe835), size: _iconSize), Spacer()]),
        Divider(thickness: 0.1, height: _dividerSize),
        Row(children: [Icon(const IconData(0xe835), size: _iconSize), Spacer()]),
        Divider(thickness: 0.1, height: _dividerSize),
        Row(children: [Icon(const IconData(0xe835), size: _iconSize), Spacer()]),
        Divider(thickness: 0.1, height: _dividerSize),
        Row(children: [Icon(const IconData(0xe835), size: _iconSize), Spacer()]),
        Divider(thickness: 0.1, height: _dividerSize),
        Row(children: [Icon(const IconData(0xe835), size: _iconSize), Spacer()]),
        Divider(thickness: 0.1, height: _dividerSize),
        Row(children: [Icon(const IconData(0xe835), size: _iconSize), Spacer()]),
        Divider(thickness: 0.1, height: _dividerSize),
      ],
    ),
  );
}

Widget _page(int index) {
  switch (index) {
    case 0:
    case 1:
    case 2:
    case 3:
      return _checkboxPage();
    case 4:
    case 5:
    case 6:
    case 7:
      return _gridPage();
    default:
      return Center(child: Text('${index + 1}'));
  }
}
