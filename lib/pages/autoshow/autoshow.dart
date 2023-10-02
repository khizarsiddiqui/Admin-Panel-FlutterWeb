import 'package:flutter/material.dart';

class AutoshowPage extends StatelessWidget {
  final int numberOfCarsRegistered = 100;
  final int numberOfAvailableTickets = 200;
  final int numberOfBookedTickets = 130;

  // Sample car data for demonstration
  final List<Car> cars = [
    Car(name: 'Car 1', owner: 'Owner 1', regNo: 'ABC 123'),
    Car(name: 'Car 2', owner: 'Owner 2', regNo: 'XYZ 789'),
    // Add more car objects here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Auto Show'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildInfoCard('Cars Registered', numberOfCarsRegistered),
                _buildInfoCard('Available Tickets', numberOfAvailableTickets),
                _buildInfoCard('Booked Tickets', numberOfBookedTickets),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.0,
                ),
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  return _buildCarCard(cars[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, int value) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              value.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarCard(Car car) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(car.name),
        subtitle: Text('Owner: ${car.owner}\nReg. No: ${car.regNo}'),
      ),
    );
  }
}

class Car {
  final String name;
  final String owner;
  final String regNo;

  Car({required this.name, required this.owner, required this.regNo});
}
