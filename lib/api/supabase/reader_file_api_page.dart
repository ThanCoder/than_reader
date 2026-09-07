// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ReaderFileApiPage extends StatefulWidget {
//   const new({super.key});

//   @override
//   State<ReaderFileApiPage> createState() => _ReaderFileApiPageState();
// }

// class _ReaderFileApiPageState extends State<ReaderFileApiPage> {
//   final client = Supabase.instance.client;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reader Doc Api List'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               setState(() {});
//             },
//             icon: Icon(Icons.refresh),
//           ),
//         ],
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverPadding(
//             padding: .symmetric(vertical: 10, horizontal: 12),
//             sliver: FutureBuilder(
//               future: client.from('reader_file_desc').select(),
//               builder: (context, snapshot) {
//                 final data = snapshot.data ?? [];

//                 if (data.isEmpty) {
//                   return SliverFillRemaining(
//                     child: Center(child: Text('Empty!')),
//                   );
//                 }

//                 return SliverList.builder(
//                   itemCount: data.length,
//                   itemBuilder: (context, index) {
//                     final item = data[index];

//                     return Text('$index: ${item.toString()}');
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           print('loading');
//           final res = await client.from('reader_file_desc').select();
//           print(res);
//         },
//       ),
//     );
//   }
// }
