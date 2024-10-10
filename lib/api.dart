

const String baseUrl = 'https://bus-reservation-system-api.vercel.app';


getRouteUrl(String startPoint, String endPoint){
  return Uri.parse('$baseUrl/map/start/$startPoint/end/$endPoint');
}