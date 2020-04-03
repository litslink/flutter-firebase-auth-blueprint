import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/notes_widget.dart';
import '../profile/preview/profile_widget.dart';

class HomeWidget extends StatefulWidget {
  static final String route = '/home';

  @override
  State<StatefulWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 0;

  final _pages = {
    0: NotesWidget(),
    1: ProfileWidget()
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) => _pages[index] ?? NotesWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _getPage(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            title: Text('Notes'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
