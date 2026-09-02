import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<String> getCurrentCity() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Cek apakah layanan lokasi (GPS) aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'GPS tidak aktif';
    }

    // 2. Cek status izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Izin lokasi ditolak';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Izin lokasi ditolak permanen';
    }

    try {
      // 3. Ambil posisi koordinat saat ini
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy:
            LocationAccuracy.low, // 'low' lebih cepat dan hemat baterai
      );

      // 4. Ubah koordinat menjadi nama tempat/kota
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Mengembalikan nama Kota/Kabupaten atau Area
        return place.subAdministrativeArea ??
            place.locality ??
            'Lokasi tidak diketahui';
      }

      return 'Lokasi tidak ditemukan';
    } catch (e) {
      return 'Gagal memuat lokasi';
    }
  }
}
