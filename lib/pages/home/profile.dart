import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sql_treino/services/RAM.dart';
import 'package:sql_treino/services/themenotifier.dart';
import 'package:sql_treino/shared/themes.dart' as Themes;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDark = false;

  Widget darkModeSwitch(ThemeChanger changer) {
    return FlutterSwitch(
      width: 75,
      height: 40,
      toggleSize: 25,
      value: _isDark,
      borderRadius: 30.0,
      padding: 2.0,
      activeToggleColor: Color(0xFF6E40C9),
      inactiveToggleColor: Color(0xFF2F363D),
      activeSwitchBorder: Border.all(
        color: Color(0xFF8970B9),
        width: 6.0,
      ),
      inactiveSwitchBorder: Border.all(
        color: Color(0xFFD1D5DA),
        width: 6.0,
      ),
      activeColor: Color(0xFF271052),
      inactiveColor: Colors.white,
      activeIcon: Icon(
        Icons.nightlight_round,
        color: Color(0xFFF8E3A1),
      ),
      inactiveIcon: Icon(
        Icons.wb_sunny,
        color: Color(0xFFFFDF5D),
      ),
      onToggle: (value) {
        setState(() {
          _isDark = value;
        });
        RAM.write("darkTheme", value.toString());
        changer.setTheme(value ? Themes.dark : Themes.light);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    _isDark = _themeChanger.getTheme() == Themes.dark;
    return Container(
      child: Column(
        children: [
          darkModeSwitch(_themeChanger),
        ],
      ),
    );
  }
}
