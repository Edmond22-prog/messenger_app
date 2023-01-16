
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:projetmessagerie/ui/messagerie.dart';

class ListContacts extends StatefulWidget {
  @override
  _ListContactsState createState() => _ListContactsState();
}

class _ListContactsState extends State<ListContacts> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;


  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('list_contacts')),
        body: _body()
    );
  }
  Widget _body() {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: CircularProgressIndicator());
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) => ListTile(
            title: Text(_contacts![i].displayName),
            onTap: () async {
              String avatar="img/pp.png";
              String nom = _contacts![i].displayName;

              InChatModel _model = new InChatModel(avatarUrl: avatar, nom: nom, listmessage: [], isOnLigne: true) ;

              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return MyMessagePage(lechoix: _model);
                  }));

              /*final fullContact =
              await FlutterContacts.getContact(_contacts![i].id);
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));*/
            }
            ));
  }
}

class ContactPage extends StatelessWidget {
  final Contact contact;
  ContactPage(this.contact);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(contact.displayName)),
      body: Column(children: [
        Text('First name: ${contact.name.first}'),
        Text('Last name: ${contact.name.last}'),
        Text(
            'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
        Text(
            'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
      ]));
}