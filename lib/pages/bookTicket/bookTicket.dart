// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sks_ticket_view/sks_ticket_view.dart';

class BookTicketController extends GetxController {
  var bookTicketList = <BookTicket>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookTicketData();
  }

  Future<void> fetchBookTicketData() async {
    try {
      isLoading(true);

      final bookTicketCollection = FirebaseFirestore.instance.collection('bookTicket');
      final QuerySnapshot querySnapshot = await bookTicketCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        final fetchedBookTicketList = querySnapshot.docs
            .map((doc) => BookTicket.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        bookTicketList.assignAll(fetchedBookTicketList);
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      isLoading(false);
    }
  }

  void setBookTicketList(List<BookTicket> list) {
    bookTicketList.assignAll(list);
  }
}

class BookTicketPage extends StatefulWidget {
  const BookTicketPage({Key? key}) : super(key: key);

  @override
  _BookTicketPageState createState() => _BookTicketPageState();
}

class _BookTicketPageState extends State<BookTicketPage> {
  final BookTicketController bookTicketController = Get.put(BookTicketController());

  @override
  void initState() {
    super.initState();
    bookTicketController.fetchBookTicketData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Tickets',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
      ),
      body: _buildBookTicketListView(),
    );
  }

  Widget _buildBookTicketListView() {
    return Obx(
          () => ListView.builder(
        itemCount: bookTicketController.bookTicketList.length,
        itemBuilder: (context, index) {
          final bookTicket = bookTicketController.bookTicketList[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: SKSTicketView(
              backgroundPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              backgroundColor: Colors.blueGrey,
              contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 0),
              contentBackgroundColor: Colors.lightBlueAccent,
              drawArc: true,
              triangleAxis: Axis.vertical,
              borderRadius: 6,
              drawDivider: false,
              trianglePos: .5,
              child: ListTile(
                title: Text(
                  'Ticket Holder Name: ${bookTicket.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone: ${bookTicket.phone}'),
                    Text('CNIC: ${bookTicket.cnic}'),
                  ],
                ),
                trailing: const Icon(Icons.confirmation_number, size: 35,),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookTicket {
  final String name;
  final String phone;
  final String cnic;

  BookTicket({
    required this.name,
    required this.phone,
    required this.cnic,
  });

  factory BookTicket.fromMap(Map<String, dynamic> map) {
    return BookTicket(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      cnic: map['cnic'] ?? '',
    );
  }
}
