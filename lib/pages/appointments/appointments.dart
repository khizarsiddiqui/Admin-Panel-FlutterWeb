// ignore_for_file: non_constant_identifier_names
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_panel/pages/products/products.dart';

import '../../../constants/style.dart';
import '../../../widgets/custom_text.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({Key? key}) : super(key: key);

  @override
  State<AppointmentsPage> createState() => _AppointmentsTableState();
}

class _AppointmentsTableState extends State<AppointmentsPage> {
  final AppointmentsController appointmentsController =
  Get.put(AppointmentsController());
  final ProductsController productsController = Get.put(ProductsController());


  @override
  void initState() {
    super.initState();
    appointmentsController.fetchAppointments();
  }

  DataRow _buildAppointmentRow(Appointment appointment) {
    final isFulfilled = appointment.isFulfilled ?? false;
    return DataRow(
      color: MaterialStateColor.resolveWith((states) {
        if (isFulfilled) {
          return Colors.black.withOpacity(0.5);
        } else {
          return Colors.white;
        }
      }),
      cells: [
        DataCell(_buildCell(appointment.name)),
        DataCell(_buildCell(appointment.phone)),
        DataCell(_buildCell(appointment.package_name)),
        DataCell(_buildCell(appointment.date.toDate().toString())),
        DataCell(_buildCell(appointment.car_year.toString())),
        DataCell(_buildCell(appointment.car_model)),
        DataCell(_buildCell(appointment.address)),
        DataCell(
          _buildActionButton(
            appointment.isFulfilled ?? false
                ? 'Appointment Fulfilled'
                : 'Mark as Fulfilled',
                () {
              appointmentsController.toggleFulfillment(appointment);
            },
            appointment.isFulfilled ?? false,
          ),
        ),
      ],
    );
  }

