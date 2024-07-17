import 'package:flutter/material.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/services/plate_services.dart';
import 'package:vma_frontend/src/services/visitor_services.dart';

class ManageVisitorsScreen extends StatefulWidget {
 
  final List<Map<String, dynamic>>? visitorLogs;

  const ManageVisitorsScreen({super.key, this.visitorLogs});
  @override
  ManageVisitorsScreenState createState() => ManageVisitorsScreenState();
}

class ManageVisitorsScreenState extends State<ManageVisitorsScreen> {
  
  late DateTime startDate;
  late DateTime endDate;
  int numberOfVisitors = 1;
  List<TextEditingController> visitorControllers = [];
  List<Widget> visitorNameFields = [];
  bool bringCar = false;
  String? errorMessage;
  late List<String> selectedPlateNumbers = List.filled(numberOfCars, '1 AA');
  TextEditingController purposeController = TextEditingController();

  bool showVisitorError = false;
  bool showPurposeError = false;
  bool showHostError = false;
  List<String> plateRegions = [];
  List<String> plateCodes = [];
  List<Widget> plateNumberFields = [];
  int numberOfCars = 0;
  List<Map<String, dynamic>>? editVisitorLogs;
  
  
  void setVisitorData(Map<String, dynamic> userData) {
  print("setVisitorData(widget.visitorLogs![0]); is setted $userData");
  setState(() {

    if (userData['names'] != null && userData['names'] is List) {
      numberOfVisitors = userData['name'].length;
      updateVisitorNameFields(); 

      for (int i = 0; i < numberOfVisitors; i++) {
        if (i >= visitorControllers.length) {
          visitorControllers.add(TextEditingController());
        }
        visitorControllers[i].text = userData['names'][i];
      }
    } else {
      // Handle the case where userData['names'] is null or not a List
      numberOfVisitors = 1;
      visitorControllers.clear();
    }

    purposeController.text = userData['purpose'] ?? '';
    
    startDate = DateTime.tryParse(userData['startDate']) ?? DateTime.now();
    endDate = DateTime.tryParse(userData['endDate']) ?? DateTime.now();
    bringCar = userData['bringCar'] == "true" ? true : false;

    if (userData['selectedPlateNumbers'] != null && userData['selectedPlateNumbers'] is List) {
      selectedPlateNumbers = List<String>.from(userData['selectedPlateNumbers']);
    } else {
      selectedPlateNumbers.clear();
    }

    if (userData['possessions'] != null && userData['possessions'] is List) {
  possessionCheckedState = List<bool>.from(userData['possessions'].map((item) => item['checked']));
} else {
  possessionCheckedState = List.filled(5, false);
}


    updatePlateNumberFields();
  });
  print("visitor data is set");
}

  List<bool> possessionCheckedState = [false, false, false, false, false];
  
  final TextEditingController _flashDriveController = TextEditingController();
  final TextEditingController _hardDiskController = TextEditingController();
  final TextEditingController _laptopController = TextEditingController();
  final TextEditingController _tabletController = TextEditingController();
  final TextEditingController _mobilePhonesController = TextEditingController();

  void handlePossessionCheckboxChange(int index, bool newValue) {
    setState(() {
      possessionCheckedState[index] = newValue;

      
    });
  }

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
    loadData();
    print("widget.visitorLogs: ") ;
    print(widget.visitorLogs) ;
    if (widget.visitorLogs != null && widget.visitorLogs!.isNotEmpty) {
      //setVisitorData(widget.visitorLogs![0]);
      print("widget.visitorLogs![0]: ") ;
      print(widget.visitorLogs![0]) ;
    }
    
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

