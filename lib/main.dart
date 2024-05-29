import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_kisiler_firebase/Kisiler.dart';
import 'package:flutter_kisiler_firebase/Detay.dart';
import 'package:flutter_kisiler_firebase/KisiKayitSayfasi.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Anasayfa(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class Anasayfa extends StatefulWidget {
  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  var refKisiler = FirebaseDatabase.instance.ref().child("kisiler");

  Future<void> sil(String kisi_id) async {
    refKisiler.child(kisi_id).remove();
  }

  Future<bool> closeApp() async {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(



      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
            onPressed: () {
              closeApp();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: aramaYapiliyorMu
            ? TextField(
                decoration: const InputDecoration(
                  hintText: "Aramak için bir şey yazın",
                ),
                onChanged: (aramaSonucu) {
                  print("Arama sonucu : $aramaSonucu");
                  setState(() {
                    aramaKelimesi = aramaSonucu;
                  });
                },
              )
            : const Text("Kişiler Listesi"),
        actions: [
          aramaYapiliyorMu
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = false;
                      aramaKelimesi = "";
                    });
                  },
                  icon: const Icon(Icons.cancel_outlined),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = true;
                    });
                  },
                  icon: const Icon(Icons.person_search_outlined),
                ),
        ],
      ),




      body: WillPopScope(
        onWillPop: closeApp,
        child: StreamBuilder<DatabaseEvent>(
            stream: refKisiler.onValue,
            builder: (context, event) {
              if (event.hasData) {
                var kisilerListesi = <Kisiler>[];
                var gelenDeger = event.data!.snapshot.value as dynamic;
                if (gelenDeger != null) {
                  gelenDeger.forEach((key, nesne) {
                    var gelenKisi = Kisiler.fromJson(key, nesne);
                    if (aramaYapiliyorMu) {
                      if (gelenKisi.kisi_ad.contains(aramaKelimesi)) {
                        kisilerListesi.add(gelenKisi);
                      }
                    } else {
                      kisilerListesi.add(gelenKisi);
                    }
                  });
                }
                return ListView.builder(
                    itemCount: kisilerListesi.length,
                    itemBuilder: (context, index) {
                      var kisiMain = kisilerListesi[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Detay(
                                        kisi: kisiMain,
                                      )));
                        },
                        child: Card(
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  kisiMain.kisi_ad,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(kisiMain.kisi_tel),
                                IconButton(
                                    onPressed: () {
                                      sil(kisiMain.kisi_id);
                                    },
                                    icon: const Icon(
                                        Icons.delete_forever_outlined)),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return Container(
                  color: Colors.indigoAccent,
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const KisiKayit()));
        },
        tooltip: 'Kişi Ekle',
        child: const Icon(Icons.add_card),
      ),
    );
  }
}
