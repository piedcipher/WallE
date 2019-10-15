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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WallE'),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchWallpapers(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: <Widget>[
                ...snapshot.data.toList().map(
                      (f) => InkWell(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Image.network(f['urls']['small']),
                        ),
                      ),
                    ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: RaisedButton(
                    child: Text('Next'),
                    onPressed: () {
                      setState(() {
                        _page++;
                      });
                    },
                  ),
                )
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future fetchWallpapers() async {
    http.Response response = await http.get(
        'https://api.unsplash.com/photos/?client_id=$kAccessKey&per_page=30&page=$_page');
    return json.decode(response.body);
  }
}
