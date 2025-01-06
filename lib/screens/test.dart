// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:future_capsule/core/constants/colors.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class Test extends StatefulWidget {
//   const Test({super.key});

//   @override
//   State<Test> createState() => _TestState();
// }

// class _TestState extends State<Test> {
//   final pdf = pw.Document();

//   void createPDF() {
//     pdf.addPage(pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Container(
//             padding: pw.EdgeInsets.all(12),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.SizedBox(
//                   height: 50,
//                 ),
//                 pw.Text("THE TASK",
//                     style: pw.TextStyle(
//                       fontSize: 18,
//                       fontWeight: pw.FontWeight.bold,
//                     )),
//                 pw.SizedBox(
//                   height: 20,
//                 ),
//                 pw.Text(
//                     "City of Yarra (the Principal) wished to undertake a feasibility study into the establishment of a new live music Festival within the City of Yarra. This included recommendations about the feasibility, nature, structure, positioning and model for such a new venture.",
//                     style: pw.TextStyle(
//                       fontSize: 14,
//                     )),
//                 pw.SizedBox(
//                   height: 20,
//                 ),
//                 pw.Text("THE BRIEF",
//                     style: pw.TextStyle(
//                       fontSize: 18,
//                       fontWeight: pw.FontWeight.bold,
//                     )),
//                 pw.SizedBox(
//                   height: 20,
//                 ),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                   children: [
//                     pw.Container(
//                       height: 10,
//                       width: 10,
//                       margin: pw.EdgeInsets.only(right: 30, left: 20),
//                       decoration: pw.BoxDecoration(
//                           borderRadius: pw.BorderRadius.circular(100)),
//                     ),
//                     pw.Expanded(
//                         child: pw.Text(
//                       "consult across a range of stakeholders, note issues of concern as well as areas of consensus",
//                     ))
//                   ],
//                 ),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                   children: [
//                     pw.Container(
//                       height: 10,
//                       width: 10,
//                       margin: pw.EdgeInsets.only(right: 30, left: 20),
//                       decoration: pw.BoxDecoration(
//                           borderRadius: pw.BorderRadius.circular(100)),
//                     ),
//                     pw.Expanded(
//                         child: pw.Text(
//                       "consult across a range of stakeholders, note issues of concern as well as areas of consensus",
//                     ))
//                   ],
//                 ),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                   children: [
//                     pw.Container(
//                       height: 10,
//                       width: 10,
//                       margin: pw.EdgeInsets.only(right: 30, left: 20),
//                       decoration: pw.BoxDecoration(
//                           borderRadius: pw.BorderRadius.circular(100)),
//                     ),
//                     pw.Expanded(
//                         child: pw.Text(
//                       "consult across a range of stakeholders, note issues of concern as well as areas of consensus",
//                     ))
//                   ],
//                 ),
//                 pw.Text("Methodology",
//                     style: pw.TextStyle(
//                       fontSize: 18,
//                       fontWeight: pw.FontWeight.bold,
//                     )),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                   children: [
//                     pw.Container(
//                       height: 10,
//                       width: 10,
//                       margin: pw.EdgeInsets.only(right: 30, left: 20),
//                       decoration: pw.BoxDecoration(
//                           borderRadius: pw.BorderRadius.circular(100)),
//                     ),
//                     pw.Expanded(
//                         child: pw.Text(
//                       "consult across a range of stakeholders, note issues of concern as well as areas of consensus",
//                     ))
//                   ],
//                 ),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                   children: [
//                     pw.Container(),
//                     pw.Expanded(
//                         child: pw.Text(
//                       "consult across a range of stakeholders, note issues of concern as well as areas of consensus",
//                     ))
//                   ],
//                 ),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                   children: [
//                     pw.Container(
//                       height: 10,
//                       width: 10,
//                       margin: pw.EdgeInsets.only(right: 30, left: 20),
//                       decoration: pw.BoxDecoration(
//                           borderRadius: pw.BorderRadius.circular(100)),
//                     ),
//                     pw.Expanded(
//                         child: pw.Text(
//                       "consult across a range of stakeholders, note issues of concern as well as areas of consensus",
//                     ))
//                   ],
//                 ),
//               ],
//             ),
//           );
//         })); // Page
//   }

//   void savePDF() async {
//     createPDF();
//     var savedFile = await pdf.save();

//     List<int> fileInts = List.from(savedFile);

//     await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => savedFile,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // createPDF();
//     // savePDF();
//     return Container(
//       padding: EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 50,
//           ),
//           Text("THE TASK",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w900,
//               )),
//           SizedBox(
//             height: 20,
//           ),
//           Text(
//               "City of Yarra (the Principal) wished to undertake a feasibility study into the establishment of a new live music Festival within the City of Yarra. This included recommendations about the feasibility, nature, structure, positioning and model for such a new venture.",
//               style: TextStyle(
//                 fontSize: 14,
//               )),
//           SizedBox(
//             height: 20,
//           ),
//           Text("THE BRIEF",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w900,
//               )),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 "  \u2022   ",
//                 style: TextStyle(fontSize: 40),
//               ),
//               Expanded(
//                   child: Text(
//                 "consult across a range of stakeholders, note issues of concern as well as areas of consensus",
//               ))
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 height: 10,
//                 width: 10,
//                 margin: EdgeInsets.only(right: 30, left: 20),
//                 decoration: BoxDecoration(
//                     color: AppColors.kBlackColor,
//                     borderRadius: BorderRadius.circular(100)),
//               ),
//               Expanded(
//                   child: Text(
//                 "consult across a range of stakeholders, note issues of concern as well as areas of consensus",
//               ))
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children:  [
//               Text(
//                 "  \u2022   ",
//                 style: TextStyle(fontSize: 40),
//               ),
//               Expanded(
//                   child: Text(
//                 "consult across a range of stakeholders, note issues of concern as well as areas of consensus",
//               ))
//             ],
//           ),
//           Text("Methodology",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w900,
//               )),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children:  [
//               Text(
//                 "  \u2022   ",
//                 style: TextStyle(fontSize: 40),
//               ),
//               Expanded(
//                   child: Text(
//                 "consult across a range of stakeholders, note issues of concern as well as areas of consensus",
//               ))
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 "  \u2022   ",
//                 style: TextStyle(fontSize: 40),
//               ),
//               Expanded(
//                   child: Text(
//                 "consult across a range of stakeholders, note issues of concern as well as areas of consensus",
//               ))
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 "  \u2022   ",
//                 style: TextStyle(fontSize: 40),
//               ),
//               Expanded(
//                   child: Text(
//                 "consult across a range of stakeholders, note issues of concern as well as areas of consensus",
//               ))
//             ],
//           ),
//           ElevatedButton(onPressed: savePDF, child: Text("save"))
//         ],
//       ),
//     );
//   }
// }
