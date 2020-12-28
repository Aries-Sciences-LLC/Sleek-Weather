import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

import 'package:sleek_weather/Location/BackendLocation.dart';
import 'package:sleek_weather/Backend/ReorderableListHandler.dart';

class LocationSelector extends StatefulWidget {
  final Function dismiss;

  const LocationSelector({Key key, this.dismiss}): super(key: key);

  @override
  _LocationSelector createState() => _LocationSelector();
}

class _LocationSelector extends State<LocationSelector> with TickerProviderStateMixin {

  List<ItemData> _items = List();
  FocusNode textFieldManager = FocusNode();
  bool justEntered = true;
  bool adder = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 20,
            left: 20,
          ),
          child: Text(
            "Add a Location",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: const Color.fromRGBO(66, 99, 144, 1),
              fontSize: 35,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
                right: 40,
                bottom: 10,
                top: 75,
              ),
              child: TextField(
                focusNode: textFieldManager,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                onChanged: (keyLocation) {
                  setState(() {
                    Location.locationLookup(keyLocation, (locations) {
                      _items = ItemData.createReorderableList(locations);
                    });
                    justEntered = false;
                  });
                },
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  icon: Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.white,
                  ),
                  hintText: 'Enter City, Country, etc.',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: _items.length == 0 ? 1 : 0,
              duration: Duration(
                milliseconds: 500,
              ),
              child: Text(
                justEntered ? "Click Done to Search" : "No Results",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withAlpha(700),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 8,
                ),
                child: ReorderableList(
                  onReorder: (item, newPosition) {
                    return ItemData.reorderCallback(_items, item, newPosition);
                  },
                  onReorderDone: (item) {
                    ItemData.reorderDone(_items, item);
                  },
                  child: CustomScrollView(
                    // cacheExtent: 3000,
                    slivers: <Widget>[
                      SliverPadding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              Item cell = Item(
                                data: _items[index],
                                // first and last attributes affect border drawn during dragging
                                isFirst: false,
                                isLast: index == _items.length - 1,
                                draggingMode: DraggingMode.iOS,
                              );
                              cell.reorderable = "false";
                              cell.handler = widget.dismiss;
                              return cell;
                            },
                            childCount: _items.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Center(
          child: AnimatedOpacity(
            opacity: adder ? 1.0 : 0.0,
            duration: const Duration(
              milliseconds: 500,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(101, 99, 235, 0.7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              width: 150,
              height: 150,
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 75,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}