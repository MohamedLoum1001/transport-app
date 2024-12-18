import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Ajoutez cet import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tranport_app/Components/Boutons/boutonReutilisable.dart';
import 'package:tranport_app/Pages/Login/Login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController givenNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedUserType = '';

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  void clearFields() {
    nameController.clear();
    givenNameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    setState(() {
      selectedUserType = '';
    });
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'nom': nameController.text,
        'prenom': givenNameController.text,
        'telephone': phoneController.text,
        'email': emailController.text,
        'type': selectedUserType,
        'uid': userCredential.user!.uid,
      });

      clearFields();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      showErrorDialog("Erreur d'inscription : ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Erreur d'inscription"),
        content: Text(message),
        actions: [
          BoutonReutilisable(
            text: "OK",
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Inscription', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Icon(Icons.person_add, size: 100, color: Colors.purple),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: nameController,
                  label: 'Nom',
                  icon: Icons.person,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  controller: givenNameController,
                  label: 'Prénom',
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  controller: phoneController,
                  label: 'Téléphone',
                  icon: Icons.phone,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                SizedBox(height: 10),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),
                _buildPasswordField(
                  controller: passwordController,
                  label: 'Mot de passe',
                  isVisible: _isPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                SizedBox(height: 10),
                _buildPasswordField(
                  controller: confirmPasswordController,
                  label: 'Confirmer mot de passe',
                  isVisible: _isConfirmPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedUserType.isEmpty ? null : selectedUserType,
                  items: [
                    DropdownMenuItem(value: '', child: Text('Choisissez un type d\'utilisateur')),
                    DropdownMenuItem(value: 'Client', child: Text('Client')),
                    DropdownMenuItem(value: 'Transporteur', child: Text('Transporteur')),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUserType = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Type d\'utilisateur',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : BoutonReutilisable(
                        text: "S'inscrire",
                        onPressed: registerUser,
                      ),
                SizedBox(height: 20),
                BoutonReutilisable(
                  text: "Se connecter",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  backgroundColor: Colors.grey[300]!,
                  textColor: Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon, color: Colors.purple),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock, color: Colors.purple),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
