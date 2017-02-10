# WIP - Base(ics) basic full stack template
Node/Express/Coffeescript/Pug

This is a stock framework to use as a base for future projects using Express, Coffeescript, Pug, and Bootstrap.  It assumes familiarity with Node.js, and was written agains the node.js v7.4.0. The code was created and tested on Linux and may need some tailoring for Windows installs.

This is fairly bare boned, but slightly more involved than the generated express example.  By default it uses LevelUp, and LevelDB to store data.  This is stored in the app local directory, and will not persist if used in a docker image.

The key goal is to create a simple site quickly and easily.  The site doesn't use any navigation frameworks, such as Bootstrap, Angular.js or Ember, but could be easily extended to use them.

To install:

```bash
$ git clone https://github.com/mrmowlgli/app-baseics
$ npm install
```


To use (server side):

```bash
$ ./bin/www
```
Currently the app will work as is, however soon we will be making changes to the credential sections. You can ignore the following section for now.

config.coffee
```coffee-script
appSettings: 
  siteName: 'Demo Site'
  siteUrl: 'http://demosite.com'
  siteSugar: '04de0a5d-1476-401c-ab5d-349543097920'
  dataUrl: 'user:password@http://mongohq.com'
  dataSocket: null
  dataDir: './data'
  cookieTimeout: 2 * 60 * 60 * 1000 # Milliseconds - two hours

```

Then follow the checklist items in the CHECKLIST.md file to customize your application.


To make changes to client side libs (Client JS):

```bash
$ npm -g install grunt
$ npm install grunt-cli
$ npm install bower
$ grunt server
```


TODO:
* Add alternate data strategies
* extract credential info into config.coffee
* Include a build framework such as Grunt
* Include a LESS build for customizing.
* Add form validation for logins.
* Add alternate 'Dashboard' template.
* Add tests, especially around the authentication framework.
* Clean up workflows.


