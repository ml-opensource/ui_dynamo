import 'package:example/widgets/cells.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

final groupMainCell = PropGroup('Main Cell', 'mainCell');
final groupMainCellLong = PropGroup('Main Cell Long', 'mainCellLong');

StoryBookPage buildCellsPage() => StoryBookPage.list(
  title: 'Cells',
  widgets: (context) => [
    WidgetContainer(
      title: Text('Main Cell Widget'),
      children: <Widget>[
        MainCell(
          title: context.props
              .text('Main Title', 'Go Home', group: groupMainCell),
          subtitle: context.props.text(
              'Main Subtitle', 'This goes home good',
              group: groupMainCell),
          iconText: 'H',
          count: context.props
              .integer('Item Count', 10, group: groupMainCell),
          isFlipped: context.props
              .boolean('Flip Layout', false, group: groupMainCell),
        )
      ],
    ),
    WidgetContainer(
      title: Text('Main Cell Widget With Long Text'),
      children: <Widget>[
        MainCell(
          title: 'Live Life',
          subtitle:
          'In porttitor mauris dui, pellentesque egestas justo rutrum a. Praesent eu congue justo. Mauris vulputate tempor augue a luctus. Nullam elementum, elit eu pretium convallis, purus sapien lobortis libero, eget congue diam erat suscipit ipsum. In hac habitasse platea dictumst. Vestibulum tincidunt nisi in elit mattis commodo. Duis eu placerat nibh. Nulla magna magna, tristique sed sapien imperdiet, porttitor pulvinar libero. Mauris nec vehicula velit, a maximus ligula. Morbi in purus et eros placerat faucibus non fermentum lorem. Nunc sit amet felis eu mi scelerisque aliquam a imperdiet justo. Nulla facilisi. Proin commodo facilisis sapien vel aliquam. Cras quis nisi quam. Fusce vitae arcu non arcu cursus aliquam vitae non turpis. Integer hendrerit efficitur commodo.',
          iconText: 'L',
          count: props(context)
              .range('Long Text Count',
              Range(min: 1, max: 20, currentValue: 1),
              group: groupMainCellLong)
              .toInt(),
        )
      ],
    ),
    PropTable(
      title: Text('Main Cell Props'),
      items: [
        PropTableItem(
            name: 'Icon Text',
            description:
            'Specify a single text character to display as avatar.',
            example: MainCellAvatar(
              iconText: 'A',
            )),
        PropTableItem(name: 'Title', description: 'Title for Cell'),
        PropTableItem(name: 'Subtitle', description: 'Subtitle for Cell'),
        PropTableItem(
            name: 'Count',
            description: 'displays a counter for the cell.',
            defaultValue: '0'),
      ],
    ),
  ],
);
