import 'package:flutter/material.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/services/plate_services.dart';
import 'package:vma_frontend/src/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageVisitorsScreen extends StatefulWidget {
  @override
  _ManageVisitorsScreenState createState() => _ManageVisitorsScreenState();
}

class _ManageVisitorsScreenState extends State<ManageVisitorsScreen> {
  late DateTime startDate;
  late DateTime endDate;
  int numberOfVisitors = 1;
  List<TextEditingController> visitorControllers = [];
  List<Widget> visitorNameFields = [];
  bool bringCar = false;
  String? errorMessage;
  late List<String> selectedPlateNumbers = List.filled(numberOfCars, '1 AA');
  TextEditingController purposeController = TextEditingController();
  late Future<List<Visitor>> _visitorFuture;
  bool showVisitorError = false;
  bool showPurposeError = false;
  bool showHostError = false;
  List<String> plateRegions = [];
  List<String> plateCodes = [];
  List<Widget> plateNumberFields = [];
  int numberOfCars = 0;

  String selectedHostName = '';
  void handleHostChange(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedHostName = newValue;
      });
    }
  }

  List<bool> possessionCheckedState = [false, false, false, false, false];
  List<int> possessionQuantities = [0, 0, 0, 0, 0];
  final TextEditingController _flashDriveController = TextEditingController();
  final TextEditingController _hardDiskController = TextEditingController();
  final TextEditingController _laptopController = TextEditingController();
  final TextEditingController _tabletController = TextEditingController();
  final TextEditingController _mobilePhonesController = TextEditingController();

  void handlePossessionCheckboxChange(int index, bool newValue) {
    setState(() {
      possessionCheckedState[index] = newValue;

      if (!newValue) {
        possessionQuantities[index] = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _visitorFuture = fetchVisitors();
    startDate = DateTime.now();
    endDate = DateTime.now();
    loadData();
    visitorNameFields.add(TextField(
      decoration: InputDecoration(
        labelText: 'Visitor Name',
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Constants.customColor),
        ),
      ),
    ));
  }

  Future<void> loadData() async {
    try {
      final regions = await fetchPlateRegions();
      final codes = await fetchPlateCodes();
      setState(() {
        plateRegions = regions;
        plateCodes = codes;
      });
    } catch (e) {
      print('Failed to load data: $e');
    }
  }

  void updateVisitorNameFields() {
    visitorNameFields.clear();
    visitorControllers.clear();
    List<String> visitorNames = [];
    for (int i = 0; i < numberOfVisitors; i++) {
      TextEditingController controller = TextEditingController();
      visitorControllers.add(controller);
      visitorNameFields.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Visitor ${i + 1} Name',
              errorText: showVisitorError && controller.text.isEmpty
                  ? "Please enter visitor's name"
                  : null,
            ),
            onChanged: (_) {
              setState(() {
                visitorNames = visitorControllers
                    .map((controller) => controller.text)
                    .toList();
              });
            },
          ),
        ],
      ));
    }
    setState(() {});
  }

  void updatePlateNumberFields() {
    plateNumberFields.clear();
    for (int i = 0; i < numberOfCars; i++) {
      plateNumberFields.add(
        Padding(
          padding: const EdgeInsets.only(left: 75.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              const Text('Plate Number:'),
              Padding(
                padding: const EdgeInsets.only(left: 75.0),
                child: Row(
                  children: [
                    DropdownButton<String>(
                      value: plateCodes.isNotEmpty ? plateCodes[0] : null,
                      onChanged: (newValue) {
                        setState(() {
                          plateCodes[i] = newValue ?? '';
                        });
                      },
                      items: plateCodes
                          .map((value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                    ),
                    const SizedBox(width: 8.0),
                    SizedBox(
                      width: 100.0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(7),
                          ],
                          onChanged: (value) {
                            setState(() {
                              // Here you can handle the onChanged logic if needed
                            });
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<List<Visitor>> fetchVisitors() async {
    final response = await http.get(
      Uri.parse('${Constants.uri}/api/getVisitors'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Visitor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load visitors');
    }
  }

  Future<void> updateVisitorStatus(String id,
      {bool? approved, bool? declined}) async {
    final response = await http.patch(
      Uri.parse('${Constants.uri}/api/visitors/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        if (approved != null) 'approved': approved,
        if (declined != null) 'declined': declined,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update visitor status');
    }
  }

  // void approveVisitor(Visitor visitor) async {
  //   try {
  //     await updateVisitorStatus(visitor.id, approved: true, declined: false);
  //     setState(() {
  //       _visitorFuture = fetchVisitors();
  //     });
  //   } catch (error) {
  //     print('Error approving visitor: $error');
  //   }
  // }

  // void declineVisitor(Visitor visitor) async {
  //   try {
  //     await updateVisitorStatus(visitor.id, approved: false, declined: true);
  //     setState(() {
  //       _visitorFuture = fetchVisitors();
  //     });
  //   } catch (error) {
  //     print('Error declining visitor: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Visitors',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.customColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Start Date:'),
                          TextButton(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: startDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              print('date is selected ${selectedDate}');
                              if (selectedDate != null) {
                                print('date is selected ${selectedDate}');
                                setState(() {
                                  startDate = selectedDate;
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Constants.customColor,
                            ),
                            child: Text(
                              '${startDate.year}-${startDate.month}-${startDate.day}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('End Date:'),
                          TextButton(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: endDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  endDate = selectedDate;
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Constants.customColor,
                            ),
                            child: Text(
                              '${endDate.year}-${endDate.month}-${endDate.day}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Text('Number of Visitors:'),
                    const SizedBox(width: 8.0),
                    DropdownButton<int>(
                      value: numberOfVisitors,
                      onChanged: (newValue) {
                        setState(() {
                          numberOfVisitors = newValue!;
                          updateVisitorNameFields();
                        });
                      },
                      items: List.generate(
                        15,
                        (index) => DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ...visitorNameFields,
                const SizedBox(height: 16.0),
                const Text(
                  'Purpose of Visit: ',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: purposeController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.customColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.customColor),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.customColor),
                          ),
                          errorText: showPurposeError
                              ? "This field can't be empty"
                              : null,
                        ),
                        maxLines: null,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'Name of Host: ',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton<String>(
                          value: selectedHostName,
                          onChanged: handleHostChange,
                          items: [
                            '',
                            'Mr X',
                            'Mr Y',
                            'Mr Z',
                          ].map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.isNotEmpty ? value : 'Select Host',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 14.0,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (showHostError)
                          const Text(
                            "This field can't be empty",
                            style: TextStyle(color: Colors.red, fontSize: 12.0),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: Row(
                    children: [
                      // Column for possessions checkboxes and quantity fields
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Possessions:',
                            style: TextStyle(fontSize: 16),
                          ),
                          // Flash drive row
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: possessionCheckedState[0],
                                    onChanged: (newValue) {
                                      handlePossessionCheckboxChange(
                                          0, newValue ?? false);
                                    },
                                  ),
                                  const Text('Flash drive'),
                                ],
                              ),
                              if (possessionCheckedState[0])
                                SizedBox(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Quantity:',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          // Limit the quantity to 5
                                          int? quantity = int.tryParse(value);
                                          if (quantity != null &&
                                              quantity > 5) {
                                            quantity = 5;
                                            _flashDriveController.text = '5';
                                          }
                                          // Update the possession quantity
                                          possessionQuantities[0] =
                                              quantity ?? 0;
                                        },
                                        controller: _flashDriveController,
                                        maxLength: 1,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          // Hard Disk row
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: possessionCheckedState[1],
                                    onChanged: (newValue) {
                                      handlePossessionCheckboxChange(
                                          1, newValue ?? false);
                                    },
                                  ),
                                  const Text('Hard Disk'),
                                ],
                              ),
                              if (possessionCheckedState[1])
                                SizedBox(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Quantity:',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          // Limit the quantity to 5
                                          int? quantity = int.tryParse(value);
                                          if (quantity != null &&
                                              quantity > 5) {
                                            quantity = 5;
                                            _hardDiskController.text = '5';
                                          }
                                          // Update the possession quantity
                                          possessionQuantities[1] =
                                              quantity ?? 0;
                                        },
                                        controller: _hardDiskController,
                                        maxLength: 1,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          // Laptop row
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: possessionCheckedState[4],
                                    onChanged: (newValue) {
                                      handlePossessionCheckboxChange(
                                          4, newValue ?? false);
                                    },
                                  ),
                                  const Text('Mobile Phones'),
                                ],
                              ),
                              if (possessionCheckedState[4])
                                SizedBox(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Quantity:',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          // Limit the quantity to 15
                                          int? quantity = int.tryParse(value);
                                          if (quantity != null &&
                                              quantity > 15) {
                                            quantity = 15;
                                            _mobilePhonesController.text = '15';
                                          }
                                          // Update the possession quantity
                                          possessionQuantities[4] =
                                              quantity ?? 0;
                                        },
                                        controller: _mobilePhonesController,
                                        maxLength: 2,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 32.0),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tablet row
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: possessionCheckedState[3],
                                    onChanged: (newValue) {
                                      handlePossessionCheckboxChange(
                                          3, newValue ?? false);
                                    },
                                  ),
                                  const Text('Tablet'),
                                ],
                              ),
                              if (possessionCheckedState[3])
                                SizedBox(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Quantity:',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          // Limit the quantity to 15
                                          int? quantity = int.tryParse(value);
                                          if (quantity != null &&
                                              quantity > 15) {
                                            quantity = 15;
                                            _tabletController.text = '15';
                                          }
                                          // Update the possession quantity
                                          possessionQuantities[3] =
                                              quantity ?? 0;
                                        },
                                        controller: _tabletController,
                                        maxLength: 2,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          // Mobile Phones row
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: possessionCheckedState[2],
                                    onChanged: (newValue) {
                                      handlePossessionCheckboxChange(
                                          2, newValue ?? false);
                                    },
                                  ),
                                  const Text('Laptop'),
                                ],
                              ),
                              if (possessionCheckedState[2])
                                SizedBox(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Quantity:',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          // Limit the quantity to 15
                                          int? quantity = int.tryParse(value);
                                          if (quantity != null &&
                                              quantity > 15) {
                                            quantity = 15;
                                            _laptopController.text = '15';
                                          }
                                          // Update the possession quantity
                                          possessionQuantities[2] =
                                              quantity ?? 0;
                                        },
                                        controller: _laptopController,
                                        maxLength: 2,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Will they bring in a car?',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: bringCar,
                            onChanged: (value) {
                              setState(() {
                                bringCar = value ?? false;
                              });
                            },
                          ),
                          const Text('No'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: bringCar,
                            onChanged: (value) {
                              setState(() {
                                bringCar = value ?? false;
                              });
                            },
                          ),
                          const Text('Yes'),
                        ],
                      ),
                    ],
                  ),
                ),
                if (bringCar)
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 55.0),
                          child: Row(
                            children: [
                              const Text('How many?'),
                              const SizedBox(width: 8.0),
                              SizedBox(
                                width: 100.0, // Set the width of the text box
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      numberOfCars = int.tryParse(value) ?? 0;
                                      print("number of cars: ${numberOfCars}");
                                      updatePlateNumberFields();
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (numberOfCars > 0) ...plateNumberFields,
                      ],
                    ),
                  ),
                const SizedBox(height: 16.0),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     ElevatedButton(
                //       onPressed: () => approveVisitor(visitor),
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.green,
                //         elevation: 3,
                //         padding: const EdgeInsets.symmetric(vertical: 16.0),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(8.0),
                //         ),
                //       ),
                //       child: const Text(
                //         'Approve',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //     ElevatedButton(
                //       onPressed: () => declineVisitor(visitor),
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Color.fromARGB(255, 26, 6, 5),
                //         elevation: 3,
                //         padding: const EdgeInsets.symmetric(vertical: 16.0),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(8.0),
                //         ),
                //       ),
                //       child: const Text(
                //         'Decline',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
