// return GridView.builder(
//   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     crossAxisSpacing: 15,
//     mainAxisSpacing: 15,
//   ),
//   itemCount: pertemuanList.length,
//   itemBuilder: (_, int i) {
//     final pertemuan = pertemuanList[i];
//     return DefaultTextStyle(
//       style: TextStyle(color: Colors.black),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//         decoration: BoxDecoration(
//           color: Colors.blue.withOpacity(0.5),
//           borderRadius: const BorderRadius.all(Radius.circular(20)),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   pertemuan['tanggal'],
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Icon(
//                   Icons.more_vert_sharp,
//                   color: Colors.black,
//                 ),
//               ],
//             ),
//             Flexible(flex: 1, child: Container()),
//             Text(
//               pertemuan['nama'],
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             Text(
//               "Success",
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             Flexible(flex: 1, child: Container()),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(
//                   "Details",
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   },
// );



