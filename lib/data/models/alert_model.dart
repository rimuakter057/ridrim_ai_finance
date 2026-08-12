import '../../domain/entities/alert.dart';

/// Data-layer representation of [Alert]. Kept separate from the domain
/// entity so JSON (de)serialization can be added here later without
/// leaking data-layer concerns into the domain layer.
class AlertModel extends Alert {
  const AlertModel({
    required super.id,
    required super.type,
    required super.severity,
    required super.title,
    required super.message,
    required super.timestamp,
    super.isRead,
  });
}
