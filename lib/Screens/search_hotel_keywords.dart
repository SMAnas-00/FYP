import 'package:flutter/material.dart';
import 'package:newui/Screens/search_hotel_screen.dart';

class HotelKeyWords extends StatefulWidget {
  const HotelKeyWords({super.key});

  @override
  State<HotelKeyWords> createState() => _HotelKeyWordsState();
}

class _HotelKeyWordsState extends State<HotelKeyWords> {
  final hotelCityController = TextEditingController();
  String? selectedHotelType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff3a57e8),
        title: const Text('Search Hotel'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: DropdownButtonFormField<String>(
                  value: selectedHotelType,
                  onChanged: (newValue) {
                    setState(() {
                      selectedHotelType = newValue;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: '1 start',
                      child: Text('1 start'),
                    ),
                    DropdownMenuItem(
                      value: '2 start',
                      child: Text('2 start'),
                    ),
                    DropdownMenuItem(
                      value: '3 start',
                      child: Text('3 start'),
                    ),
                    DropdownMenuItem(
                      value: '4 start',
                      child: Text('4 start'),
                    ),
                    DropdownMenuItem(
                      value: '5 start',
                      child: Text('5 start'),
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Hotel Type',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Hotel Type Required';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: TextFormField(
                  controller: hotelCityController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Hotel City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'City Required';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
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
                      border:
                          Border.all(color: const Color(0x4d9e9e9e), width: 1),
                    ),
                    child: const Text(
                      "Search Hotel",
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
                            builder: (context) => SearchHotelScreen(
                                  city: hotelCityController.text,
                                  stars: selectedHotelType.toString(),
                                )));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
