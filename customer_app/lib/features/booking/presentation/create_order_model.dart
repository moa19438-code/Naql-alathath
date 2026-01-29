class CreateOrderModel {
  final String? serviceType;
  final String? fromAddress;
  final String? toAddress;
  final String? itemsNotes;
  final DateTime? scheduledAt;

  const CreateOrderModel({
    this.serviceType,
    this.fromAddress,
    this.toAddress,
    this.itemsNotes,
    this.scheduledAt,
  });

  CreateOrderModel copyWith({
    String? serviceType,
    String? fromAddress,
    String? toAddress,
    String? itemsNotes,
    DateTime? scheduledAt,
  }) {
    return CreateOrderModel(
      serviceType: serviceType ?? this.serviceType,
      fromAddress: fromAddress ?? this.fromAddress,
      toAddress: toAddress ?? this.toAddress,
      itemsNotes: itemsNotes ?? this.itemsNotes,
      scheduledAt: scheduledAt ?? this.scheduledAt,
    );
  }

  bool get isStep1Valid => serviceType != null;
  bool get isStep2Valid => (fromAddress?.trim().isNotEmpty ?? false) && (toAddress?.trim().isNotEmpty ?? false);
  bool get isStep3Valid => true; // notes optional
  bool get isStep4Valid => scheduledAt != null;
}
