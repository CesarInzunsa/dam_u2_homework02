import 'package:flutter/material.dart';
import '../model/music.dart';
import '../controller/musicController.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _albumController = TextEditingController();
  final TextEditingController _releaseYearController = TextEditingController();
  List<Music> _musicList = [];
  final MusicController _musicController = MusicController();
  String selectedItem = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _drawBody(),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 50,
                      child: const Icon(
                        Icons.supervised_user_circle_outlined,
                        size: 50,
                      )),
                  const SizedBox(height: 10),
                  const Text(
                    'Admin',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _itemDrawer(0, Icons.insert_comment_outlined, 'CAPTURAR'),
            _itemDrawer(1, Icons.view_agenda_outlined, 'MOSTRAR'),
            _itemDrawer(2, Icons.delete_forever_outlined, 'ELIMINAR'),
            _itemDrawer(3, Icons.edit_outlined, 'ACTUALIZAR'),
            _itemDrawCloseSession(),
          ],
        ),
      ),
    );
  }

  Widget _drawBody() {
    switch (_index) {
      case 1:
        return _drawShow();
      case 2:
        return _drawDelete();
      case 3:
        return _drawUpdate();
      default:
        return _drawCapture();
    }
  }

  Widget _drawCapture() {
    setState(() {
      _clearFields();
    });
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Capture Music Info',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text('Fill the form to capture a new music info:'),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _artistController,
                  decoration: const InputDecoration(labelText: 'Artist'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an artist';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _albumController,
                  decoration: const InputDecoration(labelText: 'Album'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an album';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _releaseYearController,
                  decoration: const InputDecoration(labelText: 'Release Year'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a release year';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if(int.parse(value) < 1900 || int.parse(value) > 2024){
                      return 'Please enter a valid year between 1900 and 2024';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Music music = Music(
                        title: _titleController.text,
                        artist: _artistController.text,
                        album: _albumController.text,
                        releaseYear: int.parse(_releaseYearController.text),
                      );
                      // Do something with the music

                      _clearFields();
                      _createNewMusic(music);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _createNewMusic(Music music) {
    _musicController.createMusic(music);
  }

  void _clearFields() {
    _titleController.clear();
    _artistController.clear();
    _albumController.clear();
    _releaseYearController.clear();
  }

  Widget _drawShow() {
    return FutureBuilder(
        future: _fetchSongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            }
            if (_musicList.isNotEmpty) {
              return Column(
                children: [
                  const Text(
                    'Music List',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView(
                      children: _drawSongs(),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No data'));
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<void> _fetchSongs() async {
    _musicList = await _musicController.readMusic();
  }

  List<Widget> _drawSongs() {
    List<ListTile> list = [];
    for (Music music in _musicList) {
      list.add(ListTile(
        title: Text(music.title),
        subtitle: Text('${music.artist} - ${music.album}'),
        trailing: Text(music.releaseYear.toString()),
      ));
    }
    return list;
  }

  Widget _drawDelete() {
    return FutureBuilder(
      future: _fetchSongs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          if (_musicList.isEmpty) {
            return const Center(child: Text('No data'));
          }
          return Column(
            children: [
              const Text(
                'Delete Music',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text('Select a music to delete:'),
              Expanded(
                child: ListView(
                  children: _drawMusicDelete(),
                ),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  List<ListTile> _drawMusicDelete() {
    return _musicList.map((music) {
      return ListTile(
        title: Text(music.title),
        subtitle: Text('${music.artist} - ${music.album}'),
        trailing: Text(music.releaseYear.toString()),
        onTap: () {
          _showDialogDelete(music);
        },
      );
    }).toList();
  }

  _showDialogDelete(Music music) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Music'),
            content: Text('Are you sure you want to delete ${music.title}?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  _deleteMusicWithName(music);

                  await _fetchSongs();

                  setState(() {
                    _musicList;
                  });
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }

  void _deleteMusicWithName(Music music) {
    _musicController.deleteMusic(music);
  }

  Widget _drawUpdate() {
    return FutureBuilder(
        future: _fetchSongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            }
            if (_musicList.isEmpty) {
              return const Center(child: Text('No data'));
            }
            return Column(
              children: [
                const Text(
                  'Update Music Info',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text('Select a music to update:'),
                Expanded(
                  child: ListView(
                    children: _drawMusicUpdate(),
                  ),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  List<ListTile> _drawMusicUpdate() {
    return _musicList.map((music) {
      return ListTile(
        title: Text(music.title),
        subtitle: Text('${music.artist} - ${music.album}'),
        trailing: Text(music.releaseYear.toString()),
        onTap: () {
          _showDialogUpdate(music);
        },
      );
    }).toList();
  }

  _showDialogUpdate(Music music) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Music Info'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController..text = music.title,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    controller: _artistController..text = music.artist,
                    decoration: const InputDecoration(labelText: 'Artist'),
                  ),
                  TextFormField(
                    controller: _albumController..text = music.album,
                    decoration: const InputDecoration(labelText: 'Album'),
                  ),
                  TextFormField(
                    controller: _releaseYearController
                      ..text = music.releaseYear.toString(),
                    decoration:
                        const InputDecoration(labelText: 'Release Year'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    _updateMusicWithName(music);
                    await _fetchSongs();

                    setState(() {
                      _musicList;
                    });
                  },
                  child: const Text('Actualizar')),
            ],
          );
        });
  }

  void _updateMusicWithName(Music oldDataMusic) {
    Music newDataMusic = Music(
      title: _titleController.text,
      artist: _artistController.text,
      album: _albumController.text,
      releaseYear: int.parse(_releaseYearController.text),
    );

    _musicController.updateMusic(oldDataMusic, newDataMusic);
  }

  _itemDrawCloseSession() {
    return ListTile(
      leading: const Icon(Icons.logout_outlined),
      title: const Text('Cerrar Sesión'),
      onTap: () {
        Navigator.popUntil(context, ModalRoute.withName('/'));
      },
    );
  }

  _itemDrawer(int index, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        setState(() {
          _index = index;
        });
        Navigator.pop(context);
      },
    );
  }
}
