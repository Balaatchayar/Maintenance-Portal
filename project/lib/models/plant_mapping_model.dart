class PlantMappingResponse {
  final String engineerId;
  final List<PlantMapping> plants;

  PlantMappingResponse({
    required this.engineerId,
    required this.plants,
  });

  factory PlantMappingResponse.fromJson(Map<String, dynamic> json) {
    return PlantMappingResponse(
      engineerId: json['engineerId'] ?? '',
      plants: (json['plants'] as List<dynamic>?)
          ?.map((plant) => PlantMapping.fromJson(plant))
          .toList() ?? [],
    );
  }
}

class PlantMapping {
  final String maintEngineer;
  final String plantId;

  PlantMapping({
    required this.maintEngineer,
    required this.plantId,
  });

  factory PlantMapping.fromJson(Map<String, dynamic> json) {
    return PlantMapping(
      maintEngineer: json['maintEngineer'] ?? '',
      plantId: json['plantId'] ?? '',
    );
  }
}