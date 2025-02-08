import 'package:call_hub/global_state.dart';
import 'package:call_hub/screens/recents.dart';
import 'package:flutter/material.dart';

class KeypadScreen extends StatefulWidget {
  const KeypadScreen({super.key});

  @override
  _KeypadScreenState createState() => _KeypadScreenState();
}

class _KeypadScreenState extends State<KeypadScreen> {
  String _phoneNumber = "";

  void _onNumberPressed(String number) {
    setState(() {
      _phoneNumber += number;
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_phoneNumber.isNotEmpty) {
        _phoneNumber = _phoneNumber.substring(0, _phoneNumber.length - 1);
      }
    });
  }

  void _onClearPressed() {
    setState(() {
      _phoneNumber = "";
    });
  }

  void _onCallPressed() {
    if (_phoneNumber.isNotEmpty) {
      setState(() {
        if (recentCalls.isNotEmpty &&
            recentCalls.first.phoneNumber == _phoneNumber) {
          // If the last entry is the same, increment the count
          recentCalls.first.count += 1;
        } else {
          final index = contacts
              .indexWhere((element) => element.phoneNumber == _phoneNumber);
          final name = index != -1 ? contacts[index].name : "Unknown";
          // If it's a new contact or different from the last, add it to the top
          recentCalls.insert(
              0, RecentCall(name, _phoneNumber, CallType.outgoing, count: 1));
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Calling $_phoneNumber...')),
      );
      // Integrate actual phone call API if required
    }
  }

  Widget _buildKeypadButton(String label,
      {double size = 70, double textSize = 24}) {
    return InkWell(
      onTap: () => _onNumberPressed(label),
      onLongPress: label == "0" ? () => _onNumberPressed("+") : null,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        height: size,
        width: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[850],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          (label == "0") ? "0\n+" : label,
          style:
              TextStyle(fontSize: textSize, height: 0.9, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: SafeArea(
        child: isLandscape
            ? Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            child: Text(
                              _phoneNumber,
                              style: const TextStyle(
                                  fontSize: 32, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Keypad grid with 3 buttons in a single row
                        for (int i = 0; i < 12; i += 3)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int j = 0; j < 3; j++)
                                  if (i + j < 12)
                                    _buildKeypadButton(
                                        [
                                          "1",
                                          "2",
                                          "3",
                                          "4",
                                          "5",
                                          "6",
                                          "7",
                                          "8",
                                          "9",
                                          "*",
                                          "0",
                                          "#"
                                        ][i + j],
                                        size: 50,
                                        textSize: 20),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: IconButton(
                              onPressed: _onClearPressed,
                              icon:
                                  const Icon(Icons.delete, color: Colors.black),
                              iconSize: 32,
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: _onCallPressed,
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.call,
                                size: 28, color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: IconButton(
                              onPressed: _onDeletePressed,
                              icon: const Icon(Icons.backspace,
                                  color: Colors.black),
                              iconSize: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      child: Text(
                        _phoneNumber,
                        style:
                            const TextStyle(fontSize: 32, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Keypad grid with 3 buttons in a single row
                  for (int i = 0; i < 12; i += 3)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int j = 0; j < 3; j++)
                            if (i + j < 12)
                              _buildKeypadButton(
                                  [
                                    "1",
                                    "2",
                                    "3",
                                    "4",
                                    "5",
                                    "6",
                                    "7",
                                    "8",
                                    "9",
                                    "*",
                                    "0",
                                    "#"
                                  ][i + j],
                                  size: 70,
                                  textSize: 24),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            onPressed: _onClearPressed,
                            icon: const Icon(Icons.delete, color: Colors.black),
                            iconSize: 36,
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: _onCallPressed,
                          backgroundColor: Colors.green,
                          child: const Icon(Icons.call,
                              size: 32, color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: IconButton(
                            onPressed: _onDeletePressed,
                            icon: const Icon(Icons.backspace,
                                color: Colors.black),
                            iconSize: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
