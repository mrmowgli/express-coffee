.
├── app.coffee     # The main application file
├── bin
│   └── www        # The self executable server file
├── bower_components  # Bower is a client lib package manager
│   ├── bootstrap     # Bootstrap is a client side presentation package
│   │   └── dist
│   │       └── config.json  # Hints about packaging Bootstrap
│   ├── bootstrap-less # A less-version of Bootstrap used for customization
│   ├── chai       # A test package, used for assertions 
│   ├── components-bootstrap # Bootstrap javascript components
│   ├── jquery     # JQuery - a client side lib for working with the DOM
│   ├── mocha      # A framework for testing
│   └── modernizr  # A shim package to help libs work between browsers
├── bower.json     # Our client-side lib configuration
├── CHECKLIST.md   # Conains a list of things you need to change for your own site.
├── client_src     # Contains client only source files
│   ├── scripts    # Contains custom client side Javascript / Coffeescript
│   ├── views      # Contains client only Pug files for "static" pages
│   └── styles     # Contains less/css files that will be sent to the client
├── config.coffee.example  # Contains an example config file for the app.
├── Gruntfile.coffee       # Contains the Grunt Build script
├── helper.coffee  # Currently the only login helper
├── LICENSE.txt    # MIT license, which this app is released under.
├── package.json   # Contains Node dependencies and some scripts
├── public         # Anything in this folder is served up directly
│   ├── config.json
│   ├── crimes.csv
│   ├── css        # Target folder for grunt css/less and any libs.
│   │   ├── application-startup.css # Unused I believe
│   │   ├── bootstrap.css           # Holds the unminified version of bootstrap
│   │   ├── bootstrap.css.map       # Holds a compile map to the original less
│   │   ├── bootstrap.min.css       # Minified version
│   │   ├── bootstrap.min.css.map   # Minified version with map to less.
│   │   ├── bootstrap-theme.css     # This is the "Theme" css unminified
│   │   ├── bootstrap-theme.css.map # and mapped
│   │   ├── bootstrap-theme.min.css # Minified
│   │   ├── bootstrap-theme.min.css.map  # and mapped.
│   │   ├── palleton.css            # Actual theme colors, TODO: overriding
│   │   ├── style.css               # Actual app overrides.
│   │   └── toolkit-startup.css     # Unused.
│   ├── fonts      # This folder contains the webfonts.  CDN fonts are also used.
│   │   ├── glyphicons-halflings-regular.eot 
│   │   ├── glyphicons-halflings-regular.svg
│   │   ├── glyphicons-halflings-regular.ttf
│   │   ├── glyphicons-halflings-regular.woff
│   │   └── glyphicons-halflings-regular.woff2
│   ├── images     # Serves up any images.  All images taken by Andre Lewis, MIT license.
│   │   ├── bluelamp.JPG   
│   │   ├── bobo.JPG
│   │   ├── chaired.JPG
│   │   ├── chaired_square.JPG
│   │   ├── connected.JPG
│   │   ├── connected_square.JPG
│   │   ├── cushions.JPG
│   │   ├── dofwood.JPG
│   └── js        # Javascript files built by Grunt and client libs go here.
│       ├── application.js
│       ├── bootstrap.js
│       ├── bootstrap.min.js
│       ├── core.js
│       ├── jquery.min.js
│       ├── jquery.slim.js
│       └── tether.min.js
├── README.md     # The main README file.
├── routes        # Route handlers used by the application
│   ├── index.js  # The main handler for the landing page
│   └── users.js  # Default User path.
├── test          # Folder for tests, unit and end to end
│   └── spec      
│       ├── login-tests.coffee
│       └── test.coffee
└── views         # Contains our view templates.
    ├── error.pug # Shows any errors we may run into to the client.
    ├── index.pug # Our main index for the site.
    ├── jumbotron.pug  # Not used at the moment
    ├── layouts   # Holds single page layouts to be included
    │   ├── authentication.pug  # Contains our main authentication page.
    │   ├── footer.pug          # Our current footer page, with copyright
    │   ├── layout_bordered.pug # Our framed app layout, which includes borders
    │   ├── layout_ingang.pug   # Our main landing page layout.
    │   ├── navLogin.pug        # The login section of the main navbar
    │   └── simpleNav.pug       # The main navigation file.
    ├── mainpage.pug            # Main landing page.
    └── signin.pug              # Not currently used.
