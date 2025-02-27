import 'package:flutter/material.dart';
import '../screens/time_estimation_screen.dart';

class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  InputFormState createState() => InputFormState();
}

class InputFormState extends State<InputForm> {
  final _thicknessController = TextEditingController();
  final _diameterController = TextEditingController();
  final _lengthController = TextEditingController();
  final _numberOfVesselsController = TextEditingController();
  final _legLengthController = TextEditingController();
  final _eqNoController = TextEditingController();
  final _tagNoController = TextEditingController();

  bool includeExternal = false;
  bool includeInternal = false;
  String supportType = "None"; // Default support type
  String selectedMaterial = "Carbon Steel"; // Default material
  String vesselOrientation = "Horizontal"; // Default vessel orientation

  final _skirtThicknessController = TextEditingController();
  final _skirtDiameterController = TextEditingController();
  final _skirtLengthController = TextEditingController();

  // List of Nozzles (Size and Quantity)
  List<Map<int, int>> nozzles = [];

  void addNozzle() {
    setState(() {
      nozzles.add({0: 0}); // Add a new nozzle with size 0 and quantity 0
    });
  }

  void deleteNozzle(int index) {
    setState(() {
      nozzles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Pressure Vessel Fabrication Time Estimation",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: _buildLightYellowInputField(
                            controller: _eqNoController,
                            labelText: "Eq No.",
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 200,
                          child: _buildLightYellowInputField(
                            controller: _tagNoController,
                            labelText: "Tag No.",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildLabeledInputField("Thickness (mm)", _thicknessController),
                    _buildLabeledInputField("Vessel Inside Diameter (mm)", _diameterController),
                    _buildLabeledInputField("Vessel Length (mm)", _lengthController),
                    _buildLabeledInputField("Number of Vessels", _numberOfVesselsController),
                    const SizedBox(height: 20),
                    const Text("Nozzles:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: nozzles.length,
                      itemBuilder: (context, index) {
                        final nozzle = nozzles[index];
                        final size = nozzle.keys.first;
                        final quantity = nozzle.values.first;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: size.toString(),
                                  decoration: _lightYellowBoxDecoration("Nozzle Size (Inch)"),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      nozzles[index] = {int.tryParse(value) ?? 0: quantity};
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  initialValue: quantity.toString(),
                                  decoration: _lightYellowBoxDecoration("Quantity"),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      nozzles[index] = {size: int.tryParse(value) ?? 0};
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteNozzle(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: addNozzle,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        textStyle: const TextStyle(fontSize: 16),
                        minimumSize: const Size(150, 40),
                      ),
                      child: const Text("Add Nozzle"),
                    ),
                    const SizedBox(height: 20),
                    const Text("Attachment:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("External"),
                            value: includeExternal,
                            onChanged: (value) {
                              setState(() {
                                includeExternal = value ?? false;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("Internal"),
                            value: includeInternal,
                            onChanged: (value) {
                              setState(() {
                                includeInternal = value ?? false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildVesselOrientationSection(),
                    const SizedBox(height: 20),
                    _buildDropdownSection("MOC (Material of Construction):", selectedMaterial, [
                      "Carbon Steel",
                      "Stainless Steel",
                      "Duplex Stainless Steel",
                      "Low Temperature Carbon Steel",
                      "Low Alloy Steel",
                    ], (newValue) {
                      setState(() {
                        selectedMaterial = newValue!;
                      });
                    }),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          "Supports:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 170),
                        SizedBox(
                          width: 150,
                          child: Container(
                            color: Colors.white,
                            child: DropdownButton<String>(
                              value: supportType,
                              isExpanded: true,
                              items: [
                                "None",
                                "Skirt",
                                "Leg Support",
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  supportType = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (supportType == "Skirt") ...[
                      _buildLabeledInputField("Skirt Thickness (mm)", _skirtThicknessController),
                      _buildLabeledInputField("Skirt Diameter (mm)", _skirtDiameterController),
                      _buildLabeledInputField("Skirt Length (mm)", _skirtLengthController),
                    ],
                    if (supportType == "Leg Support")
                      _buildLabeledInputField("Leg Length (mm)", _legLengthController),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          final inputData = {
                            "eqNo": _eqNoController.text,
                            "tagNo": _tagNoController.text,
                            "thickness": double.tryParse(_thicknessController.text),
                            "diameter": double.tryParse(_diameterController.text),
                            "length": double.tryParse(_lengthController.text),
                            "numberOfVessels": int.tryParse(_numberOfVesselsController.text),
                            "nozzles": nozzles,
                            "includeExternal": includeExternal,
                            "includeInternal": includeInternal,
                            "supportType": supportType,
                            "skirtThickness": double.tryParse(_skirtThicknessController.text),
                            "skirtDiameter": double.tryParse(_skirtDiameterController.text),
                            "skirtLength": double.tryParse(_skirtLengthController.text),
                            "legLength": double.tryParse(_legLengthController.text),
                            "material": selectedMaterial,
                            "vesselOrientation": vesselOrientation,
                          };

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimeEstimationScreen(inputData: inputData),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(200, 50),
                        ),
                        child: const Text(
                          "Calculate",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: Image.asset(
                'assets/images/pressurevessel.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            decoration: _lightYellowBoxDecoration(""),
          ),
        ],
      ),
    );
  }

  Widget _buildVesselOrientationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Vessel Orientation:", style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text("Horizontal"),
                value: vesselOrientation == "Horizontal",
                onChanged: (value) {
                  setState(() {
                    vesselOrientation = value == true ? "Horizontal" : "Vertical";
                  });
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text("Vertical"),
                value: vesselOrientation == "Vertical",
                onChanged: (value) {
                  setState(() {
                    vesselOrientation = value == true ? "Vertical" : "Horizontal";
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownSection(String label, String currentValue, List<String> items, ValueChanged<String?> onChanged) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 30),
        Container(
          color: Colors.white,
          child: DropdownButton<String>(
            value: currentValue,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  InputDecoration _lightYellowBoxDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: const Color(0xFFFFF9C4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildLightYellowInputField({required TextEditingController controller, required String labelText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: _lightYellowBoxDecoration(labelText),
      ),
    );
  }
}
