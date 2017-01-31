This is a stock framework to use as a base for future projects using Express, Coffeescript, Pug, and Bootstrap.  It assumes familiarity with Node.js, and was written agains the node.js v7.4.0. The code was created and tested on Linux and may need some tailoring for Windows installs.

This is fairly bare boned, but slightly more involved than the generated express example.  By default it uses LevelUp, and LevelDB to store data.  This is stored in the app local directory, and will not persist if used in a docker image.

The key goal is to create a simple site quickly and easily.  The site doesn't use any navigation frameworks, such as Angular.js or Ember, but could be easily extended to use them.

To use:





TODO:
* Add alternate data strategies
* Include a build framework such as Grunt
* Include a LESS build for customizing.
* Add tests, especially around the authentication framework.
* Clean up workflows.

