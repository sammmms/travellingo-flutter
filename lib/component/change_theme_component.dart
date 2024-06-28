import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travellingo/bloc/theme/theme_bloc.dart';
import 'package:travellingo/bloc/theme/theme_state.dart';

class ChangeThemeSwitchComponent extends StatefulWidget {
  const ChangeThemeSwitchComponent({super.key});

  @override
  State<ChangeThemeSwitchComponent> createState() =>
      _ChangeThemeSwitchComponentState();
}

class _ChangeThemeSwitchComponentState
    extends State<ChangeThemeSwitchComponent> {
  late ThemeBloc _themeBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeBloc = Provider.of<ThemeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeState>(
      stream: _themeBloc.themeStream,
      builder: (context, snapshot) {
        final isDarkTheme = snapshot.data?.themeType == ThemeType.dark;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Switch(
            inactiveThumbImage: const AssetImage('assets/Sun.png'),
            inactiveTrackColor: Colors.yellow[100],
            inactiveThumbColor: Colors.yellow[100],
            activeThumbImage: const AssetImage('assets/Moon.png'),
            activeTrackColor: Colors.grey[700],
            trackOutlineColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Color.fromARGB(255, 100, 100, 100);
              }
              return Colors.yellow[300];
            }),
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            activeColor: Colors.grey[700],
            value: isDarkTheme,
            onChanged: (value) {
              _themeBloc.toggleTheme();
            },
          ),
        );
      },
    );
  }
}
