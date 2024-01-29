import 'dart:convert';
import 'dart:io';
import 'package:app_wildlife/model/animal_model.dart';
import 'package:app_wildlife/model/login_model.dart';
import 'package:app_wildlife/services/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ApiServices {
  final Dio dio = Dio();
  final String _baseUrl =
      'https://asia-southeast2-obat-409909.cloudfunctions.net/';

  Future<Iterable<AnimalModel>?> getAllAnimal() async {
    try {
      var response = await dio.get('$_baseUrl/wildlife-animal');
      if (response.statusCode == 200) {
        final animal = (json.decode(response.data)['data'] as List)
            .map((contact) => AnimalModel.fromJson(contact))
            .toList();
        return animal;
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<AnimalModel?> getSingleAnimal(String id) async {
    try {
      var response = await dio.get('$_baseUrl/wildlife-animal/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        return AnimalModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse?> login(LoginInput login) async {
    try {
      final response = await dio.post(
        '$_baseUrl/wildlife-login',
        data: login.toJson(),
      );
      print(response.data);
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.data));
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return LoginResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postAnimal({
    required String name,
    required String namalatin,
    required String species,
    required String habitat,
    required String jumlahpopulasi,
    required String lokasipopulasi,
    required String status,
    required String description,
    required File image,
  }) async {
    try {
      String? token = await AuthManager.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      // Menambahkan pemeriksaan null untuk habitat dan status
      if (habitat.isEmpty || status.isEmpty) {
        throw Exception('Habitat and status cannot be empty');
      }

      FormData formData = FormData.fromMap({
        'name': name,
        'namalatin': namalatin,
        'species': species,
        'habitat':
            habitat, // Menggunakan variabel habitat yang telah didefinisikan
        'jumlahpopulasi': jumlahpopulasi,
        'lokasipopulasi': lokasipopulasi,
        'status':
            status, // Menggunakan variabel status yang telah didefinisikan
        'description': description,
        'file': await MultipartFile.fromFile(image.path),
      });

      Response response = await dio.post(
        '$_baseUrl/wildlife-animal',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': token,
          },
        ),
      );
      return json.decode(response.toString());
    } catch (error) {
      print('Error in postAnimal: $error');
      throw error;
    }
  }

  Future<Map<String, dynamic>> putAnimal({
    required String id,
    required String name,
    required String namalatin,
    required String species,
    required String habitat,
    required String jumlahpopulasi,
    required String lokasipopulasi,
    required String status,
    required String description,
    required dynamic image,
  }) async {
    try {
      String? token = await AuthManager.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      MultipartFile? imageFile;
      if (image is File) {
        imageFile = await MultipartFile.fromFile(image.path);
      } else if (image is String) {
        imageFile = MultipartFile.fromString(image);
      }

      FormData formData = FormData.fromMap({
        'name': name,
        'namalatin': namalatin,
        'species': species,
        'habitat': habitat,
        'jumlahpopulasi': jumlahpopulasi,
        'lokasipopulasi': lokasipopulasi,
        'status': status,
        'description': description,
        'file': imageFile,
      });

      Response response = await dio.put(
        '$_baseUrl/wildlife-animal?id=$id',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': token,
          },
        ),
      );
      return json.decode(response.toString());
    } catch (error) {
      print('Error in putAnimal: $error');
      throw error;
    }
  }

  Future deleteAnimal(String id) async {
    try {
      String? token = await AuthManager.getToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      Response response = await dio.delete(
        '$_baseUrl/wildlife-animal?id=$id',
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );
      return json.decode(response.toString());
    } catch (error) {
      print('Error in deleteAnimal: $error');
      throw error;
    }
  }
}
