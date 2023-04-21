README
=====
Instrucciones para ejecutar el proyecto

Clonar el repositorio:

`git clone git@github.com:juanfgs/blockbuster.git`

importar el archivo .env

`source .env`

__EL Archivo ENV es provisto para simplificar el proceso,
ya que contiene la llave de encryptación del mismo, en
circunstancias normales este archivo 
no se encontraría en el proyecto, se puede generar
una nueva llave ejecutando SecureRandom.hex(32) en la 
consola de Rails__

migrar la base de datos

`rails db:migrate`

Ejecutar las seeds para crear los usuarios 

`rails db:seed`

Ejecutar el servidor 

`rails server`

Ejecutar tests
`rspec --format documentation`

Notas adicionales
===========

* Se implementaron filtros de busqueda para nombre, descripcion y año. 
* Se implemento un sistema de autenticación con Bearer Token 
* Se implementó una mecánica que se intuye de las instrucciones provistas (no obstante no estaban explicitadas), y
 es que cuando se alquila una película disminuye la disponibilidad, al retornarla aumenta. 
No se permite alquilar peliculas cuya disponibilidad sea menor a 1


API 
=== 
Se provee una colección [de postman para simplificar el testeo](https://github.com/juanfgs/blockbuster/blob/main/resources/Blockbuster%20API.postman_collection.json).

La API implementa los siguientes endpoints
Autenticacion
------------
GET /api-keys

Obtiene las api keys del usuario actual

POST /api-keys

Genera un Bearer Token para un email:contraseña (debe ser usado en las requests subsiguientes)

Peliculas
--------


GET /movies

Params

* movie[release_year]
* movie[name]
* movie[description]

Lista y filtra las peliculas, los filtros
 se pueden utilizar pasando parametros de la forma
`GET /movies/?movie[release_year]=1999` tambien puede filtrarse por nombre y descripción

Los siguientes endpoints de este recurso requieren autenticación con usuario de rol :admin
------------

POST /movies
Params

* movie[available_copies]
* movie[daily_rental_price]
* movie[description]
* movie[genre]
* movie[name]
* movie[release_year]
* movie[image]

Permite insertar una nueva pelicula 

GET /movies/{id}

Permite ver la actividad de una pelicula en particular (datos de pelicula, reservas *reservals* y retornos *returnals*)

PATCH /movies/{id}

Permite modificar los datos de una pelicula

DELETE /movies/{id}

Borra una pelicula del catalogo

Reservas
-----------

POST /rentals

params:

* movie_id

Permite alquilar una pelicula basado en movie_id

Devolución/Retornos
--------------------

POST /returnals

params

* rental_id

Permite devolver una pelicula


