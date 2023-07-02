import 'package:flutter/material.dart';

class Hotel {
  String name;
  String description;
  String location;
  String city;
  double latitude;
  double longitude;
  double price;
  int totalRooms;
  List<String> images;
  String hotelClass;
  TimeOfDay checkInTime;
  TimeOfDay checkOutTime;

  Hotel({
    required this.name,
    required this.description,
    required this.location,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.totalRooms,
    required this.images,
    required this.hotelClass,
    required this.checkInTime,
    required this.checkOutTime,
  });
}

class AdminHotelScreen extends StatefulWidget {
  @override
  _AdminHotelScreenState createState() => _AdminHotelScreenState();
}

class _AdminHotelScreenState extends State<AdminHotelScreen> {
  List<Hotel> hotels = [];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _totalRoomsController = TextEditingController();
  TextEditingController _hotelClassController = TextEditingController();
  TextEditingController _checkInTimeController = TextEditingController();
  TextEditingController _checkOutTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Hotel Management'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Flexible(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Hotel Name',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                ),
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                ),
              ),
              TextField(
                controller: _latitudeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                ),
              ),
              TextField(
                controller: _longitudeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Longitude',
                ),
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
              ),
              TextField(
                controller: _totalRoomsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Rooms',
                ),
              ),
              TextField(
                controller: _hotelClassController,
                decoration: InputDecoration(
                  labelText: 'Hotel Class',
                ),
              ),
              TextField(
                controller: _checkInTimeController,
                decoration: InputDecoration(
                  labelText: 'Check-In Time (HH:mm)',
                ),
              ),
              TextField(
                controller: _checkOutTimeController,
                decoration: InputDecoration(
                  labelText: 'Check-Out Time (HH:mm)',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _createHotel();
                },
                child: Text('Create Hotel'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: hotels.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(hotels[index].name),
                      subtitle: Text(hotels[index].description),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteHotel(index);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createHotel() {
    String name = _nameController.text;
    String description = _descriptionController.text;
    String location = _locationController.text;
    String city = _cityController.text;
    double latitude = double.parse(_latitudeController.text);
    double longitude = double.parse(_longitudeController.text);
    double price = double.parse(_priceController.text);
    int totalRooms = int.parse(_totalRoomsController.text);
    String hotelClass = _hotelClassController.text;
    TimeOfDay checkInTime = TimeOfDay(
      hour: int.parse(_checkInTimeController.text.split(':')[0]),
      minute: int.parse(_checkInTimeController.text.split(':')[1]),
    );
    TimeOfDay checkOutTime = TimeOfDay(
      hour: int.parse(_checkOutTimeController.text.split(':')[0]),
      minute: int.parse(_checkOutTimeController.text.split(':')[1]),
    );

    Hotel newHotel = Hotel(
      name: name,
      description: description,
      location: location,
      city: city,
      latitude: latitude,
      longitude: longitude,
      price: price,
      totalRooms: totalRooms,
      images: [],
      hotelClass: hotelClass,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime,
    );

    setState(() {
      hotels.add(newHotel);
      _clearFields();
    });
  }

  void _deleteHotel(int index) {
    setState(() {
      hotels.removeAt(index);
    });
  }

  void _clearFields() {
    _nameController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _cityController.clear();
    _latitudeController.clear();
    _longitudeController.clear();
    _priceController.clear();
    _totalRoomsController.clear();
    _hotelClassController.clear();
    _checkInTimeController.clear();
    _checkOutTimeController.clear();
  }
}
