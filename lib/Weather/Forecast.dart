import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:sleek_weather/Weather/BackendWeather.dart';
import 'package:sleek_weather/Weather/WeatherCard.dart';

import 'package:sleek_weather/Backend/ReorderableListHandler.dart';

import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class Forecast extends StatefulWidget {
  final Weather forecast;
  @override
  Forecast({ this.forecast });

  @override
  _Forecast createState() => _Forecast();
}

class _Forecast extends State<Forecast> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 875,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 25,
            ),
            child: Icon(
              widget.forecast.getIconData(),
              size: (MediaQuery.of(context).size.width / 3) - 40,
              color: Weather.greeting() == "Good Evening," ? Colors.black54 : Colors.black38,
            ),
          ),
          Positioned(
            top: 50,
            right: 25,
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "High",
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "${widget.forecast.maxTemperature}°",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                  ),
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(
                        Radius.circular(3 / 2)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Low",
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "${widget.forecast.minTemperature}°",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 200,
            left: -1,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width + 2,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black26,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 48,
                  itemBuilder: (context, index) {
                    return WeatherCard(
                      data: widget.forecast.forecastCards[index],
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 350,
            left: 20,
            width: MediaQuery.of(context).size.width - 40,
            height: 400,
            child: ReorderableList(
              onReorder: (item, newPosition) {
                return null;
              },
              child: CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
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
                            data: ItemData(
                              widget.forecast.weekdays[index].day,
                              ValueKey(index)
                            ),
                            // first and last attributes affect border drawn during dragging
                            isFirst: false,
                            isLast: false,
                            draggingMode: DraggingMode.iOS,
                            weekdayIcon: widget.forecast.weekdays[index].icon,
                          );
                          cell.reorderable = "${widget.forecast.weekdays[index].temperature}°";
                          return cell;
                        },
                        childCount: widget.forecast.weekdays.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 750,
            left: 15,
            width: MediaQuery.of(context).size.width - 30,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        "Wind Speed",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Text(
                        "${widget.forecast.windSpeed} m/s",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
                Container(height: 40, child: VerticalDivider(thickness: 1.5, color: Colors.grey)),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        "Sunrise",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Text(
                        "${Weather.readTimestamp(widget.forecast.sunrise)}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
                Container(height: 40, child: VerticalDivider(thickness: 1.5, color: Colors.grey)),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        "Sunset",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Text(
                        "${Weather.readTimestamp(widget.forecast.sunset)}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
                Container(height: 40, child: VerticalDivider(thickness: 1.5, color: Colors.grey)),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        "Humidity",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Text(
                        "${widget.forecast.humidity}%",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}