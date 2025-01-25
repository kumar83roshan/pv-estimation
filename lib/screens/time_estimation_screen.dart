import 'package:flutter/material.dart';
import '../services/estimation_service.dart';

class TimeEstimationScreen extends StatelessWidget {
  final Map<String, dynamic> inputData;

  const TimeEstimationScreen({super.key, required this.inputData});

  @override
  Widget build(BuildContext context) {
    final estimationService = EstimationService();

    // Extract input data
    final eqNo = inputData["eqNo"] ?? "N/A";
    final tagNo = inputData["tagNo"] ?? "N/A";
    final numberOfVessels = inputData["numberOfVessels"] ?? 1;
    final thickness = inputData["thickness"] ?? 0.0;
    final diameter = inputData["diameter"] ?? 0.0;
    final length = inputData["length"] ?? 0.0;
    final nozzles = inputData["nozzles"] ?? [];
    final includeExternal = inputData["includeExternal"] ?? false;
    final includeInternal = inputData["includeInternal"] ?? false;
    final supportType = inputData["supportType"] ?? "None";
    final skirtThickness = inputData["skirtThickness"];
    final skirtDiameter = inputData["skirtDiameter"];
    final skirtLength = inputData["skirtLength"];
    final material = inputData["material"] ?? "Carbon Steel";

    // Calculate fabrication details for multiple vessels
    final vesselDetails = estimationService.calculateMultipleVesselFabricationTimesWithBreakdown(
      numberOfVessels: numberOfVessels,
      thickness: thickness,
      diameter: diameter,
      length: length,
      nozzles: nozzles,
      includeExternal: includeExternal,
      includeInternal: includeInternal,
      supportType: supportType,
      skirtThickness: skirtThickness,
      skirtDiameter: skirtDiameter,
      skirtLength: skirtLength,
      material: material,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fabrication Time Estimation"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Container(
        color: Colors.white, // Ensure the background is white
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // EQ No. and Tag No.
              Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                color: Colors.white, // White background for the card
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "EQ No.: $eqNo",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Tag No.: $tagNo",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              // Vessel Details
              ...vesselDetails.asMap().entries.map((entry) {
                final index = entry.key;
                final vessel = entry.value;
                final vesselName = vessel["Vessel"];
                final totalTime = vessel["Total Time (days)"];
                final activities = vessel["Activities"] as Map<String, double>;

                if (index == 0) {
                  // Detailed breakdown for Vessel 1
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    color: Colors.white, // White background for the card
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$vesselName - Total Time: $totalTime days",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Breakdown of Activities:",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Table(
                            border: TableBorder.all(color: Colors.grey, width: 1),
                            columnWidths: const {
                              0: FlexColumnWidth(3),
                              1: FlexColumnWidth(1),
                            },
                            children: [
                              const TableRow(
                                decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Activity",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Days",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              ...activities.entries.map(
                                    (entry) => TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(entry.key),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        entry.value.toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Summary for other vessels
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    color: Colors.white, // White background for the card
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "$vesselName - Total Time: $totalTime days",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
              }),

              // Remarks Section
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Remarks:\n"
                        "1. Shop load factor is NOT considered.\n"
                        "2. Calculations as per the following Multitex’s characteristics:\n"
                        "   a. Welder Electrode Consumption Rate\n"
                        "   b. Rolling Capacity\n"
                        "   c. Fitter's Expertise\n"
                        "3. Fabrication Time may vary (Assumption Only).\n"
                        "4. Procurement Cycle not considered in Time Estimation.",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
