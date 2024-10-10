library my_prj.globals;

String user_id ='';
String passenger_id = '';
String driver_id = '';
String bus_id = '';
String role = '';
String username = '';
 Name? name;

class Name {
  String first_name;
  String last_name;

  Name({
    required this.first_name,
    required this.last_name
  });

  static Name fromMap(Map<String, String> data) {
    return Name(
      first_name: data['first_name'] ?? '',
      last_name: data['last_name'] ?? '',
    );
  }
}


