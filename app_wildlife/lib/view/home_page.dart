import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Hewan Dilindungi'),
        backgroundColor: Color.fromARGB(255, 74, 44, 2),
      ),
      
      backgroundColor:  Color.fromARGB(255, 240, 213, 145),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar
            Image.asset(
              'lib/images/logo_wildlife.png', // Gantilah dengan path gambar Anda
              width: 200.0, // Sesuaikan dengan lebar yang diinginkan
              height: 200.0, // Sesuaikan dengan tinggi yang diinginkan
              fit: BoxFit.cover, // Sesuaikan dengan mode penyesuaian gambar
            ),
            SizedBox(height: 20.0), // Jarak antara gambar dan teks
            // Teks di bawah gambar
            Text(
              'Welcome',
              style: TextStyle(fontSize: 32.0),
            ),
            Text(
              'To',
              style: TextStyle(fontSize: 32.0),
            ),
            Text(
              'WildLife Society',
              style: TextStyle(fontSize: 32.0),
            ),
          ],
        ),
      ),
    );
  }
}