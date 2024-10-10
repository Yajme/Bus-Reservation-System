import 'package:latlong2/latlong.dart';

class Trip {
  final String? id;
  final String origin;
  final LatLng originCoordinates;
  final DateTime departureDateTime;
  final String destination;
  final LatLng destinationCoordinates;
  Trip(
      {required this.origin,
      required this.departureDateTime,
      required this.destination,
      required this.destinationCoordinates,
      required this.originCoordinates,
      this.id
      });
}
