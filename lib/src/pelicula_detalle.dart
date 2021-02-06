import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

import 'models/actores_model.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
          child: CustomScrollView(
        slivers: [
          _crearAppbar(pelicula),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10.0,
            ),
            _posterTitulo(pelicula, context),
            _descripcion(pelicula),
            _descripcion(pelicula),
            _descripcion(pelicula),
            _descripcion(pelicula),
            _crearCasting(pelicula),
          ]))
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.assignment_return),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _crearAppbar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(pelicula.title,
            style: TextStyle(color: Colors.white, fontSize: 16.0)),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgorundImageImg()),
          placeholder: AssetImage(('assets/img/loading.gif')),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  _posterTitulo(Pelicula pelicula, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pelicula.originalTitle,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                pelicula.originalTitle,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Row(
                children: [
                  Icon(Icons.star_border),
                  Text(
                    pelicula.voteAverage.toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  _crearCasting(Pelicula pelicula) {
    final peliProv = new PeliculasProvider();
    return FutureBuilder(
      future: peliProv.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageview(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _crearActoresPageview(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        itemCount: actores.length,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        pageSnapping: false,
        itemBuilder: (BuildContext context, int i) => _actorTarjeta(actores[i]),
      ),
    );
  }

  _actorTarjeta(Actor actor) {
    return Container(
        child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(actor.getFoto()),
              height: 150.0,
              fit: BoxFit.cover),
        ),
        Text(
          actor.name,
          overflow: TextOverflow.ellipsis,
        )
      ],
    ));
  }
}
