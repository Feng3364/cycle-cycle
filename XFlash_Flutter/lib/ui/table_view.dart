import 'package:flutter/material.dart';

class TableView extends StatelessWidget {
  final int sectionCount;
  final int Function(int section) itemCount;
  final Widget Function(BuildContext context, int section, int row) buildItem;

  final Widget Function(BuildContext context, int section)? sectionHeader;
  final Widget Function(BuildContext context, int section)? sectionFooter;
  final Widget Function(BuildContext context, int section)? sectionSpacer;
  final Widget Function(BuildContext context, int row)? itemSpacer;
  final EdgeInsetsGeometry? padding;

  const TableView({
    super.key,
    required this.sectionCount,
    required this.itemCount,
    required this.buildItem,
    this.sectionHeader,
    this.sectionFooter,
    this.sectionSpacer,
    this.itemSpacer,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: sectionCount,
      separatorBuilder: sectionSpacer ?? (context, section) => const SizedBox(),
      itemBuilder: (context, section) {
        ListView itemsView = ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, row) => buildItem(context, section, row),
          separatorBuilder: itemSpacer ?? (context, row) => const SizedBox(),
          itemCount: itemCount(section),
          shrinkWrap: true,
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (sectionHeader != null) sectionHeader!(context, section),
            itemsView,
            if (sectionFooter != null) sectionFooter!(context, section),
          ],
        );
      },
    );
  }
}
