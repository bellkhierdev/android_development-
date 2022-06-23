//version 1.0.0
import 'dart:io';
import 'package:issue/export.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'pdf_api.dart';

class PdfParagraphApi {
  static Future<File> generate(
      String nameFile, Accused accused, Invoice invoice) async {
    final pdf = Document();
    final ByteData bytes = await rootBundle.load('assets/icon.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    // final ByteData bytesFace = await rootBundle.load('assets/facebook.png');
    // final Uint8List byteListFace = bytesFace.buffer.asUint8List();

    pdf.addPage(
      MultiPage(
        textDirection: TextDirection.rtl,
        theme: ThemeData.withFont(
          base: Font.ttf(await rootBundle.load("fonts/Cairo-Regular.ttf")),
          bold: Font.ttf(await rootBundle.load("fonts/Cairo-Regular.ttf")),
          italic: Font.ttf(await rootBundle.load("fonts/Cairo-Regular.ttf")),
          boldItalic:
              Font.ttf(await rootBundle.load("fonts/Cairo-Regular.ttf")),
        ),
        build: (context) => <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            pw.Container(
                height: 100,
                width: 100,
                child: pw.Image(
                    pw.MemoryImage(
                      byteList,
                    ),
                    fit: pw.BoxFit.fitHeight)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Text('مواعيد تمديدات الحبس الإحتياطي',
                  style: pw.TextStyle(
                      color: PdfColors.lightBlueAccent700,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 12),
            pw.Container(
              height: 100,
              width: 100,
              child: pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: invoice.supplier.name,
              ),
            ),
          ]),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildCustomHeader(accused),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildCustomHeadline(),
          ...buildBulletPoints(accused),
          Header(
              child: Text('تفاصيل التنبية',
                  style: const TextStyle(
                    fontSize: 20,
                  ))),
          buildInvoice(invoice),
        ],
        footer: (context) {
          final text = 'صفحة ${context.pageNumber} من ${context.pagesCount}';
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // developer can add custom widgets here
                // buildLink(byteListFace),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 1 * PdfPageFormat.cm),
                  child: Text(
                    ''.replaceFarsiNumber(
                      text,
                    ),
                    style: const TextStyle(color: PdfColors.black),
                  ),
                ),
              ]);
        },
      ),
    );
    return PdfApi.saveDocument(name: nameFile.toString() + '.pdf', pdf: pdf);
  }

  static Widget buildCustomHeader(Accused accused) => Container(
        padding: const EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: PdfColors.blue)),
        ),
        child: Row(
          children: [
            PdfLogo(),
            SizedBox(width: 0.5 * PdfPageFormat.cm),
            Text(
              accused.name.toString(),
              style: const TextStyle(fontSize: 20, color: PdfColors.blue),
            ),
          ],
        ),
      );

  static Widget buildCustomHeadline() => Header(
        child: Text(
          'تفاصيل التهمة',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: PdfColors.white,
          ),
        ),
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: PdfColors.blue),
      );
// developer can add custom widgets here
  // static Widget buildLink(byteListFace) => UrlLink(
  //     /* this is my account in facebook */
  //     destination: 'https://www.facebook.com/profile.php?id=100033010871326',
  //     child: pw.Row(children: [
  //       Padding(
  //         padding: const EdgeInsets.all(2),
  //         child: Text(
  //           'المبرمج',
  //           style: const TextStyle(
  //               decoration: TextDecoration.underline,
  //               color: PdfColors.deepPurple600,
  //               fontSize: 20),
  //         ),
  //       ),
  //       pw.Container(
  //           height: 30,
  //           width: 30,
  //           child: pw.Image(
  //               pw.MemoryImage(
  //                 byteListFace,
  //               ),
  //               fit: pw.BoxFit.fitHeight),
  //           decoration: const BoxDecoration(
  //               color: PdfColors.blueAccent700,
  //               borderRadius: BorderRadius.all(Radius.circular(50)))),
  //     ]));

  static List<Widget> buildBulletPoints(Accused accused) => [
        costumeRow(
          libale: 'التهمة',
          value: accused.accused.toString(),
        ),
        costumeRow(
          libale: 'رقم القضية',
          value: accused.issueNumber.toString(),
        ),
        costumeRow(
          libale: 'رقم وكيل المتهم',
          value: '${accused.phoneNu ?? ''}',
        ),
        costumeRow(
          libale: 'تاريخ الدخول',
          value: ''.splitsDate(accused.date),
        ),
        costumeRow(
          libale: 'الملاحظة',
          value: accused.note ?? '',
        ),
      ];

  static costumeRow({required String libale, required String value}) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(child: Bullet()),
      Text(value, style: const TextStyle(fontSize: 20)),
      Text('$libale: ', style: const TextStyle(fontSize: 19)),
    ]);
  }

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'المتبقي',
      ' التاريخ التنبية ',
      'التنبية',
    ];
    final data = invoice.items.map((item) {
      return [
        item.unitPrice,
        item.date,
        item.description,
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      cellStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
    );
  }
}

class Customer {
  final String name;
  final String address;

  const Customer({
    required this.name,
    required this.address,
  });
}

class Invoice {
  // final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    // required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String date;

  const InvoiceInfo({
    required this.description,
    required this.date,
  });
}

class InvoiceItem {
  final String description;
  final String date;

  final String unitPrice;

  const InvoiceItem({
    required this.description,
    required this.date,
    required this.unitPrice,
  });
}

class Supplier {
  final String name;
  final String address;
  final String paymentInfo;

  const Supplier({
    required this.name,
    required this.address,
    required this.paymentInfo,
  });
}
