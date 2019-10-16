import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> details = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpaper'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
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
          if (await canLaunch(details['urls_raw'])) launch(details['urls_raw']);
        },
        child: Icon(Icons.file_download),
      ),
    );
  }
}
