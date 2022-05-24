import 'dart:io';

class Datos {
  late String nombre;
  late String correo;
  late String telefono;

  ///late String foto;
  File? imageFile;
  static String downloadURL = "";

  Datos(this.nombre,
      this.correo,
      this.telefono,);
}