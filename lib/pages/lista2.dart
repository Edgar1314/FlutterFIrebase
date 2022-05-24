import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class searchScreen2 extends StatefulWidget {
  const searchScreen2({Key? key}) : super(key: key);

  @override
  State<searchScreen2> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen2> {
  final TextEditingController searchController = TextEditingController();
  bool isShowOrder = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  Future<Query?> searchQuery() async {
    var query = FirebaseFirestore.instance.collection('datos');
    var query2 =
    query.where('nombre', isEqualTo: searchController.text);//isGreaterThanOrEqualTo
    return query2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: TextFormField(
          cursorColor: Colors.white,
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search for an order',
          ),
          style: TextStyle(color: Colors.black),
          onFieldSubmitted: (String searchQuery) {
            setState(() {
              isShowOrder = true;
              print(searchQuery);
            });
          },
        ),
      ),
      body: isShowOrder
          ? FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('datos')
            .where('nombre', isEqualTo: searchController.text)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,//SOLO MUETRA UN REGISTRO
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {

                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        (snapshot.data! as dynamic).docs[index]['foto']
                    ),
                  ),
                  title: Text(
                    'Nombre: ${(snapshot.data! as dynamic).docs[index]['nombre'].toString()}',
                  ),
                  subtitle: Text(
                    'Correo: ${(snapshot.data! as dynamic).docs[index]['correo'].toString()}',
                  ),
                ),
              );
            },
          );
        },
      )
          : StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance.collection('datos').snapshots(),//loadAllAspirantes(),
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (!data.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: data.data!.docs.map((DocumentSnapshot document) {
                return ListTile(
                  title: Text("Nombre: "+document.data()!['nombre']),
                  subtitle: Text("Correo: "+document.data()!['correo']+"\n"+
                      "Telefono: "+document.data()!['telefono']),
                );
              }).toList(),
            );
          }),

    );
  }
}