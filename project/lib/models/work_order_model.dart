class WorkOrderResponse {
  final String plantId;
  final List<WorkOrder> workOrders;

  WorkOrderResponse({
    required this.plantId,
    required this.workOrders,
  });

  factory WorkOrderResponse.fromJson(Map<String, dynamic> json) {
    return WorkOrderResponse(
      plantId: json['plantId'] ?? '',
      workOrders: (json['workOrders'] as List<dynamic>?)
          ?.map((order) => WorkOrder.fromJson(order))
          .toList() ?? [],
    );
  }
}

class WorkOrder {
  final String? orderNumber;
  final String? description;
  final String? orderType;
  final String? startDate;
  final String? endDate;
  final String equipmentNumber;
  final String? costCenter;
  final String? plant;
  final String? companyCode;
  final String? shortText;
  final String? longText;

  WorkOrder({
    this.orderNumber,
    this.description,
    this.orderType,
    this.startDate,
    this.endDate,
    required this.equipmentNumber,
    this.costCenter,
    this.plant,
    this.companyCode,
    this.shortText,
    this.longText,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
      orderNumber: json['orderNumber'],
      description: json['description'],
      orderType: json['orderType'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      equipmentNumber: json['equipmentNumber'] ?? '',
      costCenter: json['costCenter'],
      plant: json['plant'],
      companyCode: json['companyCode'],
      shortText: json['shortText'],
      longText: json['longText'],
    );
  }

  bool get isOpen => endDate == null || endDate!.isEmpty;
}