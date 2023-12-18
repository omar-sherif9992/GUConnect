import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/OfficeAndLocation.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/OfficeLocationProvider.dart';
import 'package:GUConnect/src/providers/UsabilityProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/screens/admin/set_office_screen.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OfficesAndOutlets extends StatefulWidget {
  const OfficesAndOutlets({super.key});

  @override
  State<OfficesAndOutlets> createState() => _OfficesAndOutletsState();
}

class _OfficesAndOutletsState extends State<OfficesAndOutlets>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<OfficeAndLocation> offices = [];
  List<OfficeAndLocation> officesDisplay = [];
  List<OfficeAndLocation> outlets = [];
  List<OfficeAndLocation> outletsDisplay = [];
  late OfficeLocationProvider officeLocationProvider;
  late final TextEditingController _searchController = TextEditingController();
  late UserProvider userProvider;
  late UsabilityProvider usabilityProvider;
  

  bool _isLoading = false;
  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    if (user == null) {
      Navigator.popAndPushNamed(context, CustomRoutes.home);
      return const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Offices and Outlets',
        actions: [
          if (user.userType == UserType.admin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SetOfficeAndLocationScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      floatingActionButton: user.userType == UserType.admin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SetOfficeAndLocationScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
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
    officeLocationProvider = OfficeLocationProvider();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    usabilityProvider = Provider.of<UsabilityProvider>(context, listen: false);
    fetchOfficesAndOutlets(officeLocationProvider).then((value) => {
          setState(() {
            _isLoading = false;
          })
        });
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  Widget _buildOutlets() {
    return RefreshIndicator.adaptive(
        onRefresh: () async {
          await fetchOfficesAndOutlets(officeLocationProvider);
          setState(() {
            _isLoading = false;
          });
        },
        child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            usabilityProvider.logEvent(userProvider.user!.email, 'Scrolling_Up_In_Outlets');           
          } else if (notification.direction == ScrollDirection.reverse) {
            usabilityProvider.logEvent(userProvider.user!.email, 'Scrolling_Down_In_Outlets');
          }
          return false; // Return false to allow the notification to continue to be dispatched.
        },
        child: ListView(
            children: outlets.map((e) => buildOfficeItem(e)).toList())));
  }

  Widget _buildOffices() {
    return RefreshIndicator.adaptive(
        onRefresh: () async {
          await fetchOfficesAndOutlets(officeLocationProvider);
          setState(() {
            _isLoading = false;
          });
        },
        child:  NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            usabilityProvider.logEvent(userProvider.user!.email, 'Scrolling_Up_In_Offices');           
          } else if (notification.direction == ScrollDirection.reverse) {
            usabilityProvider.logEvent(userProvider.user!.email, 'Scrolling_Down_In_Offices');
          }
          return false; // Return false to allow the notification to continue to be dispatched.
        },
        child:ListView(
            children: offices.map((e) => buildOfficeItem(e)).toList())));
  }

  Widget buildOfficeItem(OfficeAndLocation office) {
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
          office.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          office.location,
          style: TextStyle(
              fontSize: 16, color: Theme.of(context).colorScheme.secondary),
        ),
        trailing: TextButton(
          child: const Text(
            'Directions',
            style: TextStyle(fontSize: 14),
          ),
          onPressed: () async {
            openMap(office.latitude, office.longitude);
          },
        ),
      ),
    );
  }

  static Future<void> openMap(double latitude, double longitude) async {
    final String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final Uri googleUri = Uri.parse(googleUrl);
    if (!await launchUrl(googleUri)) {
      throw Exception('Could not launch $googleUri');
    }
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

      officesDisplay = [];
      officesDisplay.addAll(offices
          .where((element) => (element.name).toLowerCase().contains(value))
          .toList());
      outletsDisplay = [];
      outletsDisplay.addAll(outlets
          .where((element) => (element.name).toLowerCase().contains(value))
          .toList());
    });
  }

  Future<void> fetchOfficesAndOutlets(
      OfficeLocationProvider officeLocationProvider) async {
    setState(() {
      _isLoading = true;
    });
    officeLocationProvider.getOffices().then((value) => {
          setState(() {
            offices = value;
            officesDisplay = value;
          })
        });
    officeLocationProvider.getOutlets().then((value) => {
          setState(() {
            outlets = value;
            outletsDisplay = value;
          })
        });
    filterOfficesAndOutlets(_searchController.text);
  }
}

class OfficeItem extends StatelessWidget {
  final String name;
  final String location;
  final double latitude;
  final double longitude;

  const OfficeItem(
      {super.key,
      required this.name,
      required this.location,
      required this.latitude,
      required this.longitude});

  @override
  Widget build(BuildContext context) {
    return buildOfficeItem(context);
  }

  Widget buildOfficeItem(BuildContext context) {
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
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          location,
          style: TextStyle(
              fontSize: 16, color: Theme.of(context).colorScheme.secondary),
        ),
        trailing: TextButton(
          child: const Text(
            'Directions',
            style: TextStyle(fontSize: 14),
          ),
          onPressed: () async {
            openMap(latitude, longitude);
          },
        ),
      ),
    );
  }

  static Future<void> openMap(double latitude, double longitude) async {
    final String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final Uri googleUri = Uri.parse(googleUrl);
    if (!await launchUrl(googleUri)) {
      throw Exception('Could not launch $googleUri');
    }
  }
}
