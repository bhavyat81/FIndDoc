// Mock user location for Vadodara (centre of city)
// In a future version, this would use the device GPS.
class LocationService {
  static const double defaultLat = 22.3072;
  static const double defaultLng = 73.1812;

  double get latitude => defaultLat;
  double get longitude => defaultLng;
}
