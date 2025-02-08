import 'package:call_hub/screens/contacts.dart';
import 'package:call_hub/screens/recents.dart';

// Declare globally accessible recentCalls list
List<RecentCall> recentCalls = [
  RecentCall("Charlie Davis", "5551234567", CallType.outgoing, count: 1),
  RecentCall("Alice Johnson", "923567890", CallType.outgoing, count: 1),
  RecentCall("Unknown", "9234567534", CallType.outgoing, count: 1),
];

List<Contact> contacts = [
  Contact("Alice Johnson", "923567890"),
  Contact("Bob Smith", "9876543210"),
  Contact("Charlie Davis", "5551234567"),
  Contact("Diana Williams", "4449876543"),
];
