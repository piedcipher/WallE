import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:intent/intent.dart' as intent;
import 'package:intent/action.dart' as action;
import 'package:walle/utils/contants.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> details = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpaper'),
        actions: <Widget>[
          FutureBuilder(
            future: _isPhotoFavorite(details['id']),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data) {
                  return IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () async {
                      await kDatabase.insert(kTable, {
                        'pid': details['id'],
                        'urls_raw': details['urls_raw'],
                        'urls_regular': details['urls_regular'],
                        'links_html': details['links_html'],
                        'name': details['user']['name'],
                        'location': details['user']['location'],
                        'likes': details['likes'],
                        'height': details['height'],
                        'width': details['width'],
                        'created_at': details['created_at'],
                      }).then((_) {
                        setState(() {});
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Added to favorites'),
                          action: SnackBarAction(
                            label: 'View',
                            onPressed: () {
                              Navigator.pushNamed(context, '/favorites');
                            },
                          ),
                        ));
                      });
                    },
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () async {
                      await kDatabase.delete(kTable,
                          where: 'pid = ?',
                          whereArgs: [details['id']]).then((_) {
                        setState(() {});
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Removed from favorites'),
                        ));
                      });
                    },
                  );
                }
              }
              return Container();
            },
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              if (await canLaunch(details['urls_raw']))
                launch(details['urls_raw']);
            },
          ),
          IconButton(
            icon: Icon(Icons.launch),
            onPressed: () async {
              if (await canLaunch(details['links_html']))
                launch(details['links_html']);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: details['id'],
                child: Image.network(details['urls_regular']),
              ),
              ListTile(
                onTap: () {},
                title: Text(details['user']['name'] ?? 'N/A'),
                leading: Icon(Icons.person),
                subtitle: Text('Author'),
              ),
              ListTile(
                onTap: () {},
                title: Text(details['user']['location'] ?? 'N/A'),
                leading: Icon(Icons.location_on),
                subtitle: Text('Location'),
              ),
              ListTile(
                onTap: () {},
                title: Text(details['likes'].toString() ?? 'N/A'),
                leading: Icon(Icons.favorite),
                subtitle: Text('Likes'),
              ),
              ListTile(
                onTap: () {},
                title: Text('${details['width']} x ${details['height']}'),
                leading: Icon(Icons.aspect_ratio),
                subtitle: Text('Dimensions'),
              ),
              ListTile(
                onTap: () {},
                title: Text('${details['created_at']}'),
                leading: Icon(Icons.calendar_today),
                subtitle: Text('Created'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          intent.Intent()
            ..setAction(action.Action.ACTION_SET_WALLPAPER)
            ..startActivityForResult().then(
              (_) => print(_),
              onError: (e) => print(e),
            );
        },
        child: Icon(Icons.wallpaper),
      ),
    );
  }

  Future _isPhotoFavorite(String pid) async {
    List<Map> result = await kDatabase.query(kTable,
        columns: ['pid'], where: 'pid = ?', whereArgs: [pid]);
    return result.isEmpty;
  }
}
