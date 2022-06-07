// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class Sliv extends StatefulWidget {
  const Sliv({Key? key}) : super(key: key);

  @override
  _SlivState createState() => _SlivState();
}

class _SlivState extends State<Sliv> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        // SliverPadding(padding: EdgeInsets.symmetric(horizontal: 12), sliver: Card(child: Text('sdj'))),
        const SliverAppBar(
          floating: true,
          // pinned: true,
          snap: true,
          flexibleSpace: FlexibleSpaceBar(
            background: FlutterLogo(),
            title: Text('sdhsg'),
          ),
          expandedHeight: 200,
          leading: Icon(Icons.back_hand),
          title: Text('Appbar'),
          centerTitle: true,
          actions: [
            Icon(Icons.back_hand),
          ],
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return const ListTile(
            title: Text('sadjhasdas'),
          );
        }, childCount: 50)),
      ],
    ));
  }
}
