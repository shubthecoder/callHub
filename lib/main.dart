import 'package:call_hub/screens/contacts.dart';
import 'package:call_hub/screens/keypad.dart';
import 'package:call_hub/screens/recents.dart';
import 'package:flutter/material.dart';
// import 'global_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontFamily: 'FontMain'),
          headlineLarge: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'FontMain'),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs: Keypad, Recent, Contacts
      child: Scaffold(
        appBar: AppBar(
          // title: const Text('Dialer App'),
          toolbarHeight: 0,
          bottom: const TabBar(
            indicatorColor: Colors.blueAccent,
            tabs: [
              Tab(icon: Icon(Icons.dialpad), text: "Keypad"),
              Tab(icon: Icon(Icons.history), text: "Recent"),
              Tab(icon: Icon(Icons.contacts), text: "Contacts"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            KeypadScreen(),
            RecentScreen(),
            ContactsScreen(),
          ],
        ),
      ),
    );
  }
}
