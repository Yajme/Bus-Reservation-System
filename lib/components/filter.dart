class Filter {
  String? currentLocation;
  String destination;
  DateTime tripDate;
  int? seats;
  String? preferredBus;

  Filter({
    required this.destination,
    required this.tripDate,
    this.currentLocation,
    this.preferredBus,
    this.seats
  });

  
}