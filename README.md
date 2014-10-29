# Sistemas y Tecnologías Web: Estadísticas de Visitas al Acortador de URLs

**Autores: Aarón Socas Gaspar && Aarón José Vera Cerdeña**

##Descripción

Ejemplo de acortador de URLs que admite elegidas por el usuario. Además se incluyen estadísitcas de las mismas.


##Aplicación

Podemos acceder a la aplicación subida a heroku desde [aqui](http://sytw5.herokuapp.com/).


##Tests

![Build Status](https://travis-ci.org/alu0100207385/SYTW_p5/builds/39286192)

Podemos probar la aplicación ejecutando los tests. Podemos hacerlo en nuestra maquina local mediante la opción: 
`rake local_tests` o bien accediendo a los resultados en [travis](https://travis-ci.org/alu0100207385/SYTW_p5/builds/39286192).

##Instalación

1. Instalaremos las gemas necesarias: `bundle install`
2. Podemos usar el archivo `config.yml` que se proporciona o configurar el nuestro propio.


##Ejecución

Con el comando `$ rake -T` podemos ver las opciones posibles.
Las opciones posibles son:

```
1. rake heroku       # Open app in Heroku
2. rake local_tests  # Run tests in local machine
3. rake rackup       # Run the server via rackup
4. rake repo         # Open repository
5. rake sinatra      # Run the server via Sinatra
6. rake tests        # Run tests (default)
7. rake update       # Update app in Heroku

```


##Recursos

* [DataMapper](http://datamapper.org/getting-started.html)
* [Haml](http://haml.info/)
* [Sinatra](http://www.sinatrarb.com/)
* [Deploying Rack-based Apps in Heroku](https://devcenter.heroku.com/articles/rack)
* [Intridea Omniauth](https://github.com/intridea/omniauth)
* [Selenium](http://www.seleniumhq.org/)
* [Travis](https://travis-ci.org/)
* [Ejemplo practico Selenium](http://aspyct.org/blog/2012/09/09/functional-web-testing-with-selenium-and-ruby/)
* [Google EN](http://www.google.com/webhp?hl=en)

-------------------------
*Aarón Socas Gaspar && Aarón José Vera Cerdeña- Sistemas y Tecnologías Web (Curso 2014-2015)*
