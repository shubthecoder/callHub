import 'package:flutter/material.dart'; // modify this to have
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:call_hub/global_state.dart';
import 'recents.dart' show RecentCall, CallType;

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> filteredContacts = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sortAndFilterContacts();
  }

  void _sortAndFilterContacts() {
    contacts
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    _filterContacts(searchController.text);
  }

  void _filterContacts(String query) {
    setState(() {
      filteredContacts = contacts
          .where((contact) =>
              contact.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _editContact(int index) {
    final contact = contacts[index];
    final nameController = TextEditingController(text: contact.name);
    final phoneController = TextEditingController(text: contact.phoneNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Name and Phone Number cannot be empty.')));
                  return;
                }

                if (contacts.any((c) =>
                    c.phoneNumber == phoneController.text &&
                    contacts[index] != c)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Phone number already exists.')));
                  return;
                }

                setState(() {
                  contacts[index] = Contact(
                    nameController.text,
                    phoneController.text,
                  );
                  _sortAndFilterContacts();
                });
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _addContact() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: "Phone Number"),
                  keyboardType: TextInputType.phone),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    phoneController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Name and Phone Number cannot be empty.')));
                  return;
                }

                if (contacts
                    .any((c) => c.phoneNumber == phoneController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Phone number already exists.')));
                  return;
                }

                setState(() {
                  contacts.add(Contact(
                    nameController.text,
                    phoneController.text,
                  ));
                  _sortAndFilterContacts();
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<Widget> _loadAvatar(String name) async {
    final url =
        'https://ui-avatars.com/api/?format=svg&bold=true&name=$name&size=100&rounded=true';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return SvgPicture.string(response.body, fit: BoxFit.cover);
      }
    } catch (e) {
      debugPrint("Failed to load avatar: $e");
    }

    return Icon(
      Icons.person,
      color: Colors.blueAccent,
      size: 24,
    );
  }

  void _callContact(String name, String phoneNumber) {
    setState(() {
      print(recentCalls.length);
      if (recentCalls.isNotEmpty &&
          recentCalls.first.phoneNumber == phoneNumber) {
        // If the last entry is the same, increment the count
        recentCalls.first.count += 1;
      } else {
        // If it's a new contact or different from the last, add it to the top
        recentCalls.insert(
            0, RecentCall(name, phoneNumber, CallType.outgoing, count: 1));
      }
      print(recentCalls.length);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $phoneNumber...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search Contacts...",
            hintStyle: TextStyle(color: Colors.black54),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black),
          onChanged: _filterContacts,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: _addContact,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: filteredContacts.length,
          itemBuilder: (context, index) {
            final contact = filteredContacts[index];
            return ListTile(
              leading: FutureBuilder<Widget>(
                future: _loadAvatar(contact.name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.transparent,
                      child: snapshot.data,
                    );
                  } else {
                    return CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    );
                  }
                },
              ),
              title: Text(
                contact.name,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              subtitle: Text(
                contact.phoneNumber,
                style: const TextStyle(color: Colors.black54),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () => _editContact(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.call, color: Colors.green),
                    onPressed: () =>
                        _callContact(contact.name, contact.phoneNumber),
                  ),
                ],
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

class Contact {
  final String name;
  final String phoneNumber;

  Contact(this.name, this.phoneNumber);
}
