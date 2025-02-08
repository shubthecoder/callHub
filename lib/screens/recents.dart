import 'package:flutter/material.dart';
import 'package:call_hub/global_state.dart'; // Import the shared state

class RecentScreen extends StatefulWidget {
  const RecentScreen({super.key});

  @override
  _RecentScreenState createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  void _callContact(String name, String phoneNumber) {
    setState(() {
      if (recentCalls.isNotEmpty &&
          recentCalls.first.phoneNumber == phoneNumber) {
        // If the last entry is the same, increment the count
        recentCalls.first.count += 1;
      } else {
        // If it's a new contact or different from the last, add it to the top
        recentCalls.insert(
            0, RecentCall(name, phoneNumber, CallType.outgoing, count: 1));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $phoneNumber...')),
    );
  }

  Widget _buildCallTypeIcon(CallType callType) {
    return Icon(
      callType == CallType.outgoing ? Icons.call_made : Icons.call_received,
      color: callType == CallType.outgoing ? Colors.green : Colors.blueAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: recentCalls.length,
          itemBuilder: (context, index) {
            final call = recentCalls[index];
            return ListTile(
              leading: _buildCallTypeIcon(call.callType),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      call.name == "Unknown" ? call.phoneNumber : call.name,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  if (call.count > 1)
                    Text(
                      "(${call.count})",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                ],
              ),
              subtitle: call.name == "Unknown"
                  ? null
                  : Text(
                      call.phoneNumber,
                      style: const TextStyle(color: Colors.black54),
                    ),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                onPressed: () => _callContact(call.name, call.phoneNumber),
              ),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            color: Colors.grey,
            thickness: 1,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class RecentCall {
  final String name;
  final String phoneNumber;
  final CallType callType;
  int count;

  RecentCall(this.name, this.phoneNumber, this.callType, {this.count = 1});
}

enum CallType { incoming, outgoing }
