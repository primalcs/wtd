import 'package:flutter/material.dart';

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
                    f() {
                      widget.onDeleteFunction(index);
                      setState(() {});
                    }

                    showAlertDialog(context, f);
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
          ),
          leading: Visibility(
            visible: selectedIndex == index,
            child: IconButton(
                onPressed: () {
                  f() {
                    widget.onDeleteFunction(index);
                    setState(() {});
                  }

                  showAlertDialog(context, f);
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

showAlertDialog(BuildContext context, Function approved) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Continue"),
    onPressed: () {
      approved();
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Are you sure?"),
    content: Text("Are you sure you want to delete this item?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
