class Route {
  String? id;
  String? origin;
  OriginCoordinates? originCoordinates;
  String? destination;
  OriginCoordinates? destinationCoordinates;
  TripDate? tripDate;
  int? availableSeats;
  Bus? bus;

  Route(
      {this.id,
      this.origin,
      this.originCoordinates,
      this.destination,
      this.destinationCoordinates,
      this.tripDate,
      this.availableSeats,
      this.bus});

  Route.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    origin = json['origin'];
    originCoordinates = json['origin_coordinates'] != null
        ? new OriginCoordinates.fromJson(json['origin_coordinates'])
        : null;
    destination = json['destination'];
    destinationCoordinates = json['destination_coordinates'] != null
        ? new OriginCoordinates.fromJson(json['destination_coordinates'])
        : null;
    tripDate = json['trip_date'] != null
        ? new TripDate.fromJson(json['trip_date'])
        : null;
    availableSeats = json['available_seats'];
    bus = json['bus'] != null ? new Bus.fromJson(json['bus']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['origin'] = this.origin;
    if (this.originCoordinates != null) {
      data['origin_coordinates'] = this.originCoordinates!.toJson();
    }
    data['destination'] = this.destination;
    if (this.destinationCoordinates != null) {
      data['destination_coordinates'] = this.destinationCoordinates!.toJson();
    }
    if (this.tripDate != null) {
      data['trip_date'] = this.tripDate!.toJson();
    }
    data['available_seats'] = this.availableSeats;
    if (this.bus != null) {
      data['bus'] = this.bus!.toJson();
    }
    return data;
  }
}

class OriginCoordinates {
  double? latitude;
  double? longitude;

  OriginCoordinates({this.latitude, this.longitude});

  OriginCoordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class TripDate {
  int? seconds;
  int? nanoseconds;

  TripDate({this.seconds, this.nanoseconds});

  TripDate.fromJson(Map<String, dynamic> json) {
    seconds = json['seconds'];
    nanoseconds = json['nanoseconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seconds'] = this.seconds;
    data['nanoseconds'] = this.nanoseconds;
    return data;
  }
}

class Bus {
  int? totalSeats;
  String? busLine;

  Bus({this.totalSeats, this.busLine});

  Bus.fromJson(Map<String, dynamic> json) {
    totalSeats = json['total_seats'];
    busLine = json['bus_line'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_seats'] = this.totalSeats;
    data['bus_line'] = this.busLine;
    return data;
  }
}
