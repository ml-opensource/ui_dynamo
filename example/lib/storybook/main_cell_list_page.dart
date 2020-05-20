import 'package:example/widgets/cells.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

const PropGroup item1 = PropGroup('Item 1', 'item-1');
const PropGroup item2 = PropGroup('Item 2', 'item-2');

StoryBookPage buildMainCellListPage() => StoryBookPage.of(
      title: 'Main Cell List',
      child: (context) => MainCellList(
        items: [
          MainCellItem(
            context.props.text('Avatar', 'A', group: item1),
            context.props.text('Title', 'Item 1', group: item1),
            context.props.text('Subtitle', 'Item Subtitle', group: item1),
            context.props.number('Count', 0, group: item1),
          ),
          MainCellItem(
            context.props.text('Avatar', 'B', group: item2),
            context.props.text('Title', 'Item 1', group: item2),
            context.props.text('Subtitle', 'Item Subtitle', group: item2),
            context.props.number('Count', 20, group: item2),
          ),
        ],
      ),
    );
