import 'package:flutter/material.dart';
import 'package:version_0/components/sutom_button.dart';
import 'package:version_0/models/prescriptions.dart';
import 'package:version_0/services/post_prescription_service.dart';
import 'package:version_0/services/user_log_in_service.dart';
import 'package:version_0/services/user_log_out_service.dart';
import 'package:version_0/views/medication_prescription.dart';
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
                  CustomButton(
                      buttonText: "Report",
                      onPressed: () {},
                      width: 120,
                      height: 50,
                      color: const Color(0xFF003A45)),
                  const SizedBox(
                    width: 20,
                  ),
                  CustomButton(
                      buttonText: "Report",
                      onPressed: () {},
                      width: 120,
                      height: 50,
                      color: const Color(0xFF003A45)),
                ],
              ),
            ),

            // SfCartesianChart(
            //   primaryXAxis: const CategoryAxis(),
            //   title: const ChartTitle(
            //       text: 'Your Prescription Statistics',
            //       textStyle: TextStyle(
            //           color: Colors.blue, fontWeight: FontWeight.bold)),
            //   legend: const Legend(isVisible: true),
            //   tooltipBehavior: _tooltipBehavior,
            //   series: <LineSeries<medicalData, String>>[
            //     LineSeries<medicalData, String>(
            //       xValueMapper: (medicalData medical, _) => medical.doctorName,
            //       yValueMapper: (medicalData medical, _) =>
            //           medical.prescriptionCount,
            //       dataSource: <medicalData>[
            //         medicalData('daniel', 3),
            //         medicalData('paul', 0),
            //         medicalData('mark', 1),
            //         medicalData('denzel', 12),
            //         medicalData('bishop', 9),
            //         medicalData('nick', 0),
            //         medicalData('rick', 2),
            //         medicalData('jeff', 5),
            //       ],
            //       dataLabelSettings: const DataLabelSettings(isVisible: true),
            //     )
            //   ],
            // ),
            const SizedBox(
              height: 20,
            ),

            /// the button below when pressed shoul give the doctor relevant information
            /// the information will be displayed immediately after the button hence should be dynamic
            ///

            const SizedBox(
              height: 20,
            ),
            const Text('prescriptions'),
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
                            return InkWell(
                              onTap: () {
                                print(
                                    'tapped on prescription with ID: ${prescription.prescription_id}');
                              },
                              child: const ListTile(
                                title:
                                    Text('Error loading prescription details.'),
                                subtitle: Text('Please check the data source.'),
                              ),
                            );
                          }
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrescriptionDetailPage(
                                      prescriptionId:
                                          prescription.prescription_id),
                                ),
                              );
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
            ),
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
