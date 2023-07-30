import 'package:flutter/material.dart';
import 'package:xflash/common_string.dart';
import 'package:xflash/service/catch_zone.dart';
import 'package:xflash/ui/table_view.dart';

void main() {
  enterCatchZone(widget: MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<Map<String, dynamic>> dataSource = [
    {
      WordKey.title: StringKey.catchError,
      WordKey.list: [
        StringKey.nullError,
        StringKey.indexError,
        StringKey.castError,
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('XFlash实验室'),
        ),
        body: TableView(
          sectionCount: dataSource.length,
          itemCount: (section) {
            Map<String, dynamic> sectionSource = dataSource[section];
            List<String> list = sectionSource[WordKey.list];
            return list.length;
          },
          buildItem: (context, section, row) {
            Map<String, dynamic> sectionSource = dataSource[section];
            List<String> list = sectionSource[WordKey.list];
            return GestureDetector(
              onTap: () => tapItem(context, section, row),
              child: Text(list[row]),
            );
          },
          sectionHeader: (context, section) {
            Map<String, dynamic> sectionSource = dataSource[section];
            String title = sectionSource[WordKey.title];
            return Text(
              title,
              style: const TextStyle(
                fontSize: 18,
              ),
            );
          },
        ),
      ),
    );
  }

  void tapItem(BuildContext context, int section, int row) {
    Map<String, dynamic> sectionSource = dataSource[section];
    String sectionTitle = sectionSource[WordKey.title];
    String rowTitle = sectionSource[WordKey.list][row];

    switch (sectionTitle) {
      case StringKey.catchError:
        if (rowTitle == StringKey.nullError) {
          String? name;
          debugPrint(name!);
        } else if (rowTitle == StringKey.indexError) {
          List<String> list = [];
          debugPrint(list.first);
        } else if (rowTitle == StringKey.castError) {
          String name = '';
          int index = name as int;
          debugPrint('$index');
        }
        break;
      default:
        break;
    }
  }
}
