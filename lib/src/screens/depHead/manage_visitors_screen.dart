import 'package:flutter/material.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/services/plate_services.dart';
import 'package:vma_frontend/src/services/visitor_services.dart';
import 'package:vma_frontend/src/models/plate_region.dart';
import 'package:vma_frontend/src/models/plate_code.dart';
import 'package:intl/intl.dart';


class ManageVisitorsScreen extends StatefulWidget {
 
  final List<Map<String, dynamic>>? visitorLogs;

  const ManageVisitorsScreen({super.key, this.visitorLogs});
 
  @override
  ManageVisitorsScreenState createState() => ManageVisitorsScreenState();
}

class ManageVisitorsScreenState extends State<ManageVisitorsScreen> {
  late String? id;
  late String v_id;
  late DateTime startDate;
  late DateTime endDate;
  int numberOfVisitors = 1;
  List<TextEditingController> visitorControllers = [];
  List<Widget> visitorNameFields = [];
  Map<String, dynamic>? _visitorLog;
  bool bringCar = false;
  bool approved = false;
  String? errorMessage;
  late List<String> selectedPlateNumbers = List.filled(numberOfCars, '');
  TextEditingController purposeController = TextEditingController();
  bool showVisitorError = false;
  bool showPurposeError = false;
  
  List<String> plateRegions = [];
  List<String> plateCodes = [];
  List<Widget> plateNumberFields = [];
  List<String> visitorNames = [];
  int numberOfCars = 0;
  List<Map<String, dynamic>>? editVisitorLogs; 
  late Visitor visitor;

void  setVisitorData(Map<String, dynamic> visitorData) {

    visitor = Visitor.fromJson22(visitorData);
   print("objecttttt");
    print(visitor.id);
    //v_id = visitorData.id;
    print(visitor.names);
    setState(() {
      id = visitor.id;
      startDate = visitor.startDate;
      endDate = visitor.endDate;
      numberOfVisitors = visitor.numberOfVisitors;
      visitorNames = visitor.names;
      purposeController.text = visitor.purpose ?? '';
      bringCar = visitor.bringCar;
      approved = visitor.approved;
      selectedPlateNumbers = visitor.selectedPlateNumbers;
      updateVisitorNameFields();
      updatePossessionCheckboxes();
      updatePlateNumberFields();
    });
  }
  
  List<bool> possessionCheckedState = [false, false, false, false, false];
  late final List<PlateCode> _plateCodes = [];
  late final List<PlateRegion> _plateRegions = [];

  final TextEditingController _flashDriveController = TextEditingController();
  final TextEditingController _hardDiskController = TextEditingController();
  final TextEditingController _laptopController = TextEditingController();
  final TextEditingController _tabletController = TextEditingController();
  final TextEditingController _mobilePhonesController = TextEditingController();
List<Possession> possessions = [];
  void handlePossessionCheckboxChange(int index, bool newValue) {
    setState(() {
      possessionCheckedState[index] = newValue;

      
    });
  }
void updatePossessionCheckboxes() {
    possessions = [];
    for (int i = 0; i < possessionCheckedState.length; i++) {
      if (possessionCheckedState[i]) {
        possessions.add(Possession(item: getPossessionName(i)));
      }
    }
  }
  String getPossessionName(int index) {
    switch (index) {
      case 0:
        return 'Flash Drive';
      case 1:
        return 'Hard Disk';
      case 2:
        return 'Laptop';
      case 3:
        return 'Tablet';
      case 4:
        return 'Mobile Phones';
      default:
        return '';
    }
  }
  bool isEditMode = false;
  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
    loadData();
   
    if (widget.visitorLogs != null && widget.visitorLogs!.isNotEmpty) {
      setVisitorData(widget.visitorLogs![0]);
    isEditMode = true;      
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
  print("Main field called");
  print(numberOfVisitors);
    visitorNameFields.clear();
    visitorControllers.clear();
    for (int i = 0; i < numberOfVisitors; i++) {
      TextEditingController controller = TextEditingController();
      print(visitorNames);
      if(visitorNames.isNotEmpty){
      controller.text = visitorNames[i];
      }
      controller.text = i.toString();
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
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\-\'\.,]+"))
            ],
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
                    DropdownButton<PlateCode>(
                      value: _plateCodes.isNotEmpty ? _plateCodes[0] : null,
                      onChanged: (newValue) {
                        setState(() {
                          _plateCodes[i] = newValue ?? PlateCode(id: '0', code: '', description: '');
                        });
                      },
                      items: _plateCodes
                          .map((value) => DropdownMenuItem<PlateCode>(
                                value: value,
                                child: Text(value.code),
                              ))
                          .toList(),
                    ),
                    const SizedBox(width: 8.0),
                    DropdownButton<PlateRegion>(
                      value: _plateRegions.isNotEmpty ? _plateRegions[0] : null,
                      onChanged: (newValue) {
                        setState(() {
                          _plateRegions[i] = newValue ?? PlateRegion(id: '0', region: '');
                        });
                      },
                      items: _plateRegions
                          .map((value) => DropdownMenuItem<PlateRegion>(
                                value: value,
                                child: Text(value.region),
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
  print("visitor names: ..");
  print(visitor?.names);
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
      numberOfVisitors: numberOfVisitors,
      names: names,
      purpose: purposeController.text,
      startDate: startDate,
      endDate: endDate,
      bringCar: bringCar,
      selectedPlateNumbers: selectedPlateNumbers,
      possessions: possessions,
      approved: approved,
      declined: false,
      declineReason: ' ',
      isInside: false,
      hasLeft: false,
    );
  
  if (widget.visitorLogs != null && widget.visitorLogs!.isNotEmpty) {
      Visitor  vis = Visitor.fromJson22(widget.visitorLogs![0]);
      print("Updating visitor of id before check: ${vis.id}");

    if (vis.id != null) {
      print("Updating visitor of id: ${vis.id}");
      // Update existing visitor
      await visitorService.updateVisitor(
        context: context,
        visitorId: vis.id!,
        names: names,
        purpose: purposeController.text,
        startDate: startDate,
        endDate: endDate,
        bringCar: bringCar,
        selectedPlateNumbers: selectedPlateNumbers,
        possessions: possessions,
        numberOfVisitors: numberOfVisitors,
        approved: approved,
        declined: visitor.declined,
        declineReason: visitor.declineReason,
        isInside: visitor.isInside,
        hasLeft: visitor.hasLeft,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visitor updated')),
      );
    }} else {
      print("Adding new visitor");
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
        isInside: false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request sent')),
      );
    }

    // Clear form fields
    setState(() {
      showVisitorError = false;

      startDate = DateTime.now();
      endDate = DateTime.now();
      numberOfVisitors = numberOfVisitors;
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
   if (isEditMode && widget.visitorLogs != null) {
      final visitorData = widget.visitorLogs![0];
      _visitorLog = visitorData;
    }

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
                            if (selectedDate != null) {
                              setState(() {
                                startDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Constants.customColor,
                          ),
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(startDate),
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
                                endDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Constants.customColor,
                          ),
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(endDate),
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
              const SizedBox(height: 16.0),
              Center(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Possessions:',
                          style: TextStyle(fontSize: 16),
                        ),
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
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  child: Text(
    isEditMode ? 'Update Visitor' : 'Add Visitor',
    style: const TextStyle(color: Colors.white),
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