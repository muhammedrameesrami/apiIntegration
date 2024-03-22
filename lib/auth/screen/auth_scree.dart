import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../home/screen/todoList.dart';
import 'package:http/http.dart'as http;
class authScreen extends StatefulWidget {
  const authScreen({super.key});

  @override
  State<authScreen> createState() => _authScreenState();
}

class _authScreenState extends State<authScreen> {

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  void login( String email,password)async{
    try{
      Response response= await post(Uri.parse('https://reqres.in/api/register'),
      body: {
        'email':email,
        'password':password,
      }) ;
      if(response.statusCode==200){
        var data=jsonDecode(response.body.toString());
        print(data['token']);
        shoSuccessMessage('api sign up success', context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ToDoList(),), (route) => false);

      }else{
        shoSuccessMessage('api sign up failed', context);
      }
    }catch(error){
      print(error);
      shoSuccessMessage(error.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// reqres.in api
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up Api'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('eve.holt@reqres.in   pistol'),
          TextFormField(
            decoration: InputDecoration(hintText: 'Email'),
            controller: emailController,
          ),SizedBox(height: 20,),
          TextFormField(controller: passwordController,
          decoration: InputDecoration(hintText: 'password'),),
          SizedBox(height: 40,),
          InkWell( onTap: (){
            login(emailController.text.trim().toString(),passwordController.text.trim().toString());

          },
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.purple.shade800,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(child: Text('Sign Up'),),
            ),
          )

        ],
      ),
    );
  }
}
