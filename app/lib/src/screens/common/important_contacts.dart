import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/ImportantEmail.dart';
import 'package:GUConnect/src/models/ImportantPhoneNumber.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/ImportantEmailProvider.dart';
import 'package:GUConnect/src/providers/ImportantPhoneNumberProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ImportantContactsScreen extends StatefulWidget {
  const ImportantContactsScreen({super.key});

  @override
  State<ImportantContactsScreen> createState() =>
      _ImportantContactsScreenState();
}

class _ImportantContactsScreenState extends State<ImportantContactsScreen>
    with SingleTickerProviderStateMixin {
  late List<ImportantPhoneNumber> impPhoneNumbers = [];
  late List<ImportantPhoneNumber> impPhoneNumbersDisplay = [];

  late List<ImportantEmail> impEmails = [];
  late List<ImportantEmail> impEmailsDisplay = [];

  late final TextEditingController _searchController = TextEditingController();

  late TabController _tabController;

  bool _isLoading = false;

  late ImportantEmailProvider importantEmailProvider;
  late ImportantPhoneNumberProvider importantPhoneNumberProvider;

  @override
  void initState() {
    super.initState();

    importantEmailProvider =
        Provider.of<ImportantEmailProvider>(context, listen: false);
    importantPhoneNumberProvider =
        Provider.of<ImportantPhoneNumberProvider>(context, listen: false);

    fetchContact(importantEmailProvider, importantPhoneNumberProvider)
        .then((value) => setState(() {
              _isLoading = false;
            }));

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  Future fetchContact(ImportantEmailProvider importantEmailProvider,
      ImportantPhoneNumberProvider importantPhoneNumberProvider) async {
    setState(() {
      _isLoading = true;
    });

    final List<ImportantEmail> emailsList =
        await importantEmailProvider.getEmails();

    final List<ImportantPhoneNumber> numbersList =
        await importantPhoneNumberProvider.getNumbers();

    setState(() {
      impEmails = emailsList;
      impEmailsDisplay = emailsList;

      impPhoneNumbers = numbersList;
      impPhoneNumbersDisplay = numbersList;

      _isLoading = false;
    });
  }

  Future fetchPhoneNumbers() async {
    setState(() {
      _isLoading = true;
    });

    final List<ImportantPhoneNumber> tempImpPhoneNumbers =
        await importantPhoneNumberProvider.getNumbers();

    setState(() {
      _isLoading = false;
      impPhoneNumbers = tempImpPhoneNumbers;
      impPhoneNumbersDisplay = tempImpPhoneNumbers;
    });
  }

  Future fetchEmails() async {
    setState(() {
      _isLoading = true;
    });

    final List<ImportantEmail> tempEmails =
        await importantEmailProvider.getEmails();

    setState(() {
      _isLoading = false;
      impEmails = tempEmails;
      impEmailsDisplay = tempEmails;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Contacts',
          labelText: 'Search Contacts',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          filterContacts(value);
        },
        controller: _searchController,
      ),
    );
  }

  void filterContacts(String value) {
    value = value.trim().toLowerCase();
    setState(() {
      _searchController.text = value;

      impPhoneNumbersDisplay = [];
      impPhoneNumbersDisplay.addAll(impPhoneNumbers
          .where((element) => (element.title).toLowerCase().contains(value))
          .toList());
      impEmailsDisplay = [];
      impEmailsDisplay.addAll(impEmails
          .where((element) => (element.title).toLowerCase().contains(value))
          .toList());
    });
  }

  Widget _buildPhoneNumbers() {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await fetchPhoneNumbers();
        filterContacts(_searchController.text);
        setState(() {
          _isLoading = false;
        });
      },
      child: _isLoading
          ? const Loader()
          : impPhoneNumbersDisplay.isEmpty
              ? Center(
                  child: Text(
                  'No phone numbers found',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.secondary),
                ))
              : ListView.builder(
                  key: const PageStorageKey('phoneNumbers'),
                  scrollDirection: Axis.vertical,
                  itemCount: impPhoneNumbersDisplay.length,
                  itemBuilder: (context, index) {
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
                          impPhoneNumbersDisplay[index].title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          impPhoneNumbersDisplay[index].phoneNumber,
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.call),
                          onPressed: () async {
                            await FlutterPhoneDirectCaller.callNumber(
                                impPhoneNumbersDisplay[index].phoneNumber);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmails() {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await fetchEmails();

        filterContacts(_searchController.text);
        setState(() {
          _isLoading = false;
        });
      },
      child: _isLoading
          ? const Loader()
          : impEmailsDisplay.isEmpty
              ? Center(
                  child: Text(
                    'No Emails found',
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                )
              : ListView.builder(
                  key: const PageStorageKey('emails'),
                  scrollDirection: Axis.vertical,
                  itemCount: impEmailsDisplay.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        title: Text(
                          impEmailsDisplay[index].title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          impEmailsDisplay[index].email,
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.email),
                          onPressed: () async {
                            final String email = Uri.encodeComponent(
                                impEmailsDisplay[index].email);
                            final String subject =
                                Uri.encodeComponent('I need help');
                            final String body = Uri.encodeComponent('');
                            final Uri mail = Uri.parse(
                                'mailto:$email?subject=$subject&body=$body');
                            if (await launchUrl(mail)) {
                              // email app opened
                            } else {
                              // alert dialog  appears something went wrong

                              // ignore: use_build_context_synchronously
                              showAdaptiveDialog(
                                  context: context,
                                  anchorPoint: const Offset(0.0, 0.0),
                                  builder: (context) {
                                    return MessageDialog(
                                      title:
                                          'Something went wrong , with your email app',
                                      message: 'Please try again later',
                                      onCancel: () {},
                                    );
                                  });
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppBar(
        title: 'Important Contacts',
        isLogo: false,
        actions: [
          if (userProvider.user?.userType == UserType.admin)
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, CustomRoutes.addImportantContacts);
                },
                icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Phone Numbers'),
              Tab(text: 'Emails'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPhoneNumbers(),
                _buildEmails(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
