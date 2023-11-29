import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class OfficesAndOutlets extends StatelessWidget {
  const OfficesAndOutlets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Offices and Outlets',
        actions: [],
        isAuthenticated: false,
      ),
      body: ListView(
        children: <Widget>[
          OfficeItem(
            officeName: 'Finance Office',
            officeLocation: 'B4 001',
          ),
          OfficeItem(
            officeName: 'Military Office',
            officeLocation: 'B2 017',
          ),
          OfficeItem(
            officeName: 'Travel Office',
            officeLocation: 'C7 210',
          ),
          OfficeItem(
            officeName: 'SCAD Office',
            officeLocation: 'C7 001',
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: Icon(Icons.home), onPressed: () {}),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.add_circle_outline), onPressed: () {}),
            IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class OfficeItem extends StatelessWidget {
  final String officeName;
  final String officeLocation;

  OfficeItem({required this.officeName, required this.officeLocation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  officeName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(officeLocation),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Get directions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
