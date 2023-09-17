import 'package:flutter/material.dart';
import 'package:newui/Screens/search_flight_screen.dart';

class SearchFlightScreen extends StatefulWidget {
  const SearchFlightScreen({super.key});

  @override
  State<SearchFlightScreen> createState() => _SearchFlightScreenState();
}

class _SearchFlightScreenState extends State<SearchFlightScreen> {
  final departureController = TextEditingController();
  final dateController = TextEditingController();
  final destinationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff3a57e8),
        title: const Text('Search Flight'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: TextFormField(
                  controller: departureController,
                  keyboardType: TextInputType.text,
                  decoration:
                      const InputDecoration(labelText: 'Departure City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Departure City Required';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: TextFormField(
                  controller: destinationController,
                  keyboardType: TextInputType.text,
                  decoration:
                      const InputDecoration(labelText: 'Destination City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Destination City Required';
                    }
                    return null;
                  },
                ),
              ),
              GestureDetector(
                onTap: () async {
                  DateTime? datePicked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2024));
                  if (datePicked != null) {
                    setState(() {
                      dateController.text =
                          '${datePicked.day}-${datePicked.month}-${datePicked.year}';
                    });
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: TextFormField(
                    controller: dateController,
                    enabled: false,
                    showCursor: false,
                    decoration: const InputDecoration(
                      labelText: 'Select Departure Date',
                    ),
                  ),
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
                      "Search Flight",
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
                    // DateTime now = DateTime.now();
                    String dateString = dateController.text;
                    List<String> dateParts = dateString.split('-');
                    if (dateParts.length == 3) {
                      int year = 2000 + int.parse(dateParts[0]);
                      int month = int.parse(dateParts[1]);
                      int day = int.parse(dateParts[2]);

                      try {
                        DateTime depDate = DateTime(year, month, day);
                        int dayOfWeek = depDate.weekday;
                        String dayName = '';
                        switch (dayOfWeek) {
                          case 1:
                            dayName = 'Monday';
                            break;
                          case 2:
                            dayName = 'Tuesday';
                            break;
                          case 3:
                            dayName = 'Wednesday';
                            break;
                          case 4:
                            dayName = 'Thursday';
                            break;
                          case 5:
                            dayName = 'Friday';
                            break;
                          case 6:
                            dayName = 'Saturday';
                            break;
                          case 7:
                            dayName = 'Sunday';
                            break;
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchFlight(
                                      departuereDay: dayName,
                                      departureCity: departureController.text,
                                      destinationCity:
                                          destinationController.text,
                                    )));
                      } catch (e) {
                        debugPrint('Invalid date: $dateString');
                      }
                    } else {
                      debugPrint('Invalid date format: $dateString');
                    }
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
