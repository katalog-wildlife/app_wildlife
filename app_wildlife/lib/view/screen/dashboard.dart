import 'package:app_wildlife/model/animal_model.dart';
import 'package:app_wildlife/services/api_services.dart';
import 'package:app_wildlife/view/user/form_edit.dart';
import 'package:app_wildlife/view/user/form_input.dart';
import 'package:flutter/material.dart';

class MyDasboard extends StatefulWidget {
  const MyDasboard({Key? key}) : super(key: key);

  @override
  State<MyDasboard> createState() => _MyDasboardState();
}

class _MyDasboardState extends State<MyDasboard> {
  bool showMap = false;
  final ApiServices apiService = ApiServices();
  Iterable<AnimalModel>? animalList;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    animalList = await apiService.getAllAnimal();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 74, 44, 2),
          title: const Text('Dasboard'),
        ),
        
        backgroundColor:  Color.fromARGB(255, 240, 213, 145),
        
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          // Tambahkan floatingActionButton di sini
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyFormInput(),
              ),
            );
            // Tambahkan logika untuk menangani ketika tombol tambah data ditekan
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (animalList == null) {
      // Tampilkan indikator loading jika daftar hewan masih kosong
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (animalList!.isEmpty) {
      // Tampilkan pesan jika tidak ada data hewan
      return Center(
        child: Text('Tidak ada data hewan'),
      );
    } else {
      // Tampilkan daftar kartu data hewan jika sudah tersedia
      return ListView.builder(
        itemCount: animalList!.length,
        itemBuilder: (context, index) {
          return _buildAnimalCard(animalList!.elementAt(index));
        },
      );
    }
  }

  Widget _buildAnimalCard(AnimalModel animal) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4, // Menambahkan efek bayangan untuk card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100, // Lebar gambar
            height: 100, // Tinggi gambar
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
              image: DecorationImage(
                image: NetworkImage(animal.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(animal.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama Latin: ${animal.namalatin}'),
                  Text('Species: ${animal.species}'),
                  Text('Habitat: ${animal.habitat}'),
                  Text('Jumlah Populasi: ${animal.jumlahpopulasi.toString()}'),
                  Text('Lokasi Populasi: ${animal.lokasipopulasi}'),
                  Text('Deskripsi: ${animal.description}'),
                  Text('Status: ${animal.status}'),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyFormPut(
                    animal: animal,
                  ),
                ),
              );
              _refresh();
              // Tambahkan logika untuk menangani ketika pengguna mengetuk tombol edit
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
           onPressed: () async {
              try {
                await apiService.deleteAnimal(animal.id);
                _refresh();
              } catch (e) {
                print('Error deleting animal: $e');
                // Tambahkan logika penanganan kesalahan sesuai kebutuhan
              }
            },
          ),
        ],
      ),  
    );
  }
}
