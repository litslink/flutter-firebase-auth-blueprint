import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/notes/mini_profile_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/profile/preview/profile_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/profile/preview/profile_widget.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/notes_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/settings_repository.dart';
import 'package:provider/provider.dart';
import 'notes/notes_bloc.dart';
import 'notes/notes_widget.dart';

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
    final notesRepository = Provider.of<NotesRepository>(context);
    final authRepository = Provider.of<AuthRepository>(context);
    final settingsRepository = Provider.of<SettingsRepository>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotesBloc(notesRepository, authRepository),
        ),
        BlocProvider(
          create: (_) => ProfileBloc(authRepository, settingsRepository),
        ),
        BlocProvider(
          create: (_) => MiniProfileBloc(authRepository),
        )
      ],
      child: Scaffold(
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
      ),
    );
  }
}
