import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

import 'package:sleek_weather/Location/BackendLocation.dart';

class ItemData {
  ItemData(this.title, this.key);

  final String title;

  // Each item in reorderable list needs stable and unique key
  final Key key;

  static int _indexOfKey(List<ItemData> _items, Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  static bool reorderCallback(List<ItemData> _items, Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(_items, item);
    int newPositionIndex = _indexOfKey(_items, newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _items[draggingIndex];

    _items.removeAt(draggingIndex);
    _items.insert(newPositionIndex, draggedItem);
    
    return true;
  }

  static void reorderDone(List<ItemData> _items, Key item) {
    // The User Finished Reordering the List
  }

  static List<ItemData> createReorderableList(List<String> items) {
    List<ItemData> _items = List();
    for(int i = 0; i < items.length; i++) {
      _items.add(ItemData(items[i], ValueKey(i)));
    }

    return _items;
  }
}

enum DraggingMode {
  iOS,
  Android,
}

class Item extends StatelessWidget {
  Item({
    this.data,
    this.isFirst,
    this.isLast,
    this.draggingMode,
    this.weekdayIcon
  });

  final ItemData data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  String reorderable = "true";
  Function handler;
  Function removeCell;
  Function refresh;
  IconData weekdayIcon;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Colors.transparent);
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.transparent);
    }

    // For iOS dragging mdoe, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? ReorderableListener(
            child: Container(
              padding: EdgeInsets.only(right: 18.0, left: 18.0),
              color: Colors.transparent,
              child: Center(
                child: Opacity(opacity: 0, child: Icon(Icons.menu, color: Colors.white, size: 20)),
              ),
            ),
          )
        : Container();
    Color textColor = Colors.white;
    if (reorderable != "true" && reorderable != "false") {
      textColor = Color.fromRGBO(50, 50, 50, 0.5);
    }
    List<Widget> cells = [
      Expanded(
          child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
        child: Text(data.title,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      )),
    ];

    if (reorderable == "true") {
      cells.insert(0, Icon(
        isFirst ? Icons.my_location : Icons.place,
        size: 25,
        color: Colors.white,
      ));
      cells.add(dragHandle);
      cells.add(
        IconButton(
          icon: Icon(
            isFirst ? Icons.refresh: Icons.close,
            color: Colors.white,
            size: 20,
          ),
          onPressed: isFirst ? this.refresh: this.removeCell,
        ),
      );
    } else if (reorderable == "false") {
      cells.insert(0, Icon(
        isFirst ? Icons.my_location : Icons.place,
        size: 25,
        color: Colors.white,
      ));
      cells.add(IconButton(
        icon: Icon(
          Icons.add,
          color: const Color.fromRGBO(101, 99, 235, 0.7),
        ),
        onPressed: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          Location.reverseGeocode(this.data.title);
          this.handler();
        },
      ));
    } else {
      cells.add(Center(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 20,
          ),
          child: Icon(
            weekdayIcon,
            size: 15,
          ),
        )
      ));
      cells.add(Center(
        child: Text(
          reorderable,
        ),
      ));
    }

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Opacity(
          // hide content for placeholder
          opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: cells,
            ),
          ),
        )
      ),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.Android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}