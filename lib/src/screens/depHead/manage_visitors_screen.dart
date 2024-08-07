import 'package:flutter/material.dart';
import 'package:vma_frontend/src/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/services/visitor_services.dart';
import 'package:vma_frontend/src/models/plate_region.dart';
import 'package:vma_frontend/src/models/plate_code.dart';
import 'package:intl/intl.dart';
import 'package:vma_frontend/src/services/api_service.dart';
import 'package:vma_frontend/src/models/possessions.dart';
import 'package:vma_frontend/src/providers/user_provider.dart';
import 'package:vma_frontend/src/models/user.dart';
import 'package:vma_frontend/src/services/auth_services.dart';
import 'package:provider/provider.dart';
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
  List<String> possessionsList=[];
  Map<String, dynamic>? _visitorLog;
  bool bringCar = false;
  bool approved = false;
  String requestedBy='';
  String? errorMessage;
  late List<String> selectedPlateNumbers = List.filled(numberOfCars, '');
  TextEditingController purposeController = TextEditingController();
  bool showVisitorError = false;
  bool showPurposeError = false;
//   final userProvider = Provider.of<UserProvider>(context, listen: false);
// final user = userProvider.user;
// final requestedBy = '${user.fname} ${user.lname}, ${user.department}';

List<PlateCode> currentCodes = [];
List<PlateRegion> currentRegions = [];
List<TextEditingController> numberControllers = [];
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
   String split = visitorData['possessions'].toString(); // Use direct access to possessions field
  print('split: $split');

  if (split.isNotEmpty) {
    possessionsList = split.split(',').map((item) => item.trim()).toList();
  } else {
    possessionsList = [];
  }
  print('possessionsList: $possessionsList');
   // Initialize possessionCheckedState based on possessions in visitor data
  possessionCheckedState = possessionsList.map((item) {
    return visitor.possessions.any((possession) => possession.item == item);
  }).toList();
    // var split = visitorData.toString().split("possessions:")[1];
    // if(split.isNotEmpty){
    //   split = split.toString().split("}")[0];
    // }    
    // print('split: ${split}');
    // possessionsList = split.split(',').map((item) => item.trim()).toList();
    // //v_id = visitorData.id;
    // print('possessionsList: ${possessionsList}');

    //possessionCheckedState
    for (int i = 0; i < possessionsList.length; i++) {
      //possessionCheckedState[i] = true;
    }
// for (int i = 0; i < possessionCheckedState.length; i++) {
//     if (possessionCheckedState[i]) {
//       possessions.add(Possession(id: '', item: possessions[i].item));
//     }
//   }
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
      possessions = visitor.possessions;
      possessionCheckedState = possessions
      .map((possession) => true) // Set to true or false based on visitor's possessions
      .toList();
      updateVisitorNameFields();
      updatePossessionCheckboxes();
      updatePlateNumberFields();
    });
  }
  
  
  List<bool> possessionCheckedState = [];
  
List<Possession> possessions = [];
  
  void handlePossessionCheckboxChange(int index, bool newValue) {
    print("handlePossessionCheckboxChange");
    setState(() {
      possessionCheckedState[index] = newValue;
//  if (newValue) {
//       // Add possession if checked
//       possessions.add(Possession(id: '', item: possessionsList[index]));
//     } else {
//       // Remove possession if unchecked
//       possessions.removeWhere((possession) => possession.item == possessionsList[index]);
//     }
      
    });
  }

void onPlateCodeChanged(int index, PlateCode newCode) {
  setState(() {
    currentCodes[index] = newCode;
    updateSelectedPlateNumbers(index, newCode, currentRegions[index], numberControllers[index].text);
    print("onPlateCodeChanged called for Car $index: new code ${newCode.code}");
  });
}

void onPlateRegionChanged(int index, PlateRegion newRegion) {
  setState(() {
    currentRegions[index] = newRegion;
    updateSelectedPlateNumbers(index, currentCodes[index], newRegion, numberControllers[index].text);
    print("onPlateRegionChanged called for Car $index: new region ${newRegion.region}");
  });
}

void onPlateNumberChanged(int index, String newNumber) {
  setState(() {
    updateSelectedPlateNumbers(index, currentCodes[index], currentRegions[index], newNumber);
    print("onPlateNumberChanged called for Car $index: new number $newNumber");
  });
}

void updatePossessionCheckboxes() {
    possessions = [];
    print("updatePossessionCheckboxes is called");
    
    for (int i = 0; i < possessionCheckedState.length; i++) {
    if (possessionCheckedState[i]) {
      possessions.add(Possession(id: '', item: possessions[i].item));
    }
   
  print("Final possessions: $possessions");

  }
  //  for (int i = 0; i < possessionCheckedState.length; i++) {
  //   if (possessionCheckedState[i]) {
  //     possessions.add(Possession(id: '', item: possessionsList[i]));
  //   }
  // }
  }
  
  void initializePlateNumberFields() {
  for (int i = 0; i < numberOfCars; i++) {
    currentCodes.add(_plateCodes.isNotEmpty ? _plateCodes[0] : PlateCode(id: '0', code: '', description: ''));
    currentRegions.add(_plateRegions.isNotEmpty ? _plateRegions[0] : PlateRegion(id: '0', region: ''));
    numberControllers.add(TextEditingController());
    print("Initialized code: ${currentCodes[i].code}, region: ${currentRegions[i].region}");
  }
}
  bool isEditMode = false;
  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
    
    selectedPlateNumbers = List.filled(numberOfCars, '');
    loadData();
    // initializePlateNumberFields();
   
    if (widget.visitorLogs != null && widget.visitorLogs!.isNotEmpty) {
      setVisitorData(widget.visitorLogs![0]);
    isEditMode = true;      
    }
    
  }
