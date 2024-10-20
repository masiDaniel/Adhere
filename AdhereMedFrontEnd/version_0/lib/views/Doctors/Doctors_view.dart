import 'package:flutter/material.dart';
import 'package:version_0/components/sutom_button.dart';
import 'package:version_0/models/prescriptions.dart';
import 'package:version_0/services/post_prescription_service.dart';
import 'package:version_0/services/user_log_in_service.dart';
import 'package:version_0/services/user_log_out_service.dart';
import 'package:version_0/views/Doctors/medication_prescription.dart';
import 'package:version_0/views/prescription_form.dart';
import 'package:intl/intl.dart';

///
///use the mobile number as an identifier to populate the data.
///
///
class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  List<prescriptionDetails> Doctorsprescriptions = [];
  @override
  void initState() {
    super.initState();
    fetchDoctorsPrescriptions();
  }

  Future<void> fetchDoctorsPrescriptions() async {
    List<prescriptionDetails> data = await getDoctorPrescriptions();
    setState(() {
      Doctorsprescriptions = data;
    });
  }

  Future<void> _logout() async {
    try {
      await logoutUser();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print("error logging out: $e");
    }
  }

  String greet() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat.yMMMMd().format(DateTime.now()); // format the current date

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/splash.png',
                          ),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Icon(
                  Icons.calendar_today,
                  size: 30, // adjust the size as needed
                  color: Colors.blue, // adjust the color as needed
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${greet()}, Dr. $firstName',
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 70,
              width: 400,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 3, 173, 185),
                  borderRadius: BorderRadius.circular(24)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Tooltip(
                    message: 'Notifications',
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        )),
                  ),
                  Tooltip(
                    message: 'Settings',
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        )),
                  ),
                  Tooltip(
                    message: 'Log Out',
                    child: IconButton(
                        onPressed: _logout,
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // more buttons can be added based on the requirements.
                  CustomButton(
                      buttonText: "Prescribe",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrescriptionFormPage()));
                      },
                      width: 120,
                      height: 50,
                      color: const Color(0xFF003A45)),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            /// the button below when pressed shoul give the doctor relevant information
            /// the information will be displayed immediately after the button hence should be dynamic
            ///

            const SizedBox(
              height: 20,
            ),
            const Text(
              'Prescriptions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            Expanded(
              child: Container(
                child: Doctorsprescriptions.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: Doctorsprescriptions.length,
                        itemBuilder: (context, index) {
                          final prescription = Doctorsprescriptions[index];

                          // Basic error handling: Check if diagnosis and instructions are not null
                          if (prescription.diagnosis == null ||
                              prescription.instructions == null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical:
                                      8.0), // Space on sides and between tiles
                              child: InkWell(
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
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical:
                                    8.0), // Space on sides and between tiles
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PrescriptionDetailPage(
                                            prescriptionId:
                                                prescription.prescription_id),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    30.0), // Circular radius
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors
                                        .white, // Background color for tile
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.medication),
                                    trailing: const Icon(
                                        Icons.arrow_forward_outlined),
                                    title: Text(
                                      'Diagnosis: ${prescription.diagnosis ?? 'N/A'}',
                                    ),
                                    subtitle: Text(
                                      'Instructions: ${prescription.instructions ?? 'N/A'}',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class medicalData {
  final String doctorName;
  final int prescriptionCount;

  medicalData(this.doctorName, this.prescriptionCount);
}
