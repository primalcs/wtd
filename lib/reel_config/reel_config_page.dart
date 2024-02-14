import 'package:flutter/material.dart';
import 'package:wtdapp/utils/storage_service.dart';

class ReelConfigPage extends StatefulWidget {
  const ReelConfigPage({Key? key}) : super(key: key);
  final String title = "";

  @override
  _ReelConfigPageState createState() => _ReelConfigPageState();
}

class _ReelConfigPageState extends State<ReelConfigPage> {
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
    Helper.setSpecificList("cobold", ["nol", "celkoviy"]);
    Helper.setSpecificList("default", ["Do nothing"]);
    Helper.setAllListsNames(["default", "cobold"]);
    _loadAllList();
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          )
        ],
      );

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
    var currentList = await Helper.getSpecificList(listName);
    _currentList = currentList;

    setState(() {
      _reinitCurrentListWidgets();
    });
  }

  void _addToCurrentList(String text) async {
    if (_currentListName.isEmpty) return;
    _currentList.add(text);
    await Helper.setSpecificList(_currentListName, _currentList);
    setState(() {
      _reinitCurrentListWidgets();
    });
  }

  void _onCurrentListReorder(List<String> children) async {
    _currentList = children;
    await Helper.setSpecificList(_currentListName, children);
    // _reinitCurrentListWidgets();
  }

  void _onCurrentListDelete(int index) async {
    _currentList.removeAt(index);
    await Helper.setSpecificList(_currentListName, _currentList);
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
    var allList = await Helper.getAllListsNames();
    if (allList.isEmpty) return;
    setState(() {
      _allLists = allList;
      _reinitAllListWidgets();
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

  void _onAllListDelete(int index) async {
    _currentListName = "";
    _currentList = [];
    String listName = _allLists.elementAt(index);
    _allLists.removeAt(index);
    await Helper.deleteWholeList(listName);
    setState(() {
      _reinitCurrentListWidgets();
      _reinitAllListWidgets();
    });
  }

  void _onAllListReorder(List<String> children) async {
    _allLists = children;
    await Helper.setAllListsNames(children);
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

class AllListView extends StatefulWidget {
  final Color? colorSelected, colorDefault;
  final List<String> childrenList;
  final Function onTapFunction;
  final Function onDeleteFunction;
  final Function onReorderFunction;

  const AllListView({
    Key? key,
    this.colorSelected,
    this.colorDefault,
    required this.childrenList,
    required this.onTapFunction,
    required this.onDeleteFunction,
    required this.onReorderFunction,
  }) : super(key: key);

  @override
  _AllListViewState createState() => _AllListViewState();
}

class _AllListViewState extends State<AllListView> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
        reverse: true,
        itemCount: widget.childrenList.length,
        itemBuilder: (context, index) {
          return ListTile(
            key: Key("$index"),
            tileColor: selectedIndex == index
                ? widget.colorSelected
                : widget.colorDefault,
            title: TapRegion(
              child: Container(
                decoration: const BoxDecoration(),
                child: Center(child: Text(widget.childrenList[index])),
              ),
              onTapInside: (event) {
                if (selectedIndex == index) {
                  return;
                }
                widget.onTapFunction(widget.childrenList[index]);
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            leading: Visibility(
              visible: selectedIndex == index,
              child: IconButton(
                  onPressed: () {
                    widget.onDeleteFunction(index);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete)),
            ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final String item = widget.childrenList.removeAt(oldIndex);
            widget.childrenList.insert(newIndex, item);
            widget.onReorderFunction(widget.childrenList);
            selectedIndex = -1;
          });
        });
  }
}

class CurrentListView extends StatefulWidget {
  final Color? colorSelected, colorDefault;
  final List<String> childrenList;
  final Function onDeleteFunction;
  final Function onReorderFunction;

  const CurrentListView({
    Key? key,
    this.colorSelected,
    this.colorDefault,
    required this.childrenList,
    required this.onDeleteFunction,
    required this.onReorderFunction,
  }) : super(key: key);

  @override
  _CurrentListViewState createState() => _CurrentListViewState();
}

class _CurrentListViewState extends State<CurrentListView> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      reverse: true,
      itemCount: widget.childrenList.length,
      itemBuilder: (context, index) {
        return ListTile(
          tileColor: selectedIndex == index
              ? widget.colorSelected
              : widget.colorDefault,
          key: Key("$index"),
          title: TapRegion(
            child: Container(
              decoration: const BoxDecoration(),
              child: Center(child: Text(widget.childrenList[index])),
            ),
            onTapInside: (event) {
              if (selectedIndex == index) {
                return;
              }
              setState(() {
                selectedIndex = index;
              });
            },
            // onTapOutside: (event) {
            //   setState(() {
            //     selectedIndex = -1;
            //   });
            // },
          ),
          leading: Visibility(
            visible: selectedIndex == index,
            child: IconButton(
                onPressed: () {
                  widget.onDeleteFunction(index);
                  setState(() {});
                },
                icon: const Icon(Icons.delete)),
          ),
        );
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final String item = widget.childrenList.removeAt(oldIndex);
          widget.childrenList.insert(newIndex, item);
          widget.onReorderFunction(widget.childrenList);
          selectedIndex = -1;
        });
      },
    );
  }
}
