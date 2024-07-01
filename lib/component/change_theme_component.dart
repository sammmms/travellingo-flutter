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

        return GestureDetector(
          onTap: () {
            _themeBloc.toggleTheme();
          },
          child: Container(
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: !isDarkTheme
                    ? Image.asset(
                        "assets/images/Moon.png",
                        height: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      )
                    : Image.asset(
                        "assets/images/Sun.png",
                        height: 25,
                        color: Theme.of(context).colorScheme.onSurface,
                      )),
          ),
        );
      },
    );
  }
}
