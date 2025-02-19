import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:maven/common/common.dart';
import 'package:maven/database/database.dart';
import 'package:maven/feature/user/screen/user_setup_screen.dart';
import 'package:multiavatar/multiavatar.dart';

import '../../../database/database.dart';
import '../../../database/table/user.dart'; // Alias for user table Gender
import '../../theme/theme.dart';
import '../user.dart';

class UserEditScreen extends StatefulWidget {
  const UserEditScreen({
    Key? key,
    required this.user,
    
    // required this.database,
  }) : super(key: key);

  final User user;
  
  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  late User user;
  late TritiumDatabase database;

  @override
  void initState() {
    user = widget.user.copyWith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(
            T(context).space.large,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              T(context).shape.large,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: T(context).color.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () async {},
                    child: CircleAvatar(
                      minRadius: 50,
                      maxRadius: 100,
                      child: Image.asset(
                        user.picture,
                        fit: BoxFit.fill, // Adjust fit as needed
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      value = value.isEmpty ? widget.user.username : value;
                      setState(() {
                        user = user.copyWith(
                          username: value,
                          picture: multiavatar(value),
                        );
                      });
                      context.read<UserBloc>().add(
                            UserUpdate(
                              user: user,
                            ),
                          );
                    },
                    initialValue: user.username,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    textAlign: TextAlign.center,
                    decoration:
                        InputDecoration.collapsed(hintText: user.username),
                    style: T(context).textStyle.headingMedium,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        user = user.copyWith(
                          description: value,
                        );
                      });
                      context.read<UserBloc>().add(
                            UserUpdate(
                              user: user,
                            ),
                          );
                    },
                    initialValue: user.description,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    style: T(context).textStyle.titleSmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: T(context).color.outline,
                    height: 1,
                  ),
                  Material(
                    color: T(context).color.surface,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          onTap: () {
                            showBottomSheetDialog(
                                context: context,
                                child: TextInputDialog(
                                  title: 'Age',
                                  initialValue: user.age.toString(),
                                  keyboardType: TextInputType.number,
                                  onValueSubmit: (value) {
                                    setState(() {
                                      user = user.copyWith(
                                        age: double.parse(value).toInt(),
                                      );
                                    });
                                    context.read<UserBloc>().add(
                                          UserUpdate(
                                            user: user,
                                          ),
                                        );
                                  },
                                ));
                          },
                          title: const Text(
                            'Age',
                          ),
                          trailing: Text(
                            '${user.age}',
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'Gender',
                          ),
                          trailing: Text(
                            user.gender!.name,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            showBottomSheetDialog(
                              context: context,
                              child: TextInputDialog(
                                title: 'Height (cm)',
                                initialValue: user.height.toString(),
                                keyboardType: TextInputType.number,
                                onValueSubmit: (value) {
                                  setState(() {
                                    user = user.copyWith(
                                      height: double.parse(value),
                                    );
                                  });
                                  context.read<UserBloc>().add(
                                        UserUpdate(
                                          user: user,
                                        ),
                                      );
                                },
                              ),
                            );
                          },
                          title: const Text(
                            'Height',
                          ),
                          trailing: Text(
                            '${user.height} cm',
                          ),
                        ),


                        ListTile(
                          onTap: () {
                            showBottomSheetDialog(
                              context: context,
                              child: TextInputDialog(
                                title: 'Weight (kg)',
                                initialValue: user.weight.toString(),
                                keyboardType: TextInputType.number,
                                onValueSubmit: (value) {
                                  setState(() {
                                    user = user.copyWith(
                                      weight: double.parse(value),
                                    );
                                  });
                                  context.read<UserBloc>().add(
                                        UserUpdate(
                                          user: user,
                                        ),
                                      );
                                },
                              ),
                            );
                          },
                          title: const Text(
                            'Weight',
                          ),
                          trailing: Text(
                            '${user.weight} kg',
                          ),
                        ),




                        ListTile(
                          title: const Text(
                            'Created At',
                          ),
                          trailing: Text(
                            DateFormat.MMMMEEEEd().format(user.createdAt),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 229, 96, 86),
                          ),
                          onPressed: () {
                            // Show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return AlertDialog(
                                //   title: const Text('Delete User'),
                                //   content: 
                                  
                                //   const Text(
                                //       'WARNING\nDeleting the user will close the application'),
                                //   actions: <Widget>[
                                //     TextButton(
                                //       onPressed: () {
                                //         Navigator.of(context)
                                //             .pop(); // Close the dialog
                                //       },
                                //       child: const Text('Cancel'),
                                //     ),
                                //     TextButton(
                                //       onPressed:  () {
                                //           context.read<RoutineDao>().deleteRoutineTable();
                                //            context.read<TemplateDataDao>().dropTemplateDataTable();
                                         
                                //         // Perform delete action
                                //         context .read<UserBloc>().add(UserDelete(user.id));
                                //         // TritiumDatabase.initialize();

                                //       },
                                //       child: const Text('Delete'),
                                //     ),
                                //   ],
                                // );
                                return AlertDialog(
  title: const Text('Delete User'),
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(
        Icons.warning_rounded,
        size: 60,
        color: Colors.red,
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(height: 10),
      ),
      Text(
        'Deleting the user will close the application',
        textAlign: TextAlign.center,
      ),
    ],
  ),
  actions: <Widget>[
    TextButton(
      
      onPressed: () {
        Navigator.of(context).pop(); // Close the dialog
      },
      child: const Text('Cancel'),
    ),
    // TextButton(
    //   onPressed: () {
    //     context.read<RoutineDao>().deleteRoutineTable();
    //     context.read<TemplateDataDao>().dropTemplateDataTable();
    //     // Perform delete action
    //     context.read<UserBloc>().add(UserDelete(user.id));
    //   },
    //   child: const Text('Delete'),
    // ),
    TextButton(
  style: TextButton.styleFrom(
    foregroundColor: Colors.red, // Set text color to red
  ),
  onPressed: () {
    context.read<RoutineDao>().deleteRoutineTable();
    context.read<TemplateDataDao>().dropTemplateDataTable();
    // Perform delete action
    context.read<UserBloc>().add(UserDelete(user.id));
  },
  child: const Text('Delete'),
)

  ],
);

                              },
                            );
                          },
                          child: const Text(
                            'Delete User',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
