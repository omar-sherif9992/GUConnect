import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class OfficesAndOutlets extends StatefulWidget {
  const OfficesAndOutlets({super.key});

  @override
  State<OfficesAndOutlets> createState() => _OfficesAndOutletsState();
}

class _OfficesAndOutletsState extends State<OfficesAndOutlets>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Offices and Outlets',
        actions: [],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Phone Numbers',
              ),
              Tab(text: 'Emails'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOffices(),
                _buildOutlets(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  Widget _buildOutlets() {
    return ListView(
      children: <Widget>[
        OfficeItem(
          officeName: '3am Saad',
          officeLocation: 'under platform',
        ),
        OfficeItem(
          officeName: 'Arabiata',
          officeLocation: 'beside the B',
        ),
        OfficeItem(
          officeName: 'L\'aroma',
          officeLocation: 'Platform',
        ),
        OfficeItem(
          officeName: 'Friends caffee',
          officeLocation: 'Platform',
        ),
      ],
    );
  }

  Widget _buildOffices() {
    return ListView(
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(officeLocation),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: const Text(
                'Get directions',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
