import 'package:flutter/material.dart';
import 'package:version_0/components/custom_text_field.dart';
import 'package:version_0/models/prescriptions.dart';
import 'package:version_0/services/post_prescription_service.dart';
import 'package:version_0/services/user_log_in_service.dart';
import 'package:version_0/services/user_log_out_service.dart';

class homePage extends StatefulWidget {
  homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final searchController = TextEditingController();
  Future<void> _logout() async {
    try {
      await logoutUser();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print("error logging out: $e");
    }
  }

  List<prescriptionDetails> Patientsprescriptions = [];
  @override
  void initState() {
    super.initState();
    fetchDoctorsPrescriptions();
  }

  Future<void> fetchDoctorsPrescriptions() async {
    List<prescriptionDetails> data = await getPatientsPrescriptions();
    setState(() {
      Patientsprescriptions = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFFFF),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.pushReplacementNamed(context, '/profile');
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => PrescriptionFormPage()));
                      },
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/logo.jpeg'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("Welcome back $firstName"),
                    const SizedBox(
                      width: 40,
                    ),
                    const Icon(Icons.notification_add),
                    const SizedBox(
                      width: 40,
                    ),
                    Tooltip(
                      message: 'Log Out',
                      child: IconButton(
                          onPressed: _logout, icon: const Icon(Icons.logout)),
                    ),
                  ],
                ),
                CustomTestField(
                  hintForTextField: 'search',
                  obscureInputedText: false,
                  myController: searchController,
                  onChanged: (value) {},
                  suffixIcon: Icons.search,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text('current prescriptions'),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 300,
                  child: Patientsprescriptions.isEmpty
                      ? Center(
                          child: Patientsprescriptions.isEmpty
                              ? CircularProgressIndicator()
                              : const Text('No prescriptions available.'),
                        )
                      : ListView.builder(
                          itemCount: Patientsprescriptions.length,
                          itemBuilder: (context, index) {
                            final prescription = Patientsprescriptions[index];
                            // Basic error handling: Check if diagnosis and instructions are not null
                            if (prescription.diagnosis == null ||
                                prescription.instructions == null) {
                              return InkWell(
                                onTap: () {
                                  print(
                                      'tapped on prescription with ID: ${prescription.prescription_id}');
                                },
                                child: const ListTile(
                                  title: Text(
                                      'Error loading prescription details.'),
                                  subtitle:
                                      Text('Please check the data source.'),
                                ),
                              );
                            }
                            return InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) =>
                                //         PrescriptionDetailPage(
                                //             prescriptionId:
                                //                 prescription.prescription_id),
                                //   ),
                                // );
                              },
                              child: ListTile(
                                title: Text(
                                    'Diagnosis: ${prescription.diagnosis ?? 'N/A'}'),
                                subtitle: Text(
                                    'Instructions: ${prescription.instructions ?? 'N/A'}'),
                                // Add more details if needed
                              ),
                            );
                          },
                        ),
                ),
                // Container(
                //   height: 300,
                //   child: Patientsprescriptions.isEmpty
                //       ? Center(
                //           child: Patientsprescriptions.isEmpty
                //               ? const CircularProgressIndicator()
                //               : const Text('No prescriptions available.'),
                //         )
                //       : ListView.builder(
                //           itemCount: Patientsprescriptions.length,
                //           itemBuilder: (context, index) {
                //             final prescription = Patientsprescriptions[index];
                //             // Basic error handling: Check if diagnosis and instructions are not null
                //             if (prescription.diagnosis == null ||
                //                 prescription.instructions == null) {
                //               return InkWell(
                //                 onTap: () {
                //                   print(
                //                       'tapped on prescription with ID: ${prescription.prescription_id}');
                //                 },
                //                 child: const ListTile(
                //                   title: Text(
                //                       'Error loading prescription details.'),
                //                   subtitle:
                //                       Text('Please check the data source.'),
                //                 ),
                //               );
                //             }
                //             return InkWell(
                //               onTap: () {
                //                 // Navigator.push(
                //                 //   context,
                //                 //   MaterialPageRoute(
                //                 //     builder: (context) =>
                //                 //         PrescriptionDetailPage(
                //                 //             prescriptionId:
                //                 //                 prescription.prescription_id),
                //                 //   ),
                //                 // );
                //               },
                //               child: ListTile(
                //                 title: Text(
                //                     'Diagnosis: ${prescription.diagnosis ?? 'N/A'}'),
                //                 subtitle: Text(
                //                     'Instructions: ${prescription.instructions ?? 'N/A'}'),
                //                 // Add more details if needed
                //               ),
                //             );
                //           },
                //         ),
                // ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Column(
                        children: [
                          Text('Duration:   10 days  Status 6 days remaining'),
                          Text('Doctors name:    Evin Masi,     Aga Khan'),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Builder(builder: (context) {
                          return Row(children: <Widget>[
                            Container(
                              height: 200,
                              width: 300,
                              child: Image.asset('assets/images/logo.jpeg'),
                            ),
                            Container(
                              height: 200,
                              width: 300,
                              child: Image.asset('assets/images/logo.jpeg'),
                            ),
                            Container(
                              height: 200,
                              width: 300,
                              child: Image.asset('assets/images/logo.jpeg'),
                            ),
                          ]);
                        }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text('Name         Amoxillin'),
                      const Text('Doage         500mg'),
                      const Text('frequecy         3 times a day'),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Missed prescriptions',
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
