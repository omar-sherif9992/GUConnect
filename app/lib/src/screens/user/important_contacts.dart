import 'package:GUConnect/src/dummy_data/importantEmails.dart';
import 'package:GUConnect/src/dummy_data/importantNumbers.dart';
import 'package:GUConnect/src/models/ImportantEmail.dart';
import 'package:GUConnect/src/models/ImportantPhoneNumber.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class ImportantContactsScreen extends StatefulWidget {
  const ImportantContactsScreen({super.key});

  @override
  State<ImportantContactsScreen> createState() =>
      _ImportantContactsScreenState();
}

class _ImportantContactsScreenState extends State<ImportantContactsScreen>
    with SingleTickerProviderStateMixin {
  late List<ImportantPhoneNumber> impPhoneNumbers;
  late List<ImportantPhoneNumber> impPhoneNumbersDisplay;

  late List<ImportantEmail> impEmails;
  late List<ImportantEmail> impEmailsDisplay;

  late TextEditingController _searchController = TextEditingController();

  late TabController _tabController;

  final bool _isLoading = false;

  @override
  void initState() {
    // TODO: request phone numbers and emails
    impPhoneNumbers = dummy_phone_numbers;
    impPhoneNumbersDisplay = dummy_phone_numbers;

    impEmails = dummy_emails;
    impEmailsDisplay = dummy_emails;

    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText:
          'Search Contacts',
          labelText:  'Search Contacts',
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
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: request phone numbers
        filterContacts(_searchController.text);
      },
      child: impPhoneNumbersDisplay.isEmpty
          ? Center(
              child: Text(
              'No phone numbers found',
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).colorScheme.secondary),
            ))
          : ListView.builder(
              itemCount: impPhoneNumbersDisplay.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(impPhoneNumbersDisplay[index].title),
                  subtitle: Text(impPhoneNumbersDisplay[index].phoneNumber),
                  trailing: const Icon(Icons.call),
                  onTap: () async {
                    await FlutterPhoneDirectCaller.callNumber(
                        impPhoneNumbersDisplay[index].phoneNumber);
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmails() {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: request emails

        filterContacts(_searchController.text);
      },
      child:impEmailsDisplay.isEmpty
          ? Center(
              child: Text(
              'No Emails found',
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).colorScheme.secondary),
            ))
          : ListView.builder(
        itemCount: impEmailsDisplay.length,
        itemBuilder: (context, index) {
          ListTile(
            title: Text(impEmailsDisplay[index].title),
            subtitle: Text(impEmailsDisplay[index].email),
            trailing: const Icon(Icons.email),
            onTap: () async {
              final String email =
                  Uri.encodeComponent(impEmailsDisplay[index].email);
              final String subject = Uri.encodeComponent('I need help');
              final String body = Uri.encodeComponent('');
              final Uri mail =
                  Uri.parse('mailto:$email?subject=$subject&body=$body');
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
                        title: 'Something went wrong , with your email app',
                        message: 'Please try again later',
                        onCancel: () {},
                      );
                    });
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Important Contacts',
        isLogo: false,
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
