import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pray_times/pray_times.dart';

class PrayerTimesApp extends StatefulWidget {
  @override
  _PrayerTimesAppState createState() => _PrayerTimesAppState();
}

class _PrayerTimesAppState extends State<PrayerTimesApp> {
  String timezone = '';
  double latitude = 0.0;
  double longitude = 0.0;
  String selectedJuristicMethod = 'Hanafi'; // Default to Hanafi

  @override
  void initState() {
    super.initState();
    getTimeZone();
  }

  List<String> prayerTimes = [];
  List<String> prayerNames = [];

  Future<void> getTimeZone() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      DateTime dateTime = DateTime.now();
      print(dateTime.timeZoneName);
      print(dateTime.timeZoneOffset.inHours);
      double tzone = dateTime.timeZoneOffset.inHours.toDouble();
      double timezone = tzone;
      // Test Prayer times here
      PrayerTimes prayers = new PrayerTimes();

      prayers.setTimeFormat(prayers.Time24);
      prayers.setCalcMethod(prayers.MWL);

      if (selectedJuristicMethod == 'Hanafi') {
        prayers.setAsrJuristic(prayers.Hanafi);
      } else {
        prayers.setAsrJuristic(prayers.Shafii);
      }

      prayers.setAdjustHighLats(prayers.AngleBased);
      // {Fajr,Sunrise,Dhuhr,Asr,Sunset,Maghrib,Isha}
      var offsets = [0, 0, 0, 0, 0, 0, 0];
      prayers.tune(offsets);
      final date = DateTime.now();
      // final date = DateTime(2023, DateTime.january, 20);
      prayerTimes = prayers.getPrayerTimes(date, latitude, longitude, timezone);
      prayerNames = prayers.getTimeNames();

      for (int i = 0; i < prayerTimes.length; i++) {
        print("${prayerNames[i]} - ${prayerTimes[i]}");
      }
    } catch (e) {
      print("ERROR" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prayer Times"),
        backgroundColor: const Color(0xff3a57e8),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedJuristicMethod,
            items: ['Hanafi', 'Shafi'].map((String method) {
              return DropdownMenuItem<String>(
                value: method,
                child: Text(method),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedJuristicMethod = newValue!;
                getTimeZone();
              });
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: getTimeZone(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else {
                  return PrayerTimesWidget(
                    prayerNames: prayerNames,
                    prayerTimes: prayerTimes,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PrayerTimesWidget extends StatelessWidget {
  final List<String> prayerNames;
  final List<String> prayerTimes;

  PrayerTimesWidget({required this.prayerNames, required this.prayerTimes});

  // Define a function to determine the card color based on the prayer name
  Color getCardColor(String prayerName) {
    if (prayerName.toLowerCase() == "fajr" ||
        prayerName.toLowerCase() == "maghrib") {
      return Colors.blue[900]!; // Dark blue color for Fajr
    } else if (prayerName.toLowerCase() == "sunrise" ||
        prayerName.toLowerCase() == "sunset") {
      return Colors.orange[500]!; // Yellowish-orange color for Sunrise
    } else if (prayerName.toLowerCase() == "dhuhr" ||
        prayerName.toLowerCase() == "asr") {
      return Colors.orange[200]!;
    } else if (prayerName.toLowerCase() == "isha") {
      return const Color.fromARGB(255, 52, 51, 51);
    } else {
      return Colors.white; // Default color for other prayers
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: prayerNames.length,
      itemBuilder: (context, index) {
        final prayerName = prayerNames[index];
        final prayerTime = prayerTimes[index];
        final cardColor = getCardColor(prayerName);

        return Card(
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    prayerName,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  Text(prayerTime,
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ]),
          ),
        );
      },
    );
  }
}