  void addVisitor({Visitor? visitor}) async {
    try {
      final visitorService = VisitorService();

      final List<String> items = [
        'Flash Drive',
        'Hard Disk',
        'Laptop',
        'Tablet',
        'Mobile Phones'
      ];

      final List<String> names =
          visitorControllers.map((controller) => controller.text).toList();

      final List<Possession> possessions = possessionCheckedState
          .asMap()
          .entries
          .where((entry) => entry.value)
          .map((entry) => Possession(
                item: items[entry.key],
                
              ))
          .toList();

      final visitor = Visitor(
        // id: "1234",
        numberOfVisitors: numberOfVisitors,
        names: names,
        purpose: purposeController.text,

        startDate: startDate,
        endDate: endDate,
        bringCar: bringCar,
        selectedPlateNumbers: selectedPlateNumbers,
        possessions: possessions,
        approved: false,
        declined: false,
        declineReason: ' ',
        isInside: false,
        hasLeft: false,
      );
        var vid = visitor.id;
        print("visitorID: , $vid");
      if (visitor.id != null) {
        print("visitor: , $visitor");
        // Update existing visitor
        await visitorService.updateVisitor(
          context: context,
          visitorId: visitor.id as String,
          names: names,
          purpose: purposeController.text,
          
          startDate: startDate,
          endDate: endDate,
          bringCar: bringCar,
          selectedPlateNumbers: selectedPlateNumbers,
          possessions: possessions,
          numberOfVisitors: numberOfVisitors,
          approved: visitor.approved,
          declined: visitor.declined,
          declineReason: visitor.declineReason,
          isInside: visitor.isInside,
          hasLeft: visitor.hasLeft,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visitor updated')),
        );
      } else {
        // Add new visitor
        await visitorService.createVisitor(
          context: context,

          names: names,
          purpose: purposeController.text,

          startDate: startDate,
          endDate: endDate,
          bringCar: bringCar,
          selectedPlateNumbers: selectedPlateNumbers,
          possessions: possessions,
          numberOfVisitors: numberOfVisitors,
          approved: false, // Default value for approved
          declined: false,
          declineReason: '',
          hasLeft: false,
          isInside: false
        );

        print("visitorsss: , $visitor");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request sent')),
        );
      }
      // Clear form fields
      setState(() {
        showVisitorError = false;

        startDate = DateTime.now();
        endDate = DateTime.now();
        numberOfVisitors = 1;
        bringCar = false;
        possessionCheckedState = List.filled(5, false);
        
        visitorControllers.forEach((controller) => controller.clear());
        _flashDriveController.clear();
        _hardDiskController.clear();
        _laptopController.clear();
        _tabletController.clear();
        _mobilePhonesController.clear();
        selectedPlateNumbers.clear();
      });
    } catch (e) {
      print('Failed to send request: $e');
    }
  }

  Widget build(BuildContext context) {
    print("widget vistor logs");
    print("widget vistor logs ${widget.visitorLogs}");
    if (widget.visitorLogs != null && widget.visitorLogs!.isNotEmpty) {
      setVisitorData(widget.visitorLogs![0]);}
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Visitors',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Constants.customColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                // Row(
                //   children: [
                //     const Text(
                //       'Name of Host: ',
                //       style: TextStyle(
                //         fontSize: 16.0,
                //       ),
                //     ),
                //     const SizedBox(width: 12.0),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         DropdownButton<String>(
                //           value: selectedHostName,
                //           onChanged: handleHostChange,
                //           items: [
                //             '',
                //             'Mr X',
                //             'Mr Y',
                //             'Mr Z',
                //           ].map((value) {
                //             return DropdownMenuItem<String>(
                //               value: value,
                //               child: Text(
                //                 value.isNotEmpty ? value : 'Select Host',
                //                 style: const TextStyle(
                //                   fontWeight: FontWeight.w100,
                //                   fontSize: 14.0,
                //                 ),
                //               ),
                //             );
                //           }).toList(),
                //         ),
                //         if (showHostError)
                //           const Text(
                //             "This field can't be empty",
                //             style: TextStyle(color: Colors.red, fontSize: 12.0),
                //           ),
                //       ],
                //     ),
                //   ],
                // ),
                
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
                ElevatedButton(
                  onPressed: addVisitor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.customColor,

                    elevation: 3,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Button border radius
                    ),
                  ),
                  child: const Text(
                    'Add Visitor',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
