import 'package:flutter/material.dart';
import 'package:wtdapp/reel_config/custom_list_views.dart';
import 'package:wtdapp/utils/storage_service.dart';

class ReelConfigPage extends StatefulWidget {
  const ReelConfigPage({Key? key}) : super(key: key);
  final String title = "";

  @override
  _ReelConfigPageState createState() => _ReelConfigPageState();
}

class _ReelConfigPageState extends State<ReelConfigPage> {
  final Helper helper = Helper();
  String _currentListName = "";
  List<String> _currentList = [];
  CurrentListView _currentListWidgets = CurrentListView(
    childrenList: const [],
    onDeleteFunction: () {},
    onReorderFunction: () {},
  );
  static const double _minCurrentListWidth = 250;
  double _currentListWidth = _minCurrentListWidth;
  final currentListTextInputController = TextEditingController();

  List<String> _allLists = [];
  AllListView _allListWidgets = AllListView(
    childrenList: const [],
    onTapFunction: () {},
    onDeleteFunction: () {},
    onReorderFunction: () {},
  );
  static const double _minAllListWidth = 210;
  double _allListWidth = _minAllListWidth;
  final allListTextInputController = TextEditingController();

  late Size contextSize;
  late EdgeInsets padding;

  @override
  void dispose() {
    currentListTextInputController.dispose();
    allListTextInputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadAllList();
  }

  void resizeBars(double dx) {
    if ((dx < 0 && _allListWidth + dx > _minAllListWidth) ||
        (dx > 0 && _currentListWidth - dx > _minCurrentListWidth)) {
      _allListWidth += dx;
      _currentListWidth -= dx;
    }
  }

  // currentList
  void _setCurrentListName(String t) {
    _loadCurrentList(t);
    _currentListName = t;
  }

  void _loadCurrentList(String listName) async {
    if (listName == _currentListName) {
      return;
    }
    var currentList = await helper.getSpecificList(listName);
    _currentList = currentList;

    setState(() {
      _reinitCurrentListWidgets();
    });
  }

  void _addToCurrentList(String text) async {
    if (_currentListName.isEmpty) return;
    _currentList.add(text);
    await helper.setSpecificList(_currentListName, _currentList);
    setState(() {
      _reinitCurrentListWidgets();
    });
  }

  void _onCurrentListReorder(List<String> children) async {
    _currentList = children;
    await helper.setSpecificList(_currentListName, children);
    // _reinitCurrentListWidgets();
  }

  void _onCurrentListDelete(int index) async {
    _currentList.removeAt(index);
    await helper.setSpecificList(_currentListName, _currentList);
    _reinitCurrentListWidgets();
  }

  void _reinitCurrentListWidgets() {
    _currentListWidgets = CurrentListView(
      childrenList: _currentList,
      onDeleteFunction: _onCurrentListDelete,
      onReorderFunction: _onCurrentListReorder,
      colorDefault: Theme.of(context).cardColor,
      colorSelected: Theme.of(context).highlightColor,
    );
  }

  // AllList
  void _loadAllList() async {
    var allList = await helper.getAllListsNames();
    if (allList.isEmpty) return;
    setState(() {
      _allLists = allList;
      _reinitAllListWidgets();
    });
  }

  void _addToAllLists(String text) async {
    if (_allLists.contains(text)) return;
    _allLists.add(text);
    await helper.setSpecificList(Helper.allListsKeyName, _allLists);
    setState(() {
      _reinitAllListWidgets();
    });
  }

  void _onAllListDelete(int index) async {
    _currentListName = "";
    _currentList = [];
    String listName = _allLists.elementAt(index);
    _allLists.removeAt(index);
    await helper.deleteWholeList(listName);
    setState(() {
      _reinitCurrentListWidgets();
      _reinitAllListWidgets();
    });
  }

  void _onAllListReorder(List<String> children) async {
    _allLists = children;
    await helper.setAllListsNames(children);
  }

  void _reinitAllListWidgets() {
    // _reinitCurrentListWidgets();
    _allListWidgets = AllListView(
      childrenList: _allLists,
      colorDefault: Theme.of(context).cardColor,
      colorSelected: Theme.of(context).highlightColor,
      onTapFunction: _setCurrentListName,
      onDeleteFunction: _onAllListDelete,
      onReorderFunction: _onAllListReorder,
    );
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
                    child: _allListWidgets,
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
                    child: _currentListWidgets,
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