  Widget _buildCell(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.transparent),
      ),
      child: CustomText(text: text),
    );
  }

  Widget _buildActionButton(String label, void Function() onPressed,
      bool isFulfilled) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isFulfilled ? Colors.lightBlueAccent : light,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active, width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: CustomText(
          text: label,
          color: active.withOpacity(0.7),
          weight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var columns = const [
      DataColumn(label: Text('Customer Name')),
      DataColumn(label: Text('Phone')),
      DataColumn(label: Text('Package Name')),
      DataColumn(label: Text('Date')),
      DataColumn(label: Text('Car Year')),
      DataColumn(label: Text('Car Model')),
      DataColumn(label: Text('Address')),
      DataColumn(label: Text('Actions')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Service Appointments'),
          backgroundColor: Colors.lightBlueAccent,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return _buildAddAppointmentsDialog(context);
                  },
                );
              },
            ),
          ],
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: active.withOpacity(.4), width: .5),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 6),
                color: Colors.lightGreenAccent.withOpacity(.1),
                blurRadius: 12,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 30),
          child: AdaptiveScrollbar(
            underColor: Colors.blueGrey.withOpacity(0.3),
            sliderDefaultColor: Colors.lightBlueAccent.withOpacity(0.7),
            sliderActiveColor: Colors.lightBlueAccent,
            controller: verticalScrollController,
            child: AdaptiveScrollbar(
              controller: horizontalScrollController,
              position: ScrollbarPosition.bottom,
              underColor: lightGray.withOpacity(0.3),
              sliderDefaultColor: Colors.lightBlueAccent.withOpacity(0.7),
              sliderActiveColor: Colors.lightBlueAccent,
              width: 13.0,
              sliderHeight: 100.0,
              child: SingleChildScrollView(
                controller: verticalScrollController,
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  controller: horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: appointmentsController.isLoading.value
                        ? const CircularProgressIndicator()
                        : DataTable(
                      columns: columns,
                      rows: appointmentsController.appointments
                          .map((appointment) =>
                          _buildAppointmentRow(appointment))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAddAppointmentsDialog(BuildContext context) {
    String name = '';
    String phone = '';
    String address = '';
    String car_model = '';
    int car_year = 0;
    Timestamp date = Timestamp.now();

    List<int> years = List.generate(30, (index) => DateTime.now().year - index);
    // Fetch the list of car service products
    List<Products> carServiceProducts =
        productsController.carServiceProducts;

    // Extract the titles of car service products
    List<String> carServiceTitles =
    carServiceProducts.map((product) => product.title).toList();

    String package_name = carServiceTitles.first;
    Future<void> _selectDate(BuildContext context) async {
      DateTime selectedDate = DateTime.now();
      TimeOfDay selectedTime = TimeOfDay.now();

      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
      );

      if (pickedDate != null) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );

        if (pickedTime != null) {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          date = Timestamp.fromDate(selectedDate);
        }
      }
    }

    return AlertDialog(
      title: const Text('Add New Appointments'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Customer Name'),
            onChanged: (value) {
              name = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Address'),
            onChanged: (value) {
              address = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Phone No'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              phone = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Cars Model'),
            onChanged: (value) {
              car_model = value;
            },
          ),
          DropdownButtonFormField<int>(
            value: null,
            items: years.map((year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(year.toString()),
              );
            }).toList(),
            onChanged: (int? value) {
              if (value != null) {
                car_year = value;
              }
            },
            decoration: const InputDecoration(
              labelText: 'Car Year',
            ),
          ),
          DropdownButtonFormField<String>(
            value: null,
            items: carServiceTitles.map((package) {
              return DropdownMenuItem<String>(
                value: package,
                child: Text(package),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null && carServiceTitles.contains(value)) {
                package_name = value;
              }
            },
            decoration: const InputDecoration(
              labelText: 'Package Name',
            ),
          ),
          InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Date'),
              child: Row(
                children: [
                  Text(
                    date.toDate().toString(),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (name.isNotEmpty) {
              final newAppointments = Appointment(
                name: name,
                phone: phone,
                car_model: car_model,
                package_name: package_name,
                car_year: car_year,
                address: address,
                date: date,
              );
              appointmentsController._appointmentsService
                  .addAppointmentsToFirestore(newAppointments);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add Appointments'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

}
class AppointmentsController extends GetxController {
  var appointments = <Appointment>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }


  final AppointmentsService _appointmentsService = AppointmentsService();

  void toggleFulfillment(Appointment appointment) async {
    try {
      isLoading.value = true;
      appointment.isFulfilled = !(appointment.isFulfilled ?? false);
      await _appointmentsService.updateAppointment(appointment.name, appointment);
      fetchAppointments();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true;
      final fetchedAppointments =
      await _appointmentsService.fetchAppointments();
      if (fetchedAppointments.isNotEmpty) {
        appointments.assignAll(fetchedAppointments);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void addAppointment(Appointment appointment) async {
    try {
      isLoading.value = true;
      await _appointmentsService.addAppointment(appointment);
      fetchAppointments();
    } finally {
      isLoading.value = false;
    }
  }

  void updateAppointment(String name, Appointment appointment) async {
    try {
      isLoading.value = true;
      await _appointmentsService.updateAppointment(name, appointment);
      fetchAppointments();
    } finally {
      isLoading.value = false;
    }
  }

  void deleteAppointment(String name) async {
    try {
      isLoading.value = true;
      await _appointmentsService.deleteAppointment(name);
      fetchAppointments();
    } finally {
      isLoading.value = false;
    }
  }
}

class AppointmentsService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

    void addAppointmentsToFirestore(Appointment appointments) {
    firestore.collection('appointments').add({
      'name': appointments.name,
      'phone': appointments.phone,
      'date': appointments.date,
      'car_model': appointments.car_model,
      'package_name': appointments.package_name,
      'car_year': appointments.car_year,
      'address': appointments.address,
    }).then((_) {
      // After adding the appointments, fetch the updated data and update the list
      fetchAppointments();
    });
  }

  Future<List<Appointment>> fetchAppointments() async {
    try {
      final appointmentsCollection = firestore.collection('appointments');
      final querySnapshot = await appointmentsCollection.get();

      final appointments = querySnapshot.docs.map((doc) {
        return Appointment.fromSnapshot(doc);
      }).toList();

      return appointments;
    } catch (e) {
      print("Error fetching appointments: $e");
      return <Appointment>[];
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    final appointmentsCollection = firestore.collection('appointments');
    await appointmentsCollection.doc(appointment.name).set(appointment.toMap());
  }

  Future<void> updateAppointment(String name, Appointment appointment) async {
    final appointmentsCollection = firestore.collection('appointments');
    await appointmentsCollection.doc(name).update(appointment.toMap());
  }

  Future<void> deleteAppointment(String name) async {
    final appointmentsCollection = firestore.collection('appointments');
    await appointmentsCollection.doc(name).delete();
  }
}

class Appointment {
  final String name;
  final String phone;
  final String package_name;
  final Timestamp date;
  final int car_year;
  final String car_model;
  final String address;
  bool? isFulfilled;

  Appointment({
    required this.name,
    required this.phone,
    required this.package_name,
    required this.date,
    required this.car_year,
    required this.car_model,
    required this.address,
    this.isFulfilled,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'packageName': package_name,
      'date': date,
      'carYear': car_year,
      'carModel': car_model,
      'address': address,
      'isFulfilled': isFulfilled,
    };
  }

  factory Appointment.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Appointment(
      name: data['name'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      package_name: data['package_name'] as String? ?? '',
      date: data['date'] as Timestamp? ?? Timestamp.now(),
      car_year: data['car_year'] as int? ?? 0,
      car_model: data['car_model'] as String? ?? '',
      address: data['address'] as String? ?? '',
      isFulfilled: data['isFulfilled'] as bool?,
    );
  }
}
