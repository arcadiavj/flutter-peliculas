import 'dart:html';

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  final peliculas = [
    'spiderman',
    'aquaman',
    'batman',
    'shazam',
    'ironman',
    'capitan america',
    'superMan',
    'IronMan 2',
  ];
  final peliculasRecientes = ['spiderman', 'capitan america'];
  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();
  @override
  List<Widget> buildActions(BuildContext context) {
    // las acciones del appbar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];

    //throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del appbar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
    //throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // resultados que vamos a mostrar

    //throw UnimplementedError();
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.amber,
        child: Text(seleccion),
      ),
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // sugerencias cuando la persona escribe
  //   //throw UnimplementedError();
  //   final listaSugerida = (query.isEmpty)
  //       ? peliculasRecientes
  //       : peliculas
  //           .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
  //           .toList();

  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugerida[i]),
  //         onTap: () {
  //           seleccion = listaSugerida[i];
  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  // }
  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias cuando la persona escribe
    //throw UnimplementedError();
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(builder:
        (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
      if (snapshot.hasData) {
        final peliculas = snapshot.data;
        return ListView(
            children: peliculas.map((pelicula) {
          return ListTile(
            leading: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(pelicula.getPosterImg()),
              fit: BoxFit.cover,
              width: 50.0,
            ),
            title: Text(pelicula.title),
            subtitle: Text(pelicula.originalTitle),
            onTap: () {
              close(context, null);
              pelicula.uniqueId = '';
              Navigator.pushNamed(context, 'detalle', arguments: pelicula);
            },
          );
        }).toList());
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
