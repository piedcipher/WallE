import 'package:flutter/material.dart';

import 'package:walle/utils/contants.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: FutureBuilder(
        future: _getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      size: 30,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('No Favorites'),
                  ],
                ),
              );
            }
            return ListView(
              children: <Widget>[
                ...snapshot.data.map((favoriteWallpaper) => GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/details', arguments: {
                          'id': favoriteWallpaper['pid'],
                          'urls_raw': favoriteWallpaper['urls_raw'],
                          'urls_regular': favoriteWallpaper['urls_regular'],
                          'user': {
                            'name': favoriteWallpaper['name'],
                            'location': favoriteWallpaper['location'],
                          },
                          'likes': favoriteWallpaper['likes'],
                          'color': favoriteWallpaper['color'],
                          'width': favoriteWallpaper['width'],
                          'height': favoriteWallpaper['height'],
                          'created_at': favoriteWallpaper['created_at'],
                          'links_html': favoriteWallpaper['links_html'],
                        });
                      },
                      child: Card(
                        margin: EdgeInsets.all(16),
                        elevation: 1,
                        child: Column(
                          children: <Widget>[
                            Hero(
                                tag: favoriteWallpaper['pid'],
                                child: Image.network(
                                    favoriteWallpaper['urls_regular'])),
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text(favoriteWallpaper['name']),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future _getFavorites() async {
    List<Map<String, dynamic>> result = await kDatabase.query(kTable);
    return result;
  }
}
