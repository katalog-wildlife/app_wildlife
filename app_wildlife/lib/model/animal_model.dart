class AnimalModel {
  final String id;
  final String name;
  final String namalatin;
  final String species;
  final String habitat;
  final String jumlahpopulasi;
  final String lokasipopulasi;
  final String status;
  final String description;
  final String image;

  AnimalModel({
    required this.id,
    required this.name,
    required this.namalatin,
    required this.species,
    required this.habitat,
    required this.jumlahpopulasi,
    required this.lokasipopulasi,
    required this.status,
    required this.description,
    required this.image,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      namalatin: json['namalatin'] ?? '',
      species: json['species'] ?? '',
      habitat: json['habitat'] ?? '',
      jumlahpopulasi: json['jumlahpopulasi'] ?? '',
      lokasipopulasi: json['lokasipopulasi'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class ChargingStationResponse {
  final List<AnimalModel> data;
  final String message;
  final int status;

  ChargingStationResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  static AnimalModel fromApiResponse(Map<String, dynamic>? apiResponse) {
    if (apiResponse == null) {
      // Handle null response gracefully, throw an exception or return a default instance
      throw Exception('Null API response');
    }

    if (apiResponse.containsKey('status') &&
        apiResponse.containsKey('message')) {
      // Extract error details from the response
      int status = apiResponse['status'];
      String message = apiResponse['message'];

      // Handle specific error scenarios
      if (status == 400 &&
          message.contains('invalid number of message parts in token')) {
        throw Exception('Invalid number of message parts in token');
      } else {
        // Handle other error scenarios
        throw Exception('API error: Status $status, Message: $message');
      }
    } else if (apiResponse.containsKey('data')) {
      // Extract data from the response
      var responseData = apiResponse['data'];

      return AnimalModel(
        id: responseData['_id'] ?? '',
        name: responseData['name'] ?? '',
        namalatin: responseData['namalatin'] ?? '',
        species: responseData['species'] ?? '',
        habitat: responseData['habitat'] ?? '',
        jumlahpopulasi: responseData['jumlahpopulasi'] ?? '',
        lokasipopulasi: responseData['lokasipopulasi'] ?? '',
        status: responseData['status'] ?? '',
        description: responseData['description'] ?? '',
        image: responseData['image'] ?? '',
      );
    } else {
      // Handle cases where 'data' key is missing in the response
      throw Exception('Invalid API response format');
    }
  }
}
