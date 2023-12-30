import 'package:flutter/material.dart';
import 'form_data.dart';
import 'database/db_helper.dart';
import 'model/data.dart';

class ListDataPage extends StatefulWidget {
  const ListDataPage({Key? key}) : super(key: key);

  @override
  _ListDataPageState createState() => _ListDataPageState();
}

class _ListDataPageState extends State<ListDataPage> {
  List<Data> listData = [];
  DbHelper db = DbHelper();

  @override
  void initState() {
    _getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Data Mahasiswa"),
        ),
      ),
      body: ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, index) {
          Data data = listData[index];
          return Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200], // Warna latar belakang avatar jika tidak ada gambar
                child: ClipOval(
                  child: SizedBox(
                    width: 60, // Sesuaikan dengan ukuran diameter lingkaran
                    height: 60,
                    child: data.imageBytes != null
                        ? Image.memory(
                            data.imageBytes!,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.person,
                            size: 50,
                          ),
                  ),
                ),
              ),
              title: Text('${data.nama}'),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Text("NIM: ${data.nim}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Text("Phone: ${data.nohp}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Text("Alamat: ${data.alamat}"),
                  )
                ],
              ),
              trailing: FittedBox(
                fit: BoxFit.fill,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _openFormEdit(data);
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteData(data, index);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _openFormCreate();
        },
      ),
    );
  }

  Future<void> _getAllData() async {
    var list = await db.getAllDataWithImage();
    setState(() {
      listData.clear();
      list!.forEach((data) {
        listData.add(Data.fromMap(data));
      });
    });
  }

  Future<void> _deleteData(Data data, int position) async {
    await db.deleteDataWithImage(data.id!);
    setState(() {
      listData.removeAt(position);
    });
  }

  Future<void> _openFormCreate() async {
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => FormData()));
    if (result == 'save') {
      await _getAllData();
    }
  }

  Future<void> _openFormEdit(Data data) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => FormData(data: data)));
    if (result == 'update') {
      await _getAllData();
    }
  }
}
