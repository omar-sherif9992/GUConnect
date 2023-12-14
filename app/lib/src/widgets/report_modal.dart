import 'package:GUConnect/src/models/Reports.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/ReportsProvider.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class ReportModal extends StatefulWidget {

  final String reportedId;
  final CustomUser reportedUser;
  final String reportedContent;
  final int reportCollectionNameType;
  final DateTime createdAt;
  final String image;

  @override
  State<ReportModal> createState() => _ReportModalState();


  const ReportModal({super.key, required this.reportedId, required this.reportedUser, required this.reportedContent, required this.reportCollectionNameType,
  required this.image, required this.createdAt});
}
  class _ReportModalState extends State<ReportModal>
  {
      late ReportsProvider reportProvider; 

      @override
      void initState()
      {
        super.initState();
        reportProvider = Provider.of<ReportsProvider>(context, listen :false);
      }
      String selectedReason = ReportReason.InappropriateContent.toString().split('.').last;
      final TextEditingController clarificationController =
            TextEditingController();

      
      String getCollectionName(int value)
      {
        switch (value) {
        case 0:
          return 'newsEventClubs';
        case 1:
          return 'lostAndFound';
        case 2:
          return 'academicRelatedQuestions';
        case 3:
          return 'confessions';

        default:
          return 'Unknown';
        } 
      }

      void submitReprot(String reason, String clarification)
      { 

        showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Loader(),
              SizedBox(height: 16),
              Text('Submittion your report...'),
            ],
          ),
        );
      },
    );

        final Report submittedReport = Report(reportedContentId: widget.reportedId, reportedUser: widget.reportedUser, reportedContent: widget.reportedContent, 
        reportType: getCollectionName(widget.reportCollectionNameType), createdAt: widget.createdAt, reason: reason, clarification: clarification);

        reportProvider.reportContent(submittedReport).then((value) {
          Navigator.pop(context);
          if (value)
            {
              Navigator.of(context).pop();
            }
          else
            {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content:
                        const Text('Failed to upload post. Please try again.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
        });

      }

      @override
      Widget build(context) {
        
        return AlertDialog(
            alignment: Alignment.center,
            backgroundColor: Colors.white,
            content: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'They will never know',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const Text('Select Report Type:'),
                    DropdownButton<String>(
                      value: selectedReason.toString().split('.').last,
                      onChanged: (String? value) {
                        setState((){
                          selectedReason = value??selectedReason;
                        });
                      },
                      items: ReportReason.values.map((ReportReason type) {
                        return DropdownMenuItem<String>(
                          value: type.toString().split('.').last,
                          child: Text(
                            type.toString().split('.').last,
                            style: const TextStyle(
                              color: Colors.black, // Set the text color to be easily visible
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Clarification:'),
                    TextFormField(
                      controller: clarificationController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Enter additional details (optional)',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Handle the report submission here
                        //_submitReport();
                        submitReprot(selectedReason, clarificationController.text);
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ));
      }
}
enum ReportReason {
  InappropriateContent,
  Spam,
  Harassment,
  Other,
}