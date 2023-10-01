import 'package:flutter/material.dart';

class AutoshowPage extends StatelessWidget {
  final int numberOfCarsRegistered = 100;
  final int numberOfAvailableTickets = 200;
  final int numberOfBookedTickets = 130;

  // AutoshowPage({
  //   required this.numberOfCarsRegistered,
  //   required this.numberOfAvailableTickets,
  //   required this.numberOfBookedTickets,
  // });

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
            Text(
              'Cars Registered: $numberOfCarsRegistered',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Available Tickets: $numberOfAvailableTickets',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Booked Tickets: $numberOfBookedTickets',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            // You can add more widgets and customize the layout as needed
          ],
        ),
      ),
    );
  }
}