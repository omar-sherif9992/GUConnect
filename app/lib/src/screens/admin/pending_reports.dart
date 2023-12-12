import 'package:GUConnect/src/models/Reports.dart';
import 'package:GUConnect/src/screens/admin/Report_content.dart';
import 'package:flutter/material.dart';

import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/ReportsProvider.dart';

import 'package:GUConnect/src/utils/titleCase.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:provider/provider.dart';

class PendingReportsScreen extends StatefulWidget {
  const PendingReportsScreen({super.key});

  @override
  State<PendingReportsScreen> createState() => _PendingReportsScreenState();
}

class _PendingReportsScreenState extends State<PendingReportsScreen> {
  List<Report> reports = [];
  List<Report> reportsDisplay = [];

  bool _isLoading = false;

  late ReportsProvider reportsProvider;

  String _selectFilter = 'Confessions';
  @override
  void initState() {
    super.initState();

    reportsProvider = Provider.of<ReportsProvider>(context, listen: false);

    // for (int i = 0; i < 5; i++) {
    //   reportsProvider.reportContent(Report(
    //       reportedContent: 'I hate you $i',
    //       reportedUser: CustomUser(
    //         fullName: 'Ahmed$i',
    //         email: 'omar$i@student.guc.edu.eg',
    //         password: '',
    //         userName: 'omar$i.kaa',
    //       ),
    //       reportedContentId: i.toString(),
    //       reportType: i % 2 == 0 ? 'confession' : 'comment',
    //       createdAt: DateTime.now()));
    // }

    fetchItems();
  }

  Future fetchItems() async {
    setState(() {
      _isLoading = true;
    });
    reportsProvider.getConfessionReports().then((value) => setState(() {
          reports = value;
          reportsDisplay = value;
          _isLoading = false;
        }));
  }

  Widget _buildSelectFilter() {
    reportsProvider = Provider.of<ReportsProvider>(context, listen: false);

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: ToggleButtons(
            direction: Axis.horizontal,
            borderRadius: BorderRadius.circular(10),
            borderWidth: 2,
            key: const PageStorageKey('pending_reports_select_filter'),
            onPressed: (int index) async {
              setState(() {
                _selectFilter = ['Confessions', 'Posts','Comments'][index];
              });
              if (_selectFilter == 'Confessions') {
                _isLoading = true;
                reportsProvider
                    .getConfessionReports()
                    .then((value) => setState(() {
                          reports = value;
                          reportsDisplay = value;
                          _isLoading = false;
                        }));
              } else if(_selectFilter == 'Comments') {
                _isLoading = true;
                reportsProvider
                    .getCommentReports()
                    .then((value) => setState(() {
                          reports = value;
                          reportsDisplay = value;
                          _isLoading = false;
                        }));
              }
              else {
                reports=[] ;
                reportsDisplay = [];
                // _isLoading = true;
                // reportsProvider
                //     .getPostReports()
                //     .then((value) => setState(() {
                //           reports = value;
                //           reportsDisplay = value;
                //           _isLoading = false;
                //         }));
              }
            },
            isSelected: [
              _selectFilter == 'Confessions',
              _selectFilter == 'Posts',
              _selectFilter == 'Comments',
            ],
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Confessions',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Posts',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Comments',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildReports() {
    return _isLoading
        ? const Loader()
        : reports.isEmpty
            ? Center(
                child: Text(
                'No Reports found',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary),
              ))
            : RefreshIndicator(
                onRefresh: () async {
                  reportsDisplay = reports;
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: ListView.builder(
                  itemCount: reportsDisplay.length,
                  key: const PageStorageKey('pending_reports'),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(reportsDisplay[index].id),
                      onDismissed: (direction) {
                        if (direction.index == 2) {
                          reportsProvider.approveReport(reportsDisplay[index]);
                        } else if (direction.index == 3) {
                          reportsProvider
                              .disapproveReport(reportsDisplay[index]);
                        }
                        setState(() {
                          reportsDisplay.removeAt(index);
                        });
                      },
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.disabled_by_default),
                      ),
                      secondaryBackground: Container(
                        color: Colors.green,
                        child: const Icon(Icons.check),
                      ),
                      child: ReportCard(
                        report: reportsDisplay[index],
                        user: reportsDisplay[index].reportedUser,
                        onTap: (Report post, bool decision) async {
                          if (decision) {
                            await reportsProvider
                                .approveReport(reportsDisplay[index]);
                          } else {
                            await reportsProvider
                                .disapproveReport(reportsDisplay[index]);
                          }
                          setState(() {
                            reports.removeWhere((element) =>
                                element.id == reportsDisplay[index].id);
                          });
                        },
                      ),
                    );
                  },
                ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const BottomBar(),
        drawer: const MainDrawer(),
        appBar: const CustomAppBar(
          title: 'Pending reports',
          isLogo: false,
        ),
        body: Column(
          children: [
            _buildSelectFilter(),
            Expanded(
              child: _buildReports(),
            ),
          ],
        ));
  }
}

class ReportCard extends StatelessWidget {
  final Report report;
  final CustomUser user;
  final Function(Report, bool) onTap;

  const ReportCard(
      {super.key,
      required this.report,
      required this.onTap,
      required this.user});

  // format date function
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

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
        leading: Hero(
          tag: report.id,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              foregroundImage: user.image == null || user.image == ''
                  ? NetworkImage(user.image ?? '')
                  : null,
              backgroundImage: const AssetImage('assets/images/user.png'),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titleCase(user.fullName ?? ''),
            ),
          ],
        ),
        subtitle: Text('${report.createdAt.year}-${_twoDigits(report.createdAt.month)}-${_twoDigits(report.createdAt.day)} ${_twoDigits12hr(report.createdAt.hour)}:${_twoDigits(report.createdAt.minute)} ${_amPm(report.createdAt.hour)}'),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios,color: Colors.orange),
          onPressed: () async {
            final bool decision = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReportContentScreen(
                  report: report,
                ),
                maintainState: false,
              ),
            );
            if (decision == null) return;

            onTap(report, decision);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(decision ? 'Report Approved, Reported content is deleted.' : 'Report Disapproved'),
              ),
            );
          },
        ),
      ),
    );
  }
  String _twoDigits(int n) => n.toString().padLeft(2, '0');
String _twoDigits12hr(int n) => n == 0 ? '12' : _twoDigits(n > 12 ? n - 12 : n);
String _amPm(int n) => n >= 12 ? 'PM' : 'AM';

}
