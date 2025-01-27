
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maven/database/database.dart';
import 'package:maven/feature/template/bloc/template/workout_template_service.dart';
import 'package:maven/feature/user/services/shared_preferences_data.dart';
import '../bloc/user/user_bloc.dart';
import '../../../database/table/user.dart';
import 'package:maven/feature/app/screen/app_screen.dart';
class UserSetupScreen extends StatefulWidget {
  const UserSetupScreen({Key? key}) : super(key: key);

  @override
  State<UserSetupScreen> createState() => _UserSetupScreenState();
}

class _UserSetupScreenState extends State<UserSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  int _age = 0;
  Gender _gender = Gender.male; // Default gender is male
  double _height = 0.0;
  int _goal = 0;

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
  _formKey.currentState!.save();

  // Save user profile data
  String picturePath = _gender == Gender.male 
      ? 'assets/images/maleAvatar.png' 
      : 'assets/images/femaleAvatar.png';
  int _id = (_height*_age-_height+2-1*100+_age-22).toInt();
  final user = User(
    id: _id,
    username: _name,
    description: _description,
    gender: _gender,
    height: _height,
    age: _age,
    createdAt: DateTime.now(),
    picture: picturePath,
  );

  // Save user data to global settings
  await GlobalSettings.setGoal(_goal);
  context.read<UserBloc>().add(UserAdd(user));

  // Mock routine and exercise list data
  generateMockWorkoutData(context, _goal);


  // Navigate to the main app screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const Maven()),
  );
}

  }

  @override
  Widget build(BuildContext context) {
final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;


    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Profile Setup ")),
      body: SingleChildScrollView(
        child: Padding(
           padding: EdgeInsets.symmetric(horizontal: 16.0).add(
            EdgeInsets.only(bottom: keyboardVisible ? 16.0 : 0),),
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400), // Fixed width for consistency
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter a name" : null,
                      onSaved: (value) => _name = value!,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Age",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Enter your age",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your age";
                        }
                        final age = int.tryParse(value);
                        if (age == null || age <= 0) {
                          return "Enter a valid age";
                        }
                        return null;
                      },
                      onSaved: (value) => _age = int.parse(value!),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Gender",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<Gender>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      value: _gender,
                      onChanged: (Gender? newGender) {
                        setState(() {
                          _gender = newGender!;
                        });
                      },
                      onSaved: (value) => _gender = value!,
                      items: Gender.values.map((Gender gender) {
                        return DropdownMenuItem<Gender>(
                          value: gender,
                          child: Text(gender.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              
                                const Text(
                                  "Height (ft)",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: "Enter ft",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter ft";
                                    }
                                    final feet = int.tryParse(value);
                                    if (feet == null || feet < 0) {
                                      return "Enter valid ft";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    final feet = int.parse(value!);
                                    _height += feet * 30.48; // Convert feet to cm
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Height (In)",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: "Enter In",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter In";
                                    }
                                    final inches = int.tryParse(value);
                                    if (inches == null || inches < 0 || inches >= 12) {
                                      return "Enter valid In (0-11)";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    final inches = int.parse(value!);
                                    _height += inches * 2.54; // Convert inches to cm
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
          
                    const SizedBox(height: 20),
                    const Text(
                      "Description",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Enter a short description about yourself",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? "Enter a description"
                              : null,
                      onSaved: (value) => _description = value!,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Goal",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Enter workout days",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter workout days";
                        }
                        final _goal = int.tryParse(value);
                        if (_goal == null || _goal<= 0) {
                          return "Enter valid workout days";
                        }
                        return null;
                      },
                      onSaved: (value) => _goal = int.parse(value!),
                      
                    ),
                    const SizedBox(height: 20),
          
                    const SizedBox(height:20 ),
                    Center(
                      child: SizedBox(
                        width: 160,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 59, 83, 148),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _saveUserData,
                          child: const Text("Save", style: TextStyle(fontSize: 18,color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
