import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:basedatos/pages/lista.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

import 'datos.dart';
import 'lista2.dart';

//import 'card.dart';

class Formulario extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return miFormulario();
  }

}
class miFormulario extends State<Formulario>{
  final _controladorn=TextEditingController();
  final _controladorc=TextEditingController();
  final _controladort=TextEditingController();

  List <Datos> _datos=[];
  Datos? dat=Datos("", "", "");
  bool imagen=false;
  String rutaImagen="";

  File? imageFile;
  final picker=ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future  guardarDatosN(String nombre,String correo,String telefono) async{
    final fileName = basename(imageFile!.path);
    final destination = "fotosUsuarios";

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(fileName);
      await ref.putFile(imageFile!);
      final datos= FirebaseFirestore.instance.collection('datos');
      datos.add({
        'nombre':nombre,
        'correo':correo,
        'telefono':telefono,
        'foto':await ref.getDownloadURL(),
      });
    } catch (e) {
      print('error  no seas ranchero occured');
    }

  }

  Future<void> mostrarSeleccion(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Seleccione opcion para foto"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: (){
                      abrirGaleria(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(12.00)),
                  GestureDetector(
                      child: Text("Camara"),
                      onTap: (){
                        abrirCamara(context);
                      }
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  Future uploadFile() async {
    if (imageFile == null) return;
    final fileName = basename(imageFile!.path);
    final destination = "fotosUsuarios";

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(fileName);
      await ref.putFile(imageFile!);
      rutaImagen= await ref.getDownloadURL();
      print(""+await ref.getDownloadURL());

    } catch (e) {
      print('error occured');
    }
  }

  Future <void> guardarDatos(String nombre,String correo,String telefono,String foto){
    final datos= FirebaseFirestore.instance.collection('datos');
    return datos.add({
      'nombre':nombre,
      'correo':correo,
      'telefono':telefono,
      'foto':foto,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulario"),
        backgroundColor: Colors.red.shade900,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(10.0)),
              mostrarImagen(),
              Padding(padding: EdgeInsets.all(10.0)),
              TextField(
                controller: _controladorn,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(padding: EdgeInsets.all(10.0)),
              TextField(
                controller: _controladorc,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Correo",
                  border: OutlineInputBorder(),
                ),

              ),
              Padding(padding: EdgeInsets.all(10.0)),
              TextField(
                controller: _controladort,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Telefono",
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(padding: EdgeInsets.all(10.0)),

              Padding(padding: EdgeInsets.all(10.0)),
              ElevatedButton(

                onPressed: (){

                  dat!.nombre=_controladorn.text;
                  dat!.correo=_controladorc.text;
                  dat!.telefono=_controladort.text;

                  guardarDatosN(dat!.nombre, dat!.correo, dat!.telefono);
                  _controladorn.clear();
                  _controladorc.clear();
                  _controladort.clear();

                },
                child: Text("Enviar"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.red.shade900,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),

              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          Navigator.push(context,
              MaterialPageRoute(builder: (context){
                return searchScreen2();
              }));
        },
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.red.shade900,
      ),
    );
  }//build

  void abrirGaleria(BuildContext context) async {
    final picture=await picker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile=File(picture!.path);
      // uploadFile();
    });
    Navigator.pop(context);

  }
  void abrirCamara(BuildContext context) async {
    final picture=await picker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile=File(picture!.path);
      //uploadFile();

    });
    Navigator.pop(context);

  }

  Widget mostrarImagen() {
    if(imageFile!=null){

      return GestureDetector( child: ClipOval(
        child: Image.file(imageFile!,width: 200, height: 200),

      ),
        onTap: (){
          mostrarSeleccion(this.context);
        } ,);

    }else{

      return GestureDetector(
          child: CircleAvatar(
            radius: 65,
            backgroundColor: Colors.black,
            child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/read.png")),

          ),
          onTap: (){
            mostrarSeleccion(this.context);
          });
    }
  }

  //metodos para validad datos
  bool validarNombre(String cadena){
    RegExp exp= new RegExp(r'^[a-zA-Z]+[ a-zA-Z]*$');
    if(cadena.isEmpty){
      return false;
    }else if(!exp.hasMatch(cadena)){
      return false;
    }else{
      return true;
    }
  }
  bool validarCorreo(String cadena) {
    RegExp exp = new RegExp(r"^[a-z0-9!#$%&'+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'+/=?^_`{|}~-]+)@(?:[a-z0-9](?:[a-z0-9-][a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$");
    if (cadena.isEmpty) {
      return false;
    } else if (!exp.hasMatch(cadena)) {
      return false;
    } else {
      return true;
    }
  }
  bool validarTelefono(String cadena){
    RegExp exp= new RegExp(r"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$");
    if(cadena.isEmpty){
      return false;
    }else if(!exp.hasMatch(cadena)){
      return false;
    }else{
      return true;
    }
  }

  void alerta(BuildContext context){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Alerta!!'),
            content: Text("Verifique la información"),
            actions: <Widget>[
              new ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("Ok"),
              )
            ],
          );
        }
    );
  }



}

