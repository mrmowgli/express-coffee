# WIP - Base(ics) basic full stack template
Node/Express/Coffeescript/Pug

This is a stock framework to use as a base for future projects using Express, Coffeescript, Pug, and Bootstrap.  It assumes familiarity with Node.js, and was written agains the node.js v7.4.0. The code was created and tested on Linux and may need some tailoring for Windows installs.

This is fairly bare boned, but slightly more involved than the generated express example.  By default it uses LevelUp, and LevelDB to store data.  This is stored in the app local directory, and will not persist if used in a docker image.

The key goal is to create a simple site quickly and easily.  The site doesn't (currently) use any navigation frameworks, such as React, Angular.js or Ember, but could be easily extended to use them.

To install:

```bash
$ git clone https://github.com/mrmowlgli/express-coffee.git
$ npm install
$ npm install -g bower
$ npm install -g grunt-cli
```

To use (server side):

```bash
$ ./bin/www
```
The application is really two separate application flows:

* Server side rendering with Node.js/Express/Pug/LevelDB
* Client side static files built with Grunt from Coffeescript and Less

This is a slightly older workflow, but allows a lot of flexibility in how we handle resources.  Dependencies are pulled down as part of the build rather than installing a million dependencies into your node environment.

Key aspects of this workflow are:

**Client side only** files are compressed and concatted, then put directly into our express public folder.  These resources are then returned on our page accesses.  Static pages are returned directly, other resources are included as needed into our server rendered pages. 
* Source files are in `client_src`, inlcuding full PUG templates, and client side Coffee files.
* Bootstrap resources are modified and included as less.  These overrides should happen in the `client_src` directory as well.
* Bower components are kept in the `bower_components` directory.  These files are added in manually to the `Gruntfile.coffee` file, one for each task that needs to be included.

To make changes to client side libs (Client JS):

```bash
$ npm -g install grunt-cli
$ npm -g install bower
$ bower install
$ bower update
$ grunt server
```

**Server side resources** are managed with the remaining folders.  The keys are the `views` directory, which holds the main server side rendered pug files, and the routes folder.  The `test` folder contains the mocha/chai assertion libraries needed to perform the key tests.

To perform the server side tests:

`npm test`


Currently the app will work as is, however soon we will be making changes to the way we create our JS and CSS files as well as changes to the credential sections. 

You can ignore the following section for now.

config.coffee
```coffee-script
appSettings: 
  siteName: 'Demo Site'
  siteUrl: 'http://demosite.com'
  siteSalt: '04de0a5d-1476-401c-ab5d-349543097920'
  dataUrl: 'user:password@http://mongohq.com'
  dataSocket: null
  dataDir: './data'
  cookieTimeout: 2 * 60 * 60 * 1000 # Milliseconds - two hours

```

Then follow the checklist items in the CHECKLIST.md file to customize your application.

### Other notes
Currently we are actually bundling required JS files, rather than using the CDN's.  This will likely change, but is handy for local dev.  In reality we build our CS/JS and LESS/CSS and then bundle concatted and minified versions to reduce the number of connections our page makes.  You can run grunt for the front end section and push the resulting client side files to a CDN if speed is your thing, but for the most part this is beyond the scope of this readme.

For testing, please ensure that phantomjs is installed:

```bash
$ npm -g install phantomjs
```

TODO:
* Add alternate data strategies
* extract credential info into config.coffee
* Include a build framework such as Grunt
* include bower files
* Include a LESS build for customizing.
* Add form validation for logins.
* Add alternate 'Dashboard' template.
* Add tests, especially around the authentication framework.
* Clean up workflows.
* Add copyright to images.
* Update to Bootstrap 4
* Update Coffeescript to CS2 release.
* Add babel compile step.
* Add Yeoman route builder 


### Current Issues:
* Login needs to be verified but should work..
* Main header doesn't reflect login status (yet).
* Session locals need to be set for templates aka `req.locals.user`
