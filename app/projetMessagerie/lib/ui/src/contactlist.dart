import 'package:flutter/material.dart';

import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:projetmessagerie/ui/pages/messagerie.dart';

class ListContacts extends StatefulWidget {
  const ListContacts({super.key, required this.socket, required this.setMsg});

  @override
  _ListContactsState createState() => _ListContactsState();
  final IO.Socket socket;
  final Function setMsg;
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
        appBar: AppBar(title: const Text('list_contacts')), body: _body());
  }

  Widget _body() {
    if (_permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) => ListTile(
            title: Text(_contacts![i].displayName),
            onTap: () async {
              String avatar = "img/pp.png";
              String nom = _contacts![i].displayName;

              InChatModel model = InChatModel(
                  avatarUrl: avatar,
                  nom: nom,
                  listmessage: [],
                  isOnLigne: true);

              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MyMessagePage(
                  lechoix: model,
                  socket: widget.socket,
                  setMsg: widget.setMsg,
                );
              }));

              /*final fullContact =
              await FlutterContacts.getContact(_contacts![i].id);
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));*/
            }));
  }
}

class ContactPage extends StatelessWidget {
  final Contact contact;
  const ContactPage(this.contact, {super.key});

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
