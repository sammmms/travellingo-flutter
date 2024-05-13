import 'package:travellingo/utils/locales/language_type_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ChangeLanguageSwitchTile extends StatefulWidget {
  const ChangeLanguageSwitchTile({super.key});

  @override
  State<ChangeLanguageSwitchTile> createState() =>
      _ChangeLanguageSwitchTileState();
}

class _ChangeLanguageSwitchTileState extends State<ChangeLanguageSwitchTile> {
  late LanguageType currentLanguage;
  FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    currentLanguage = localization.currentLocale.localeIdentifier == 'en'
        ? LanguageType.en
        : LanguageType.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text("language".getString(context)),
      inactiveThumbImage: const AssetImage('assets/Indonesia.png'),
      inactiveTrackColor: Colors.red[100],
      inactiveThumbColor: Colors.red[100],
      activeThumbImage:
          const ResizeImage(AssetImage('assets/US.png'), height: 16, width: 22),
      activeTrackColor: Colors.blue[100],
      trackOutlineColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color.fromARGB(255, 62, 132, 168);
        }
        return Colors.red[300];
      }),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      activeColor: Colors.blue[100],
      value: currentLanguage == LanguageType.en,
      onChanged: (value) {
        if (currentLanguage == LanguageType.en) {
          currentLanguage = LanguageType.id;
        } else {
          currentLanguage = LanguageType.en;
        }
        setState(() {
          localization
              .translate(LanguageTypeUtil().statusTextOf(currentLanguage));
        });
      },
    );
  }
}
