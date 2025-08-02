import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class HospitalService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hastane ekleme
  static Future<String?> addHospital(Map<String, dynamic> hospitalData) async {
    try {
      final docRef = await _firestore.collection('hospitals').add({
        ...hospitalData,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'currentPatients': 0,
      });

      if (kDebugMode) {
        print('✅ Hastane eklendi: ${docRef.id}');
      }
      return docRef.id;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Hastane ekleme hatası: $e');
      }
      return null;
    }
  }

  // Hastane güncelleme
  static Future<bool> updateHospital(
    String hospitalId,
    Map<String, dynamic> hospitalData,
  ) async {
    try {
      await _firestore.collection('hospitals').doc(hospitalId).update({
        ...hospitalData,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('✅ Hastane güncellendi: $hospitalId');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Hastane güncelleme hatası: $e');
      }
      return false;
    }
  }

  // Hastane durumu güncelleme
  static Future<bool> updateHospitalStatus(
    String hospitalId,
    bool isActive,
  ) async {
    try {
      await _firestore.collection('hospitals').doc(hospitalId).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('✅ Hastane durumu güncellendi: $hospitalId -> $isActive');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Hastane durum güncelleme hatası: $e');
      }
      return false;
    }
  }

  // Hastane silme
  static Future<bool> deleteHospital(String hospitalId) async {
    try {
      await _firestore.collection('hospitals').doc(hospitalId).delete();

      if (kDebugMode) {
        print('✅ Hastane silindi: $hospitalId');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Hastane silme hatası: $e');
      }
      return false;
    }
  }

  // Aktif hastaneleri getir
  static Future<List<Map<String, dynamic>>> getActiveHospitals() async {
    try {
      final snapshot = await _firestore
          .collection('hospitals')
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Aktif hastaneler getirme hatası: $e');
      }
      return [];
    }
  }

  // Tüm hastaneleri getir
  static Future<List<Map<String, dynamic>>> getAllHospitals() async {
    try {
      final snapshot = await _firestore.collection('hospitals').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Tüm hastaneler getirme hatası: $e');
      }
      return [];
    }
  }

  // Hastane bilgisi getir
  static Future<Map<String, dynamic>?> getHospital(String hospitalId) async {
    try {
      final doc = await _firestore
          .collection('hospitals')
          .doc(hospitalId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Hastane bilgisi getirme hatası: $e');
      }
      return null;
    }
  }

  // Örnek hastaneleri başlat
  static Future<void> initializeHospitals() async {
    try {
      // Mevcut hastane sayısını kontrol et
      final snapshot = await _firestore.collection('hospitals').get();

      if (snapshot.docs.isNotEmpty) {
        if (kDebugMode) {
          print('ℹ️ Hastaneler zaten mevcut, örnek veri eklenmedi');
        }
        return;
      }

      // Örnek hastaneler
      final sampleHospitals = [
        {
          'name': 'Ankara Şehir Hastanesi',
          'address': 'Üniversiteler Mah. 1604. Cad. No:9 Çankaya/Ankara',
          'phone': '0312 552 60 00',
          'city': 'Ankara',
          'district': 'Çankaya',
          'totalBeds': 2500,
          'emergencyCapacity': 100,
          'currentPatients': 23,
          'coordinates': {'lat': 39.9208, 'lng': 32.8541},
        },
        {
          'name': 'Hacettepe Üniversitesi Hastanesi',
          'address': 'Sıhhiye Mah. Hacettepe Üniversitesi Ankara',
          'phone': '0312 305 10 00',
          'city': 'Ankara',
          'district': 'Sıhhiye',
          'totalBeds': 1000,
          'emergencyCapacity': 80,
          'currentPatients': 45,
          'coordinates': {'lat': 39.9334, 'lng': 32.8597},
        },
        {
          'name': 'Memorial Şişli Hastanesi',
          'address': 'Piyale Paşa Bulvarı Okmeydanı Şişli/İstanbul',
          'phone': '0212 314 66 66',
          'city': 'İstanbul',
          'district': 'Şişli',
          'totalBeds': 400,
          'emergencyCapacity': 80,
          'currentPatients': 32,
          'coordinates': {'lat': 41.0082, 'lng': 28.9784},
        },
      ];

      // Hastaneleri ekle
      for (final hospital in sampleHospitals) {
        await addHospital(hospital);
      }

      if (kDebugMode) {
        print('✅ ${sampleHospitals.length} örnek hastane eklendi');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Örnek hastaneler ekleme hatası: $e');
      }
    }
  }

  // Hastane hasta sayısını güncelle
  static Future<bool> updatePatientCount(
    String hospitalId,
    int currentPatients,
  ) async {
    try {
      await _firestore.collection('hospitals').doc(hospitalId).update({
        'currentPatients': currentPatients,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print(
          '✅ Hastane hasta sayısı güncellendi: $hospitalId -> $currentPatients',
        );
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Hasta sayısı güncelleme hatası: $e');
      }
      return false;
    }
  }

  // Şehre göre hastaneleri getir
  static Future<List<Map<String, dynamic>>> getHospitalsByCity(
    String city,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('hospitals')
          .where('city', isEqualTo: city)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Şehir hastaneleri getirme hatası: $e');
      }
      return [];
    }
  }
}
