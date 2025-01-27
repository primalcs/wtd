import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wtdapp/utils/storage_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.storage});
  final String title = "";
  final Helper storage;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ColorPicker _colorPicker;

  void init() {}

  @override
  void initState() {
    super.initState();
    widget.storage.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _updateColorPicker();
  }

  void _updateColorPicker() {
    _colorPicker = ColorPicker(
      color: widget.storage.initialColor,
      onColorChanged: (Color color) async {
        await widget.storage.setCurrentColor(color);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              children: [
                _SingleSection(
                  title: "General",
                  children: [
                    _CustomListTile(
                      title: "Dark Mode",
                      icon: Icons.dark_mode_outlined,
                      trailing: Switch(
                        value: widget.storage.initialColorMode,
                        onChanged: (value) async {
                          await widget.storage.setCurrentColorMode(value);
                        },
                      ),
                      onTapFunc: () {},
                    ),
                    _CustomListTile(
                      title: "Color",
                      icon: Icons.palette,
                      trailing: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: widget.storage.initialColor,
                        ),
                      ),
                      onTapFunc: () {
                        _colorPicker.showPickerDialog(context);
                      },
                    ),
                    _CustomListTile(
                      title: "Language",
                      icon: CupertinoIcons.textformat_abc,
                      trailing: DropdownMenu(
                        initialSelection: widget.storage.initialLanguage,
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: "en", label: "English"),
                          DropdownMenuEntry(value: "ru", label: "Русский"),
                        ],
                        onSelected: (value) {
                          widget.storage.setCurrentLanguage(value.toString());
                        },
                      ),
                      onTapFunc: () {},
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function onTapFunc;
  const _CustomListTile(
      {required this.title,
      required this.icon,
      this.trailing,
      required this.onTapFunc});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {
        onTapFunc();
      },
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}

// f() =>

// Future<bool> colorPickerDialog() async {
//   return ColorPicker(
//     // Use the dialogPickerColor as start color.
//     color: dialogPickerColor,
//     // Update the dialogPickerColor using the callback.
//     onColorChanged: (Color color) => setState(() => dialogPickerColor = color),
//     width: 40,
//     height: 40,
//     borderRadius: 4,
//     spacing: 5,
//     runSpacing: 5,
//     wheelDiameter: 155,
//     heading: Text(
//       'Select color',
//       style: Theme.of(context).textTheme.titleSmall,
//     ),
//     subheading: Text(
//       'Select color shade',
//       style: Theme.of(context).textTheme.titleSmall,
//     ),
//     wheelSubheading: Text(
//       'Selected color and its shades',
//       style: Theme.of(context).textTheme.titleSmall,
//     ),
//     showMaterialName: true,
//     showColorName: true,
//     showColorCode: true,
//     copyPasteBehavior: const ColorPickerCopyPasteBehavior(
//       longPressMenu: true,
//     ),
//     materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
//     colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
//     colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
//     pickersEnabled: const <ColorPickerType, bool>{
//       ColorPickerType.both: false,
//       ColorPickerType.primary: true,
//       ColorPickerType.accent: true,
//       ColorPickerType.bw: false,
//       ColorPickerType.custom: true,
//       ColorPickerType.wheel: true,
//     },
//     customColorSwatchesAndNames: colorsNameMap,
//   ).showPickerDialog(
//     context,
//     // New in version 3.0.0 custom transitions support.
//     transitionBuilder: (BuildContext context, Animation<double> a1,
//         Animation<double> a2, Widget widget) {
//       final double curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
//       return Transform(
//         transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
//         child: Opacity(
//           opacity: a1.value,
//           child: widget,
//         ),
//       );
//     },
//     transitionDuration: const Duration(milliseconds: 400),
//     constraints:
//         const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
//   );
// }
