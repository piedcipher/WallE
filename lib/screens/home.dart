import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart' as http;

import 'package:walle/utils/contants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 1;
  dynamic _wallpapers = [];
  dynamic _parsedResponse = '';
  GlobalKey _scaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Next'),
        icon: Icon(Icons.navigate_next),
        onPressed: () {
          setState(() {
            _page++;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset(
                  'assets/app.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.white,
              child: ListTile(
                onTap: () =>
                    Navigator.pushNamed(_scaffold.currentContext, '/settings'),
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ),
            InkWell(
              splashColor: Colors.white,
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  showAboutDialog(
                      context: context,
                      applicationName: 'WallE',
                      applicationVersion: '1.0.0',
                      applicationIcon: Image.asset(
                        'assets/app.png',
                        width: 45,
                      ),
                      children: [
                        Image.asset('assets/walle.png'),
                        Center(
                          child: Text("Wallpaper App"),
                        ),
                        Center(
                          child: Text(
                            '\nMade with \u2764 by Tirth',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        )
                      ]);
                },
                leading: Icon(Icons.info),
                title: Text('About'),
              ),
            ),
          ],
        ),
      ),
      key: _scaffold,
      appBar: AppBar(
        title: Text('WallE'),
      ),
      body: _wallpapers.isEmpty
          ? FutureBuilder(
              future: _fetchWallpapers(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  _wallpapers = snapshot.data.toList().map(
                        (photo) => InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                _scaffold.currentContext, '/details',
                                arguments: {
                                  'id': photo['id'],
                                  'urls_raw': photo['urls']['raw'],
                                  'urls_regular': photo['urls']['regular'],
                                  'user': photo['user'],
                                  'likes': photo['likes'],
                                  'color': photo['color'],
                                  'width': photo['width'],
                                  'height': photo['height'],
                                  'created_at': photo['created_at'],
                                  'links_html': photo['links']['html'],
                                });
                          },
                          child: Container(
                            margin: EdgeInsets.all(8),
                            child: Hero(
                              tag: photo['id'],
                              child: Image.network(photo['urls']['small']),
                            ),
                          ),
                        ),
                      );
                  return _renderWallpapers();
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          : _renderWallpapers(),
    );
  }

  Widget _renderWallpapers() => ListView(
        children: <Widget>[
          ..._wallpapers,
        ],
      );

  Future _fetchWallpapers() async {
    http.Response response = await http.get(
        'https://api.unsplash.com/photos/?client_id=$kAccessKey&per_page=30&page=$_page');
    _parsedResponse = json.decode(response.body);
    return _parsedResponse;
  }
}
