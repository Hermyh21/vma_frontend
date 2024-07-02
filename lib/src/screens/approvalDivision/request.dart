import 'package:http/http.dart' as http;

class Requests {
  static void sendData({
    required DateTime startDate,
    required DateTime endDate,
    required int numberOfVisitors,
    required List<String> visitorNames,
    required bool bringCar,
    required List<String> selectedPlateNumbers,
    required String selectedHostName,
    required List<bool> possessionCheckedState,
    required List<int> possessionQuantities,
  }) {
    Uri url = Uri.parse('https://4000/api/submit-data');
    http.post(
      url,
      body: {
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'numberOfVisitors': numberOfVisitors.toString(),
        'visitorNames': visitorNames.join(','),
        'bringCar': bringCar.toString(),
        'selectedPlateNumbers': selectedPlateNumbers.join(','),
        'selectedHostName': selectedHostName,
        'possessionCheckedState': possessionCheckedState.join(','),
        'possessionQuantities': possessionQuantities.join(','),
      },
    ).then((response) {
      if (response.statusCode == 200) {
        /*print('Data submitted successfully:');
        print('Start Date: $startDate');
        print('End Date: $endDate');
        print('Number of Visitors: $numberOfVisitors');
        print('Visitor Names: ${visitorNames.join(', ')}');
        print('Bring Car: $bringCar');
        print('Selected Plate Numbers: ${selectedPlateNumbers.join(', ')}');
        print('Selected Host Name: $selectedHostName');
        print('Possession Checked State: ${possessionCheckedState.join(', ')}');
        print('Possession Quantities: ${possessionQuantities.join(', ')}');*/
      } else {
        // Request failed, handle error
        print('Request failed with status: ${response.statusCode}');
      }
    }).catchError((error) {
      // Handle errors if the request fails
      print('Request failed with error: $error');
    });
  }
}
