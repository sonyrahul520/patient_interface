import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:patient_interface/HomePage.dart';

class UserInterface extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Dashboard(),
    );
  }

}

class Dashboard extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text('Users'),
    ),

        body:Container(
            child:Center(
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>Profile()));}, child: Text('Profile')),
                      ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>Appointments()));},  child: Text('Appointments')),
                      ElevatedButton(onPressed: null, child: Text ('Prescription')),
                      ElevatedButton(onPressed: null, child: Text('Doctors Notes')),
                      ElevatedButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>IndexPage()));}, child: Text('Attend a call'))
                    ]

                )
            )
        )
    );
  }

}

class Profile extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title:Text('Profile'),


    ),
      body: PatientForm(),


    );
  }

}

class PatientForm extends StatefulWidget{
  @override
  ThisPatientForm createState() {
    return ThisPatientForm();
  }



}
enum SingingCharacter {male,female}
class ThisPatientForm extends State<PatientForm>{

  final _formKey = GlobalKey<FormState>();
  //DatabaseReference reference = FirebaseDatabase.DefaultInstance.RootReference;
  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final address = TextEditingController();
  final GP = TextEditingController();
  final nhsNo = TextEditingController();



  SingingCharacter _character = SingingCharacter.male;
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(

          children: <Widget>[

            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Enter the First Name",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the Patient first name';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: lastnameController,
                decoration: InputDecoration(
                  labelText: "Enter the Last Name",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the last name';
                  }
                  return null;
                },
              ),
            ),
            ListTile(
              title: const Text('Male'),
              leading: Radio(
                value: SingingCharacter.male,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Female'),
              leading: Radio(
                value: SingingCharacter.female,
                groupValue: _character,
                onChanged: (SingingCharacter value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: address,
                decoration: InputDecoration(
                  labelText: "Enter the Address with postcode",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the address ';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: GP,
                decoration: InputDecoration(
                  labelText: "Enter the GP Name",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter your GP name';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: nhsNo,
                decoration: InputDecoration(
                  labelText: "Enter your NHS No",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter your NHS no';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
// Validate returns true if the form is valid, or false
// otherwise.
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Profile2()));
                  if (_formKey.currentState.validate()) {
                    final firestoreInstance = FirebaseFirestore.instance;

                    var firebaseUser =  FirebaseAuth.instance.currentUser;

                    FirebaseFirestore.instance
                        .collection('users').doc(firebaseUser.uid).update(
                        {'first name' : nameController.text,
                      'last name'   : lastnameController.text,

                      'address' : address.text,
                      'NHS No' : nhsNo.text,
                      'GP' : GP.text,
                    });



// If the form is valid, display a Snackbar.
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                  }
                },
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Profile2 extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title:Text('Profile'),


    ),
      body: PatientForm2(),


    );
  }

}

class PatientForm2 extends StatelessWidget{

  final _formKey = GlobalKey<FormState>();
  final occupationControll = TextEditingController();
  final pastIllnessControll = TextEditingController();
  final currentMedicationControll = TextEditingController();
  final AllergiesControll = TextEditingController();
  final operationsControll = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: occupationControll,
                decoration: InputDecoration(
                  labelText: "Enter your Occupation",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the occupation';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: pastIllnessControll,
                decoration: InputDecoration(
                  labelText: "Enter any Past Illness.",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the past illness or enter Nill if none';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: currentMedicationControll,
                decoration: InputDecoration(
                  labelText: "Enter any Current Medication ",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the current Medication';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: AllergiesControll,
                decoration: InputDecoration(
                  labelText: "Enter the history of any Allergies you have",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the Allergies ';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: operationsControll,
                decoration: InputDecoration(
                  labelText: "Enter the details about past operations",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter the details about past operations ';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
// Validate returns true if the form is valid, or false
// otherwise.
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Dashboard()));
                  if (_formKey.currentState.validate()) {


                    FirebaseFirestore.instance
                        .collection('PatientInfo')

                        .add({'Occupation' : occupationControll.text,
                      'Past Illness'   : pastIllnessControll.text,

                      'Current Medication' : currentMedicationControll.text,
                      'Allergies' : AllergiesControll.text,
                      'Operations' : operationsControll.text,



                    });
// If the form is valid, display a Snackbar.
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],








        ),

      ),

    );

  }


}
class Appointments extends StatelessWidget{



  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text('Appointment'),
    ),

        body:Container(
            child:Center(
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>EmergencyAppointment()));}, child: Text('Sooner Appointment')),
                      ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>NonEmergencyAppointment()));},  child: Text('Later Appointment')),


                    ]

                )
            )
        )

    );
  }

}



class EmergencyAppointment extends StatelessWidget{

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(appBar: AppBar(title: Text('Sooner Appointment'),
    ),
        body: Container(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Text("You will receive the call in 2-3 hours"),
                    RaisedButton(onPressed: (){ Navigator.push(context,MaterialPageRoute(builder: (context)=>Dashboard()));
                     {

                      final firestoreInstance = FirebaseFirestore.instance;

                      var firebaseUser =  FirebaseAuth.instance.currentUser;
                   final DateTime now = DateTime.now();
                      FirebaseFirestore.instance
                          .collection('users').doc(firebaseUser.uid).update(
                          {'Appointment time' : now,

                          });

// If the form is valid, display a Snackbar.
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('Processing Data')));
                    }}, child: Text('Confirm'),),



                  ],

              ),


            )

        )

    );
  }

}

class NonEmergencyAppointment extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final time = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,

        child: SingleChildScrollView(
          child: Column(

            children: <Widget>[
              Text("Book appointment for any of the following time"),
              ElevatedButton(onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>Dashboard()));
              if (_formKey.currentState.validate()) {

                final firestoreInstance = FirebaseFirestore.instance;

                var firebaseUser =  FirebaseAuth.instance.currentUser;

                FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).update({

                      'time' : "9-12",

                });
// If the form is valid, display a Snackbar.
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
              }



              },child: Text("9.00-12.00")),
              ElevatedButton(onPressed: null, child: Text("12.00-15.00") ),
              ElevatedButton(onPressed: null, child: Text("15.00-18.00"))




            ],


          ),



        ),



      );


  }
}



