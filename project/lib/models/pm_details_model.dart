class PmDetailsResponse {
  final String engineerId;
  final List<PmDetail> pmDetails;

  PmDetailsResponse({
    required this.engineerId,
    required this.pmDetails,
  });

  factory PmDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PmDetailsResponse(
      engineerId: json['engineerId'] ?? '',
      pmDetails: (json['pmDetails'] as List<dynamic>?)
          ?.map((detail) => PmDetail.fromJson(detail))
          .toList() ?? [],
    );
  }
}

class PmDetail {
  final String? plant;
  final String? name;
  final String? city;
  final String? region;
  final String? country;
  final String? engineerId;

  PmDetail({
    this.plant,
    this.name,
    this.city,
    this.region,
    this.country,
    this.engineerId,
  });

  factory PmDetail.fromJson(Map<String, dynamic> json) {
    return PmDetail(
      plant: json['plant'],
      name: json['name'],
      city: json['city'],
      region: json['region'],
      country: json['country'],
      engineerId: json['engineerId'],
    );
  }
}