import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_kisiler_firebase/main.dart';
import 'package:firebase_database/firebase_database.dart';



class KisiKayit extends StatefulWidget {
  const KisiKayit({Key? key}) : super(key: key);

  @override
  State<KisiKayit> createState() => _KisiKayitState();
}

class _KisiKayitState extends State<KisiKayit> {
  var refKisiler = FirebaseDatabase.instance.ref().child("kisiler");

  var tfKisiAdi = TextEditingController();
  var tfKisiTel = TextEditingController();

  Future<void> kayit(String param1, String param2) async{
    var bilgi = HashMap<String,dynamic>();
    bilgi["kisi_id"]="";
    bilgi["kisi_ad"]=param1;
    bilgi["kisi_tel"]=param2;
    refKisiler.push().set(bilgi);

    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Anasayfa()));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(





      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Kişi Kaydı"),
      ),












      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[


              TextField(
                controller: tfKisiAdi,
                decoration: const InputDecoration(hintText: "Kişi Adı",),
              ),

              TextField(
                controller: tfKisiTel,
                decoration: const InputDecoration(hintText: "Kişi Cep Telefonu",),
              ),


            ],
          ),
        ),
      ),















      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          kayit(tfKisiAdi.text, tfKisiTel.text);
        },
        tooltip: 'Kişi Ekle',
        icon: const Icon(Icons.add_card),
        label: const Text("Kaydet"),
      ),










    );
  }
}
