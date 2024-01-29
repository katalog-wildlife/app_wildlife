import 'dart:io';
import 'package:app_wildlife/model/animal_model.dart';
import 'package:app_wildlife/services/api_services.dart';
import 'package:app_wildlife/services/auth_manager.dart';
import 'package:app_wildlife/view/screen/dashboard.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MyFormPut extends StatefulWidget {
  final AnimalModel animal;
  const MyFormPut({Key? key, required this.animal}) : super(key: key);

  @override
  State<MyFormPut> createState() => _MyFormPutState();
}

class _MyFormPutState extends State<MyFormPut> {
  // final GlobalKey<FormState> _formKey = GlobalKey();
  final _nameCtl = TextEditingController();
  final _namaLatinCtl = TextEditingController();
  final _speciesCtl = TextEditingController();
  final _habitatCtl = TextEditingController();
  final _jumlahpopulasiCtl = TextEditingController();
  final _lokasipopulasiCtl = TextEditingController();
  final _statusCtl = TextEditingController();
  final _descriptionCtl = TextEditingController();
  File? _selectedImage;
  Dio dio = Dio();
  // String _SelectedHabitat = '';
  // bool _gambarValid = false;

  bool passwordVisible = true;
  int number = 0;
  String selectedStatus = 'EX'; // Default status

  // Opsi untuk dropdown
  List<String> habitatOptions = ['Jungle', 'Desert', 'Ocean', 'Grassland'];

  // Variable untuk menyimpan path gambar yang dipilih
  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  void _putAnimal() async {
    try {
      String? token = await AuthManager.getToken();

      if (token == null) {
        return;
      }

      ApiServices apiService = ApiServices();

      String imagePath = _selectedImage!.path;

      Map<String, dynamic> putData = {
        'name': _nameCtl.text,
        'namaLatin': _namaLatinCtl.text,
        'species': _speciesCtl.text,
        'habitat': _habitatCtl.text,
        'jumlahpopulasi': _jumlahpopulasiCtl.text,
        'lokasipopulasi': _lokasipopulasiCtl.text,
        'status': _statusCtl.text,
        'description': _descriptionCtl.text,
        'image': imagePath,
      };

      if (_selectedImage == null || !await _selectedImage!.exists()) {
        throw Exception('Image file does not exist');
      }

      print('Posting Hewan: $putData');

      // Map<String, dynamic> apiResponse = await apiService.postAnimal(
      //   name: putData['name'],
      //   namalatin: putData['namalatin'],
      //   species: putData['species'],
      //   habitat: putData['habitat'],
      //   jumlahpopulasi: putData['jumlahpopulasi'],
      //   lokasipopulasi: putData['lokasipopulasi'],
      //   status: putData['status'],
      //   description: putData['description'],
      //   image: putData['image'],
      // );

      Map<String, dynamic> apiResponse = await apiService.putAnimal(
        id: putData['id'],
        name: _nameCtl.text,
        namalatin: _namaLatinCtl.text,
        species: _speciesCtl.text,
        habitat: _habitatCtl.text,
        jumlahpopulasi: _jumlahpopulasiCtl.text,
        lokasipopulasi: _lokasipopulasiCtl.text,
        status: _statusCtl.text,
        description: _descriptionCtl.text,
        image: _selectedImage,
      );

      print('API Response: $apiResponse');

      if (apiResponse['status'] == 201) {
        _showSuccessAlert(
            'Successfully posted animal: ${apiResponse['message']}');
      } else {
        _showErrorAlert('Failed to post animal: ${apiResponse['message']}');
      }
    } catch (error) {
      print('Error posting animal: $error');
      _showErrorAlert('FAIL: $error');
    }
  }

