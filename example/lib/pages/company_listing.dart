import 'package:example/pages/person_detail.dart';
import 'package:example/widgets/cells.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CompanyListing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Listing'),
      ),
      body: MainCellList(
        items: [
          MainCellItem("A", "Andrew Grosner", "I am a developer.", 10),
          MainCellItem("B", "Benjamin Button", "I am getting younger by the day", 50),
        ],
        onTap: (item) => Navigator.of(context).pushNamed('/detail',
            arguments: PersonDetailArguments(
              item,
            )),
      ),
    );
  }
}
