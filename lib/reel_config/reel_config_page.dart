import 'package:flutter/material.dart';
import 'package:wtdapp/utils/storage_service.dart';

class ReelConfigPage extends StatefulWidget {
  const ReelConfigPage({Key? key}) : super(key: key);
  final String title = "";

  @override
  _ReelConfigPageState createState() => _ReelConfigPageState();
}

class _ReelConfigPageState extends State<ReelConfigPage> {
  List<String> _currentList = [];
  List<String> _allLists = [];
  String _currentListName = "";
  late List<Widget> _currentListWidgets;
  late List<Widget> _allListWidgets;

  double _allListWidth = _minAllListWidth;
  double _currentListWidth = _minCurrentListWidth;
  static const double _minAllListWidth = 210;
  static const double _minCurrentListWidth = 250;

  late Size contextSize;
  late EdgeInsets padding;

  final allListTextInputController = TextEditingController();
  final currentListTextInputController = TextEditingController();

  @override
  void dispose() {
    currentListTextInputController.dispose();
    super.dispose();
  }

  void _setCurrentListName(String t) {
    _loadCurrentList(t);
    _currentListName = t;
  }

  Widget newListCard(String text) => SelectableCard(
      text: text,
      tapInsideFunction: _setCurrentListName,
      colorDefault: Theme.of(context).cardColor,
      colorSelected: Theme.of(context).highlightColor);

  void resizeBars(double dx) {
    if ((dx < 0 && _allListWidth + dx > _minAllListWidth) ||
        (dx > 0 && _currentListWidth - dx > _minCurrentListWidth)) {
      _allListWidth += dx;
      _currentListWidth -= dx;
    }
  }

  void _loadCurrentList(String listName) async {
    if (listName == _currentListName) {
      return;
    }
    var currentList = await Helper.getSpecificList(listName);
    _currentList = currentList;

    setState(() {
      _reinitCurrentListWidgets();
    });
  }

  void _reinitCurrentListWidgets() {
    _currentListWidgets = [for (var s in _currentList) newCard(s)];
  }

  void _loadAllList() async {
    var allList = await Helper.getAllListsNames();
    if (allList.isEmpty) return;
    setState(() {
      _allLists = allList;
      _reinitAllListWidgets();
    });
  }

  void _addToCurrentList(String text) async {
    _currentList.add(text);
    await Helper.setSpecificList(_currentListName, _currentList);
    setState(() {
      _reinitCurrentListWidgets();
    });
  }

  void _addToAllLists(String text) async {
    if (_allLists.contains(text)) return;
    _allLists.add(text);
    await Helper.setSpecificList(Helper.allListsKeyName, _allLists);
    setState(() {
      _reinitAllListWidgets();
    });
  }

  void _reinitAllListWidgets() {
    _allListWidgets = [for (var s in _allLists) newListCard(s)];
  }

  @override
  void initState() {
    super.initState();
    Helper.setSpecificList("cobold", ["nol", "celkoviy"]);
    Helper.setSpecificList("default", ["Do nothing"]);
    Helper.setAllListsNames(["default", "cobold"]);
    _loadAllList();
    _reinitAllListWidgets();
    _reinitCurrentListWidgets();
  }

  @override
  Widget build(BuildContext context) {
    _reinitAllListWidgets();
    contextSize = MediaQuery.of(context).size;
    padding = MediaQuery.of(context).viewPadding;
    double maxWidth = contextSize.width - padding.left - padding.right;
    if (_allListWidth + _currentListWidth != maxWidth) {
      _allListWidth = maxWidth / 2;
      _currentListWidth = maxWidth / 2;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // All list
          GestureDetector(
            child: SizedBox(
              width: _allListWidth,
              child: Column(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: ListView(
                      reverse: true,
                      children: _allListWidgets,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: TextField(
                            controller: allListTextInputController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'New activity list',
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _addToAllLists(
                                  allListTextInputController.value.text);
                            },
                            child: const Text("Add")),
                      ],
                    ),
                  )
                ],
              ),
            ),
            onHorizontalDragUpdate: (details) {
              final dx = details.delta.dx;
              setState(() {
                resizeBars(dx);
              });
            },
          ),
          // Current list
          GestureDetector(
            child: SizedBox(
              width: _currentListWidth,
              child: Column(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: ListView(
                      reverse: true,
                      children: _currentListWidgets,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: TextField(
                            controller: currentListTextInputController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'New activity',
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _addToCurrentList(
                                currentListTextInputController.value.text);
                          },
                          child: const Text("Add"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onHorizontalDragUpdate: (details) {
              final dx = details.delta.dx;
              setState(() {
                resizeBars(dx);
              });
            },
          ),
        ],
      ),
    );
  }
}

Widget newCard(text) => Row(
      children: [
        Flexible(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(child: Text(text)),
            ),
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
      ],
    );

class SelectableCard extends StatefulWidget {
  final Color? colorSelected, colorDefault;
  final String text;
  final Function tapInsideFunction;
  const SelectableCard(
      {Key? key,
      this.colorSelected,
      this.colorDefault,
      required this.text,
      required this.tapInsideFunction})
      : super(key: key);
  @override
  _SelectableCardState createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  Color? _color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
        Flexible(
          child: TapRegion(
            onTapInside: (event) {
              setState(() {
                _color = widget.colorSelected;
                widget.tapInsideFunction(widget.text);
              });
            },
            onTapOutside: (event) {
              setState(() {
                _color = widget.colorDefault;
              });
            },
            child: Card(
              color: _color ?? widget.colorDefault,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(widget.text)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
