import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:walle/utils/api_constants.dart';

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
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Coming Soon'),
            ));
          },
          child: Icon(Icons.search),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo[100],
              ),
              child: Center(
                child: FlutterLogo(
                  size: 50,
                  colors: Colors.indigo,
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.white,
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(_scaffold.currentContext, '/favorites');
                },
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
              ),
            ),
            InkWell(
              splashColor: Colors.white,
              child: ListTile(
                onTap: () {
                  Navigator.pop(_scaffold.currentContext);
                  Navigator.pushNamed(_scaffold.currentContext, '/settings');
                },
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
                        ),
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
        actions: <Widget>[
          _page == 1
              ? Row(
                  children: <Widget>[
                    Text(_page.toString()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _page++;
                          _wallpapers = [];
                        });
                      },
                      icon: Icon(Icons.navigate_next),
                    ),
                  ],
                )
              : Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _page--;
                          _wallpapers = [];
                        });
                      },
                      icon: Icon(Icons.navigate_before),
                    ),
                    Text(_page.toString()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _page++;
                          _wallpapers = [];
                        });
                      },
                      icon: Icon(Icons.navigate_next),
                    ),
                  ],
                ),
        ],
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
