import 'package:example/title_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

StoryBookPage buildTextStylePage() => StoryBookPage.list(
      title: 'Text Style Widgets',
      widgets: (context) => [
        ExpandableWidgetSection(
            initiallyExpanded: true,
            title: 'Header 1',
            children: [mainTitle('H1')]),
        ExpandableWidgetSection(
            initiallyExpanded: true,
            title: 'Other Headers',
            children: <Widget>[
              subTitle('H2'),
              h3('H3'),
            ]),
        ExpandableWidgetSection(
          title: 'Body Content',
          subtitle: 'This is content most used in decriptions',
          children: [
            body("""
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce suscipit iaculis velit, et ornare diam. Etiam molestie purus nec mollis malesuada. Etiam luctus, dolor eget mattis posuere, mauris turpis ullamcorper dolor, quis maximus ante erat ullamcorper tellus. Quisque sem tellus, interdum quis turpis sit amet, accumsan aliquet mi. Aliquam feugiat sapien sit amet metus tristique aliquet. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque dignissim quam id augue efficitur varius. Phasellus sed arcu a nibh cursus fringilla blandit ac purus. Fusce diam erat, tristique eget venenatis a, gravida quis metus.

Curabitur viverra, leo et mollis gravida, arcu diam iaculis turpis, ac sollicitudin magna ipsum nec dolor. Fusce a porttitor nisl, ut tempor quam. Nam quis lorem magna. Phasellus facilisis laoreet varius. Nullam eget leo sit amet enim faucibus euismod. Nullam tempus diam et velit eleifend, eu eleifend arcu tristique. Ut vitae luctus leo. Suspendisse aliquam velit nibh, eget scelerisque tellus condimentum vitae. Quisque pharetra iaculis suscipit.

Nunc ac pulvinar nunc. Sed blandit mauris sed aliquam lobortis. Vivamus viverra mauris diam, vel dignissim ante ultrices et. Curabitur congue fermentum dolor, eget vestibulum ligula dignissim facilisis. Etiam tortor felis, cursus eget tortor nec, molestie facilisis nunc. Suspendisse elementum venenatis justo a blandit. Maecenas molestie eros sed mauris auctor, nec imperdiet sem feugiat. Fusce dignissim cursus fermentum. Curabitur in nisi nisi. In auctor, nibh eu pretium fringilla, metus erat tempor augue, sagittis facilisis quam erat sit amet ante. Aliquam tincidunt enim in augue tempor vulputate. Quisque tincidunt erat non nisi mattis convallis. In tellus sem, elementum eu libero vitae, iaculis ullamcorper sem. Aenean luctus neque eu enim porttitor lacinia. Ut tempor egestas enim, nec fringilla mauris sollicitudin sed.
                        """)
          ],
        ),
      ],
    );
