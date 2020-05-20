import 'package:example/widgets/cells.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

StoryBookPage buildMainCellListPage() => StoryBookPage.of(
      title: 'Main Cell List',
      child: (context) => MainCellList(
        shrinkWrap: true,
        items: [
          MainCellItem('A', 'Item 1', 'Item Subtitle', 10),
          MainCellItem('B', 'Item 2', 'Item Subtitle', 20),
        ],
      ),
    );
