import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projetmessagerie/models/user.dart';
import 'package:projetmessagerie/repositories/user_repository.dart';
import 'package:projetmessagerie/ui/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<Map<String, String>> _user;

  String? pseudo = '';
  String? phone = '';

  @override
  void initState() {
    super.initState();

    _user = _prefs.then((SharedPreferences prefs) {
      pseudo = prefs.getString('pseudo') ?? 'NoCurrentPseudo';
      phone = prefs.getString('phone') ?? 'NoCurrentPhone';
      return {
        'pseudo': prefs.getString('pseudo') ?? 'NoCurrentPseudo',
        'phone': prefs.getString('phone') ?? 'NoCurrentPhone',
      };
    });
  }

  // Define differents screens of the navigation bar
  Widget homeScreen() {
    return Center(
      child: FutureBuilder<Map<String, String>>(
        future: _user,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Pseudo:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("${snapshot.data!['pseudo']}",
                            style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Phone Number:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("${snapshot.data!['phone']}",
                            style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: const Text(
                        'Connected',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }

  Widget usersScreen() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<User>>(
          future: Get.put(UserRepository()).getUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ListTile(
                            tileColor: Colors.amber,
                            leading: const Icon(Icons.verified_user),
                            title:
                                Text("Pseudo: ${snapshot.data![index].pseudo}"),
                            subtitle:
                                Text("+237${snapshot.data![index].phone}"),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  );
                }
            }
          },
        ),
      ),
    );
  }

  // Navigation bar current index
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (currentIndex == 0) ? homeScreen() : usersScreen(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return HomeConvPage(
              pseudo: pseudo!,
              number: phone!,
            );
          }));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.navigate_next),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
