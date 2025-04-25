  import 'package:easy_localization/easy_localization.dart';
  import 'package:flutter/material.dart';
import 'package:flutter_6_7/models/user.dart';

  class RegisterFormPage extends StatefulWidget {
    const RegisterFormPage({super.key, required void Function(String n, String d, String p, String e, String c) onSubmit, required Null Function(User newUser) onUserRegistered});

    @override
    State<RegisterFormPage> createState() => _RegisterFormPageState();
  }

  class _RegisterFormPageState extends State<RegisterFormPage> {
    final _formKey = GlobalKey<FormState>();

    final _nameController = TextEditingController();
    final _dobController = TextEditingController();
    final _phoneController = TextEditingController();
    final _emailController = TextEditingController();
    final _passController = TextEditingController();
    final _confirmPassController = TextEditingController();

    final _nameFocus = FocusNode();
    final _dobFocus = FocusNode();
    final _phoneFocus = FocusNode();
    final _emailFocus = FocusNode();
    final _passFocus = FocusNode();
    final _confirmPassFocus = FocusNode();

    final List<String> _countries = ['Kazakhstan', 'Russia', 'Germany', 'France', 'Turkey', 'USA'];
    String _selectedCountry = 'Kazakhstan';

    bool _obscurePassword = true;
    bool _obscureConfirmPassword = true;

    @override
    void dispose() {
      _nameController.dispose();
      _dobController.dispose();
      _phoneController.dispose();
      _emailController.dispose();
      _passController.dispose();
      _confirmPassController.dispose();

      _nameFocus.dispose();
      _dobFocus.dispose();
      _phoneFocus.dispose();
      _emailFocus.dispose();
      _passFocus.dispose();
      _confirmPassFocus.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('register_form'.tr()),
          backgroundColor: const Color.fromARGB(255, 127, 104, 190),
          actions: [
            PopupMenuButton<Locale>(
              icon: const Icon(Icons.language),
              onSelected: (Locale locale) {
                context.setLocale(locale);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: Locale('en'), child: Text('English')),
                const PopupMenuItem(value: Locale('kk'), child: Text('Қазақша')),
                const PopupMenuItem(value: Locale('ru'), child: Text('Русский')),
              ],
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7F5AF0), Color(0xFFEC4899), Color.fromARGB(255, 184, 110, 156)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  // ignore: deprecated_member_use
                  color: const Color.fromARGB(255, 239, 174, 226).withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          _buildTextField(_nameController, _nameFocus, 'full_name'.tr(), Icons.person, 'enter_name'.tr(), false, validator: validateName),
                          _buildTextField(_dobController, _dobFocus, 'date_of_birth'.tr(), Icons.calendar_today, 'dd_mm_yyyy'.tr(), false, isDate: true, validator: validateDateOfBirth),
                          _buildTextField(_phoneController, _phoneFocus, 'phone_number'.tr(), Icons.phone, 'enter_phone_number'.tr(), false, validator: validatePhoneNumber),
                          _buildTextField(_emailController, _emailFocus, 'email'.tr(), Icons.email, 'enter_email'.tr(), false, validator: validateEmail),
                          _buildDropdown(),
                          _buildTextField(_passController, _passFocus, 'password'.tr(), Icons.lock, 'enter_password'.tr(), true, isPassword: true, validator: _validatePassword),
                          _buildTextField(_confirmPassController, _confirmPassFocus, 'confirm_password'.tr(), Icons.lock, 're_enter_password'.tr(), true, isPassword: true, isConfirmPassword: true, validator: _validateConfirmPassword),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 127, 104, 190),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                            ),
                            child: Text('register'.tr(), style: const TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }


    Widget _buildTextField(TextEditingController controller, FocusNode focusNode, String label, IconData icon, String hint, bool obscure,
        {bool isDate = false, bool isPassword = false, bool isConfirmPassword = false, String? Function(String?)? validator}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPassword ? (isConfirmPassword ? _obscureConfirmPassword : _obscurePassword) : obscure,
          validator: validator,
          keyboardType: isDate
              ? TextInputType.none
              : isPassword
                  ? TextInputType.visiblePassword
                  : label.contains("Phone")
                      ? TextInputType.phone
                      : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color.fromARGB(255, 146, 40, 216)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isConfirmPassword ? (_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off) : (_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    ),
                    onPressed: () {
                      setState(() {
                        if (isConfirmPassword) {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        } else {
                          _obscurePassword = !_obscurePassword;
                        }
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      setState(() {
                        controller.clear();
                      });
                    },
                  ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onTap: isDate
              ? () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    controller.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  }
                }
              : null,
        ),
      );
    }

    // Function for the dropdown menu
    Widget _buildDropdown() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: 'country'.tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          value: _selectedCountry,
          items: _countries.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountry = value!;
            });
          },
        ),
      );
    }

    // Form submission
    void _submitForm() {
      if (_formKey.currentState!.validate()) {
        Navigator.pushNamed(context, '/userInfo');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("form_not_valid".tr()), backgroundColor: Colors.red),
        );
      }
    }

    // Validation functions for the form fields
    String? validateName(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'name_required'.tr();
      }
      return null;
    }

    String? validateDateOfBirth(String? value) {
      if (value == null || value.isEmpty) {
        return 'date_of_birth_required'.tr();
      }
      return null;
    }

    String? validatePhoneNumber(String? value) {
      final phoneExp = RegExp(r'^[0-9]{10,15}$');
      if (value == null || !phoneExp.hasMatch(value)) {
       return 'valid_phone_number'.tr();
       }
    return null;
}


    String? validateEmail(String? value) {
      if (value == null || !value.contains('@') || !value.contains('.')) {
        return 'valid_email'.tr();
      }
      return null;
    }

    String? _validatePassword(String? value) {
      if (value == null || value.length < 6) {
        return 'password_length'.tr();
      }
      return null;
    }

    String? _validateConfirmPassword(String? value) {
      if (value != _passController.text) {
        return 'password_mismatch'.tr();
      }
      return null;
    }
  }
