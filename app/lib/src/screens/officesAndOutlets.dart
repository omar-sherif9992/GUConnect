import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/dummy_data/OfficeItems.dart';
import 'package:url_launcher/url_launcher.dart';

class OfficesAndOutlets extends StatefulWidget {
  const OfficesAndOutlets({super.key});

  @override
  State<OfficesAndOutlets> createState() => _OfficesAndOutletsState();
}

class _OfficesAndOutletsState extends State<OfficesAndOutlets>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<OfficeItem> offices = dummy_offices;
  List<OfficeItem> outlets = dummy_outlets;

  late final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Offices and Outlets',
        actions: [],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Offices',
              ),
              Tab(text: 'Outlets'),
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
    return ListView(children: outlets);
  }

  Widget _buildOffices() {
    return ListView(children: offices);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Offices/Outlets',
          labelText: 'Search Offices/Outlets',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          filterOfficesAndOutlets(value);
        },
        controller: _searchController,
      ),
    );
  }

  void filterOfficesAndOutlets(String value) {
    value = value.trim().toLowerCase();
    setState(() {
      _searchController.text = value;

      offices = [];
      offices.addAll(dummy_offices
          .where(
              (element) => (element.officeName).toLowerCase().contains(value))
          .toList());
      outlets = [];
      outlets.addAll(dummy_outlets
          .where(
              (element) => (element.officeName).toLowerCase().contains(value))
          .toList());
    });
  }
}

class OfficeItem extends StatelessWidget {
  final String officeName;
  final String officeLocation;
  final double latitude;
  final double longitude;

  OfficeItem(
      {required this.officeName,
      required this.officeLocation,
      required this.latitude,
      required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        title: Text(
          officeName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          officeLocation,
          style: TextStyle(
              fontSize: 16, color: Theme.of(context).colorScheme.secondary),
        ),
        trailing: Text(
          "Directons",
          style: TextStyle(fontSize: 14),
        ),
        onTap: () async {
          () => _launchGoogleMaps(latitude, longitude);
        },
      ),
    );
  }

  _launchGoogleMaps(double latitude, double longitude) async {
    // Construct the Google Maps URL with the specified latitude and longitude
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    // Check if the URL can be launched
    if (await canLaunchUrl(url)) {
      // Launch the URL
      await launchUrl(url);
    } else {
      // Handle error, e.g., show an alert
      throw 'Could not launch $url';
    }
  }
}