  void _showSuccessAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyDasboard()),
                    ((route) => false));
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menangani submit form
  void _handleSubmit() {
    if (_selectedImage == null) {
      _showErrorAlert('Gambar tidak boleh kosong');
      return;
    }

    if (_nameCtl.text.isEmpty) {
      _showErrorAlert('Nama hewan tidak boleh kosong');
      return;
    }

    if (_namaLatinCtl.text.isEmpty) {
      _showErrorAlert('Nama latin hewan tidak boleh kosong');
      return;
    }

    if (_speciesCtl.text.isEmpty) {
      _showErrorAlert('Species hewan tidak boleh kosong');
      return;
    }

    if (_habitatCtl.text.isEmpty) {
      _showErrorAlert('Habitat hewan tidak boleh kosong');
      return;
    }

    if (_jumlahpopulasiCtl.text.isEmpty) {
      _showErrorAlert('Jumlah populasi hewan tidak boleh kosong');
      return;
    }

    if (_lokasipopulasiCtl.text.isEmpty) {
      _showErrorAlert('Lokasi populasi hewan tidak boleh kosong');
      return;
    }

    if (_statusCtl.text.isEmpty) {
      _showErrorAlert('Status hewan tidak boleh kosong');
      return;
    }

    if (_descriptionCtl.text.isEmpty) {
      _showErrorAlert('description hewan tidak boleh kosong');
      return;
    }

    _putAnimal();
  }

  @override
  void initState() {
    super.initState();
    _animalFields();
  }

  void _animalFields() {
    _nameCtl.text = widget.animal.name;
    _namaLatinCtl.text = widget.animal.namalatin;
    _speciesCtl.text = widget.animal.species;
    _habitatCtl.text = widget.animal.habitat;
    _jumlahpopulasiCtl.text = widget.animal.jumlahpopulasi;
    _lokasipopulasiCtl.text = widget.animal.lokasipopulasi;
    _statusCtl.text = widget.animal.status;
    _descriptionCtl.text = widget.animal.description;
    _selectedImage = File(widget.animal.image);
  }

  String _validateNama(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama hewan tidak boleh kosong';
    }

    if (value.length < 4) {
      return 'Nama hewan minimal 4 karakter';
    } else if (value.length > 20) {
      return 'Nama hewan maksimal 20 karakter';
    }
    return '';
  }

  String _validateNamaLatin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama latin hewan tidak boleh kosong';
    }
    if (value.length < 4) {
      return 'Nama latin hewan minimal 4 karakter';
    } else if (value.length > 20) {
      return 'Nama latin hewan maksimal 20 karakter';
    }

    return '';
  }

  String _validateSpecies(String? value) {
    if (value == null || value.isEmpty) {
      return 'Species hewan tidak boleh kosong';
    }
    if (value.length < 4) {
      return 'Species hewan minimal 4 karakter';
    } else if (value.length > 20) {
      return 'Species hewan maksimal 20 karakter';
    }
    return '';
  }

  String _validateHabitat(String? value) {
    if (value == null || value.isEmpty) {
      return 'Habitat hewan tidak boleh kosong';
    }
    return '';
  }

  String _validateJumlahPopulasi(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jumlah populasi hewan tidak boleh kosong';
    }
    const String expression = r'^[0-9]+$';
    final RegExp regex = RegExp(expression);

    if (!regex.hasMatch(value)) {
      return 'Jumlah populasi hewan harus berupa angka';
    }
    return '';
  }

  String _validateLokasiPopulasi(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lokasi populasi hewan tidak boleh kosong';
    }
    return '';
  }

  String _validateStatus(String? value) {
    if (value == null || value.isEmpty) {
      return 'Status hewan tidak boleh kosong';
    }
    return '';
  }

  String _validatedescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'description hewan tidak boleh kosong';
    }
    return '';
  }

  bool _validateFile(File? pathFile) {
    if (pathFile == null) {
      return true;
    }
    return false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form '),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color.fromARGB(255, 248, 133, 2)],
            ),
          ),
          child: FormBuilder(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Formulir
                      FormBuilderTextField(
                        name: 'name',
                        controller: _nameCtl,
                        validator: _validateNama,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Masukkan Nama Hewan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'namaLatin',
                        controller: _namaLatinCtl,
                        validator: _validateNamaLatin,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Masukkan Nama Latin Hewan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'species',
                        controller: _speciesCtl,
                        validator: _validateSpecies,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Masukkan Species Hewan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      // Dropdown untuk Habitat
                      FormBuilderDropdown(
                        name: 'habitat',
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Pilih Habitat Hewan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: _validateHabitat,
                        onChanged: (value) {
                          setState(() {
                            _habitatCtl.text = value.toString();
                          });
                        },
                        items: habitatOptions
                            .map((habitat) => DropdownMenuItem(
                                  value: habitat,
                                  child: Text('$habitat'),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 12),
                      // TextFormField untuk input angka saja
                      FormBuilderTextField(
                        name: 'jumlahPopulasi',
                        controller: _jumlahpopulasiCtl,
                        validator: _validateJumlahPopulasi,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Masukkan Jumlah Populasi Hewan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'lokasiPopulasi',
                        controller: _lokasipopulasiCtl,
                        validator: _validateLokasiPopulasi,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Masukkan Lokasi Populasi Hewan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      // Radio buttons untuk status hewan
                      FormBuilderRadioGroup(
                        name: 'status',
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Pilih Status Hewan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: _validateStatus,
                        onChanged: (value) {
                          setState(() {
                            _statusCtl.text = value.toString();
                          });
                        },
                        options: [
                          FormBuilderFieldOption(
                            value: 'EX',
                            child: Text('EX'),
                          ),
                          FormBuilderFieldOption(
                            value: 'EW',
                            child: Text('EW'),
                          ),
                          FormBuilderFieldOption(
                            value: 'CR',
                            child: Text('CR'),
                          ),
                          FormBuilderFieldOption(
                            value: 'EN',
                            child: Text('EN'),
                          ),
                          FormBuilderFieldOption(
                            value: 'VU',
                            child: Text('VU'),
                          ),
                          FormBuilderFieldOption(
                            value: 'NT',
                            child: Text('NT'),
                          ),
                          FormBuilderFieldOption(
                            value: 'LC',
                            child: Text('LC'),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),
                      FormBuilderTextField(
                        name: 'description',
                        controller: _descriptionCtl,
                        maxLines:
                            3, // Atur jumlah baris maksimal sesuai kebutuhan
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          hintText: "Masukkan description Hewan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      // Image Picker
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                            onPressed: _pickImage,
                            child: const Text('Choose Image'),
                          ),
                        ),
                      ),
                      _selectedImage != null
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit
                                        .cover, // Atur fit: BoxFit.cover untuk memastikan gambar sesuai
                                    width: MediaQuery.of(context).size.width *
                                        0.8, // Atur lebar sesuai kebutuhan
                                    height: MediaQuery.of(context).size.height *
                                        0.3, // Atur tinggi sesuai kebutuhan
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(height: 20),
                      // Tombol Submit
                      ElevatedButton(
                        onPressed: _handleSubmit,
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
