import 'package:flutter/material.dart';
import 'package:app_wildlife/services/api_services.dart';
import 'package:app_wildlife/model/register_model.dart';
import 'package:app_wildlife/view/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{
  final GlobalKey<FormState> _formKey =GlobalKey();

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiServices _dataService = ApiServices();

  @override

  void dispose(){
    _fullnameController.dispose();
    _phonenumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateFullname(String? value){
    if(value != null && value.length < 4){
      return 'Masukkan minimal 6 karakter';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Nomor telepon hanya boleh mengandung karakter angka';
    }

    String cleanedValue = value.replaceAll(RegExp(r'\D'), '');

    if (!cleanedValue.startsWith('0')) {
      return 'Nomor telepon harus diawali dengan 0';
    }
    if (cleanedValue.length < 8) {
      return 'Nomor telepon minimal 8 karakter';
    }
    if (cleanedValue.length > 13) {
      return 'Nomor telepon maksimal 13 karakter';
    }
    return null;
  }

  String? _validateEmail(String? value){
    if(value != null && value.length < 4){
      return 'Masukkan minimal 6 karakter';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar'),
          backgroundColor: Color.fromARGB(255, 74, 44, 2),
        ),

        backgroundColor: Color.fromARGB(255, 240, 213, 145),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text (
                          'Silahkan Daftarkan',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text (
                          'Akun Anda disini!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: _validateFullname,
                      controller: _fullnameController,
                      decoration: const InputDecoration(
                        labelText: 'Fullname',
                        hintText: 'Masukkan Nama Lengkap anda!',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: _validatePhoneNumber,
                      controller: _phonenumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Masukkan Nomor Telepon anda!',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: _validateEmail,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Masukkan Email anda!',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: _validateEmail,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Masukkan Password anda!',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final isValidForm = _formKey.currentState!.validate();
                        if(isValidForm){
                          final input = RegisterInput(
                            fullname: _fullnameController.text,
                            phonenumber: _phonenumberController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                           RegisterResponse? res =
                              await _dataService.register(input);
                          if (res != null) {
                            if (res.status == 200) {
                              displaySnackbar(res.message);
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            } else {
                              displaySnackbar(res.message);
                            }
                          }
                        }
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBEBD8F),
                      ),
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(000000),
                        ),
                      )
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah Punya Akun?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}

dynamic displaySnackbar(String msg) {
    final _formKey = GlobalKey<FormState>(); // Define the _formKey variable
    return ScaffoldMessenger.of(_formKey.currentContext!)
        .showSnackBar(SnackBar(content: Text(msg)));}