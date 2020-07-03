import 'package:example/widgets/cells.dart';
import 'package:ui_dynamo/ui_dynamo.dart';

const PropGroup item1 = PropGroup('Item 1', 'item-1');
const PropGroup item2 = PropGroup('Item 2', 'item-2');

DynamoPage buildMainCellListPage() => DynamoPage.of(
      title: 'Main Cell List',
      child: (context) => MainCellList(
        onTap: (item) {
          context.actions.add(ActionType('Navigation attempted', data: item));
        },
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
