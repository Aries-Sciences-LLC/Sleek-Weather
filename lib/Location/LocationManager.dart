import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:sleek_weather/Location/BackendLocation.dart';
import 'package:sleek_weather/Location/LocationSelector.dart';

import 'package:sleek_weather/Backend/DataManager.dart';
import 'package:sleek_weather/Backend/ReorderableListHandler.dart';

class LocationManager extends StatefulWidget {
  @override
  _LocationManager createState() => _LocationManager();
}

class _LocationManager extends State<LocationManager> with TickerProviderStateMixin {
  bool selectorVisible = false;

  List<ItemData> _items;

  @override
  Widget build(BuildContext context) {
    _items = ItemData.createReorderableList(Location.extractNames(DataManager.locations));
    
    return Stack(
      children: <Widget>[
        AnimatedOpacity(
          opacity: selectorVisible ? 0.0 : 1.0,
          duration: const Duration(
            milliseconds: 500,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 75,
                  bottom: 20,
                  left: 10,
                ),
                child: Text(
                  "Your Places",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: const Color.fromRGBO(101, 99, 235, 0.7),
                    fontSize: 35,
                    decoration: TextDecoration.overline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 40,
                        right: 40,
                        bottom: 100,
                        top: 150,
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
                                      isFirst: index == 0,
                                      isLast: index == _items.length - 1,
                                      draggingMode: DraggingMode.iOS,
                                    );
                                    cell.removeCell = () {
                                      setState(() {
                                        _items.removeAt(index);
                                        DataManager.locations.removeAt(index);
                                        _items = ItemData.createReorderableList(Location.extractNames(DataManager.locations));
                                        Location.saveLocationList(DataManager.locations);
                                      });
                                    };
                                    cell.refresh = () {
                                      setState(() {
                                        Location.getCurrentCoordinates((location) {
                                          DataManager.locations[0] = location;
                                        });
                                      });
                                    };
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
            ],
          ),
        ),
        AnimatedPositioned(
          top: selectorVisible ? 25 : MediaQuery.of(context).size.height,
          duration: Duration(
            milliseconds: 500,
          ),
          curve: Curves.bounceOut,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 25,
            child: LocationSelector(
              dismiss: () {
                setState(() {
                  selectorVisible = !selectorVisible;
                  _items = ItemData.createReorderableList(Location.extractNames(DataManager.locations));
                  Location.saveLocationList(DataManager.locations);
                });
              },
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(
            milliseconds: 500,
          ),
          top: selectorVisible ? 25 : MediaQuery.of(context).size.height - 145,
          right: 25,
          curve: Curves.bounceIn,
          child: IconButton(
            icon: Icon(
              selectorVisible ? Icons.close :Icons.add,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              setState(() {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                selectorVisible = !selectorVisible;
              });
            }, // Function
          ),
        ),
      ],
    );
  }
}