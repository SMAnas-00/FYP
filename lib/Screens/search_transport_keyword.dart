import 'package:flutter/material.dart';
import 'package:newui/Screens/search_transport_screen.dart';

class SearchTranportKeyword extends StatefulWidget {
  const SearchTranportKeyword({super.key});

  @override
  State<SearchTranportKeyword> createState() => _SearchTranportKeywordState();
}

class _SearchTranportKeywordState extends State<SearchTranportKeyword> {
  final priceController = TextEditingController();
  final cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff3a57e8),
        title: const Text('Search Transport'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter Price'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Price Required';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: TextFormField(
              controller: cityController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Enter City'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'City Required';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xff3a57e8),
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0)),
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: const Text(
                  "Search Transport",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchTransportScreen(
                            price: int.parse(priceController.text),
                            city: cityController.text)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