List<PlateRegion> _plateRegions = [];
  List<PlateCode> _plateCodes = [];
 Future<void> loadData() async {
  try {
    final regions = await ApiService.fetchRegions();
    final codes = await ApiService.fetchPlateCodes();
    final fetchedPossessions = await ApiService.fetchPossessions();
    setState(() {
     _plateRegions = regions;
        _plateCodes = codes;
        possessions = fetchedPossessions;
        possessionCheckedState = List.filled(possessions.length, false);
    });
  } catch (e) {
    print('Failed to load data: $e');
    // Optionally show an error message to the user
    
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
      // controller.text = i.toString();
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
  numberControllers.clear();
  currentCodes.clear();
  currentRegions.clear();

  print("Updating Plate Number Fields");
  for (int i = 0; i < numberOfCars; i++) {
    TextEditingController numberController = TextEditingController();
    numberControllers.add(numberController);

    PlateCode selectedCode = _plateCodes.isNotEmpty ? _plateCodes[0] : PlateCode(id: '0', code: '', description: '');
    PlateRegion selectedRegion = _plateRegions.isNotEmpty ? _plateRegions[0] : PlateRegion(id: '0', region: '');
    currentCodes.add(selectedCode);
    currentRegions.add(selectedRegion);

    numberController.addListener(() {
      onPlateNumberChanged(i, numberController.text);
    });

    print("Adding Field for Car $i with code: ${selectedCode.code}, region: ${selectedRegion.region}");
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
                    value: currentCodes[i],
                    onChanged: (PlateCode? newValue) {
                      if (newValue != null) {
                        setState(() {
                          currentCodes[i] = newValue;
                          onPlateCodeChanged(i, newValue);
                        });
                        print("Code changed to ${newValue.code} for Car $i");
                      }
                    },
                    items: _plateCodes.map((value) => DropdownMenuItem<PlateCode>(
                      value: value,
                      child: Text(value.code),
                    )).toList(),
                  ),
                  const SizedBox(width: 8.0),
                  DropdownButton<PlateRegion>(
                    value: currentRegions[i],
                    onChanged: (PlateRegion? newValue) {
                      if (newValue != null) {
                        setState(() {
                          currentRegions[i] = newValue;
                          onPlateRegionChanged(i, newValue);
                        });
                        print("Region changed to ${newValue.region} for Car $i");
                      }
                    },
                    items: _plateRegions.map((value) => DropdownMenuItem<PlateRegion>(
                      value: value,
                      child: Text(value.region),
                    )).toList(),
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
                        controller: numberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(7),
                        ],
                        onChanged: (String value) {
                          setState(() {
                            updateSelectedPlateNumbers(i, currentCodes[i], currentRegions[i], value);
                          });
                          print("Number changed to $value for Car $i");
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
  void updateSelectedPlateNumbers(int index, PlateCode code, PlateRegion region, String number) {
  final combinedPlateNumber = '${code.code}-${region.region}-$number';
  if (index < selectedPlateNumbers.length) {
    selectedPlateNumbers[index] = combinedPlateNumber;
    print("Updated Plate Number for Car $index: $combinedPlateNumber");
  } else {
    selectedPlateNumbers.add(combinedPlateNumber);
    print("Added Plate Number for Car $index: $combinedPlateNumber");
  }
}
  void addVisitor({Visitor? visitor}) async {
  print("visitor names: ..");
  print(visitor?.names);
  try {
    final visitorService = VisitorService();
    final List<Possession> fetchedPossessions = await ApiService.fetchPossessions();
    final List<String> names =
        visitorControllers.map((controller) => controller.text).toList();
    final List<Possession> possessions = possessionCheckedState
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) {
          final item = fetchedPossessions[entry.key].item;
          final existingPossession = fetchedPossessions.firstWhere(
              (possession) => possession.item == item,
              orElse: () => Possession(id: '', item: item));
          return Possession(
            id: existingPossession.id,
            item: item,
          );
        }).toList();
    final newVisitor = Visitor(
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
      requestedBy: requestedBy,
    );
  
    if (widget.visitorLogs != null && widget.visitorLogs!.isNotEmpty) {
      Visitor vis = Visitor.fromJson22(widget.visitorLogs![0]);
      print("Updating visitor of id before check: ${vis.id}");

      if (vis.id != null) {
        print("Updating visitor of id: ${vis.possessions}");
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
          declined: newVisitor.declined,
          declineReason: newVisitor.declineReason,
          isInside: newVisitor.isInside,
          hasLeft: newVisitor.hasLeft,
          requestedBy: newVisitor.requestedBy!,
        );

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Visitor updated')),
        // );
        Navigator.pop(context, true);
      }
    } else {
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
        approved: false,
        declined: false,
        declineReason: '',
        hasLeft: false,
        isInside: false,
        requestedBy: requestedBy,
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Visitor added')),
      // );
      Navigator.pop(context, true);
    }

    // Clear form fields
    setState(() {
      showVisitorError = false;

      startDate = DateTime.now();
      endDate = DateTime.now();
      numberOfVisitors = numberOfVisitors;
      bringCar = false;
      possessionCheckedState = List.filled(possessions.length, false);

      visitorControllers.forEach((controller) => controller.clear());
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
      child: possessions.isEmpty
          ? const Text("Sorry, no possessions allowed for today") 
          : Row(
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
                      children: List.generate(possessions.length, (index) {
                        return Row(
                          children: [
                            Checkbox(
                              value: possessionCheckedState[index],
                              onChanged: (newValue) {
                                handlePossessionCheckboxChange(index, newValue ?? false);
                              },
                            ),
                            Text(possessions[index].item),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(width: 32.0),
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