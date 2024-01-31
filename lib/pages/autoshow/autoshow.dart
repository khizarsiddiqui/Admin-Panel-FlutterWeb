// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AutoshowController extends GetxController {
  var autoshowList = <Autoshow>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAutoshowData();
  }

  Future<void> fetchAutoshowData() async {
    try {
      isLoading(true);

      final autoshowCollection = FirebaseFirestore.instance.collection('autoshow');
      final QuerySnapshot querySnapshot = await autoshowCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        final fetchedAutoshowList = querySnapshot.docs
            .map((doc) => Autoshow.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        autoshowList.assignAll(fetchedAutoshowList);
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      isLoading(false);
    }
  }

  void setAutoshowList(List<Autoshow> list) {
    autoshowList.assignAll(list);
  }
}

class AutoshowPage extends StatefulWidget {
  const AutoshowPage({Key? key}) : super(key: key);

  @override
  _AutoshowPageState createState() => _AutoshowPageState();
}

class _AutoshowPageState extends State<AutoshowPage> {
  final AutoshowController autoshowController = Get.put(AutoshowController());

  @override
  void initState() {
    super.initState();
    autoshowController.fetchAutoshowData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cars Registered for Auto Shows',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAutoshowListView(),
          ],
        ),
      ),
    );
  }


  Widget _buildAutoshowListView() {
    return Obx(
          () => ListView.builder(
        shrinkWrap: true,
        itemCount: autoshowController.autoshowList.length,
        itemBuilder: (context, index) {
          return _buildAutoshowCard(autoshowController.autoshowList[index]);
        },
      ),
    );
  }

  Widget _buildAutoshowCard(Autoshow autoshow) {
    return Card(
      elevation: 4,
      color: Colors.lightBlueAccent,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: const Text("Autoshow: Pakwheels 2k23"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Registered Car Owner Name: ${autoshow.name}'),
            Text('Registered Car Name: ${autoshow.carModel}'),
            Text('Registered Car No. Plate: ${autoshow.carNoPlate}'),
          ],
        ),
        trailing: const Icon(Icons.directions_car, size: 50,),
      ),
    );
  }
}

class Autoshow {
  final String name;
  final String phone;
  final String cnic;
  final String carModel;
  final String carNoPlate;

  Autoshow({
    required this.name,
    required this.phone,
    required this.cnic,
    required this.carModel,
    required this.carNoPlate,
  });

  factory Autoshow.fromMap(Map<String, dynamic> map) {
    return Autoshow(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      cnic: map['cnic'] ?? '',
      carModel: map['carModel'] ?? '',
      carNoPlate: map['carNoPlate'] ?? '',
    );
  }
}