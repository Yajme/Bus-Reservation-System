class Trip {
  String? id;
  BookingDate? bookingDate;
  Passenger? passenger;
  Route? route;

  Trip({this.id, this.bookingDate, this.passenger, this.route});

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingDate = json['booking_date'] != null
        ? new BookingDate.fromJson(json['booking_date'])
        : null;
    passenger = json['passenger'] != null
        ? new Passenger.fromJson(json['passenger'])
        : null;
    route = json['route'] != null ? new Route.fromJson(json['route']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.bookingDate != null) {
      data['booking_date'] = this.bookingDate!.toJson();
    }
    if (this.passenger != null) {
      data['passenger'] = this.passenger!.toJson();
    }
    if (this.route != null) {
      data['route'] = this.route!.toJson();
    }
    return data;
  }
}

class BookingDate {
  int? seconds;
  int? nanoseconds;

  BookingDate({this.seconds, this.nanoseconds});

  BookingDate.fromJson(Map<String, dynamic> json) {
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

class Passenger {
  String? lastName;
  String? firstName;

  Passenger({this.lastName, this.firstName});

  Passenger.fromJson(Map<String, dynamic> json) {
    lastName = json['last_name'];
    firstName = json['first_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_name'] = this.lastName;
    data['first_name'] = this.firstName;
    return data;
  }
}

class Route {
  BookingDate? tripDate;
  String? origin;
  OriginCoordinates? originCoordinates;
  String? destination;
  OriginCoordinates? destinationCoordinates;

  Route(
      {this.tripDate,
      this.origin,
      this.originCoordinates,
      this.destination,
      this.destinationCoordinates});

  Route.fromJson(Map<String, dynamic> json) {
    tripDate = json['trip_date'] != null
        ? new BookingDate.fromJson(json['trip_date'])
        : null;
    origin = json['origin'];
    originCoordinates = json['origin_coordinates'] != null
        ? new OriginCoordinates.fromJson(json['origin_coordinates'])
        : null;
    destination = json['destination'];
    destinationCoordinates = json['destination_coordinates'] != null
        ? new OriginCoordinates.fromJson(json['destination_coordinates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tripDate != null) {
      data['trip_date'] = this.tripDate!.toJson();
    }
    data['origin'] = this.origin;
    if (this.originCoordinates != null) {
      data['origin_coordinates'] = this.originCoordinates!.toJson();
    }
    data['destination'] = this.destination;
    if (this.destinationCoordinates != null) {
      data['destination_coordinates'] = this.destinationCoordinates!.toJson();
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
