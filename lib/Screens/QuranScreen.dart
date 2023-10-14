import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

class Quran extends StatefulWidget {
  @override
  _QuranState createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  List<dynamic> verses = [];
  String quranText = "";

  Future<void> fetchQuranVerses() async {
    final response = await http.get(
      Uri.parse('https://api.quran.com/api/v4/quran/verses/indopak'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        quranText = data['data']['text'];
      });
    } else {
      throw Exception('Failed to load Quran verses');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuranVerses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quran Verses'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Quran Verses (Indo-Pak Script):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Html(
                data:
                    quranText), // Use the flutter_html package to display HTML content
          ],
        ),
      ),
    );
  }
}
