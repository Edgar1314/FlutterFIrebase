import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class ListaDatos extends StatelessWidget {
  //final List<Datos> lista;
  // ListaDatos( this.lista);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red.shade900,
          title: Text("Datos aspirantes")
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance.collection('datos').orderBy('nombre').snapshots(),//loadAllAspirantes(),
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (!data.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: data.data!.docs.map((DocumentSnapshot document) {
                return ListTile(
                  title: Text("Nombre:"+document.data()!['nombre']),
                  subtitle: Text("Correo:"+document.data()!['correo']+"\n"+
                      "Telefono:"+document.data()!['telefono']),
                  leading: Image(
                    image: NetworkImage(document.data()!['foto']),
                    fit: BoxFit.fitHeight,
                    width: 50,
                  ),
                );
              }).toList(),

            );
          }),);
  }

}