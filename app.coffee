# Imports for security, loginStyles, and Strategies.
express = require('express')
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
session = require('express-session')
methodOverride = require('method-override')
bodyParser = require('body-parser')
exphbs = require('express-handlebars')
uuid = require('uuid4')
helmet = require('helmet')
level = require('level')
passport = require('passport')
LocalStrategy = require('passport-local')
TwitterStrategy = require('passport-twitter')
GoogleStrategy = require('passport-google')
FacebookStrategy = require('passport-facebook')

# TODO: config file contains all tokens and other private info
# config = require('./config')

# helper file contains our helper functions for our Passport and database work
funct = require('./helper')
index = require('./routes/index')
users = require('./routes/users')
# loginRoutes = require('./routes/loginroute')

app = express()

# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'pug'

# uncomment after placing your favicon in /public
#app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use logger('combined')
app.use(methodOverride('X-HTTP-Method-Override'))
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)

# This should be changed per application.
expiryDate = new Date(Date.now() + 60 * 60 * 1000)
app.use cookieParser('CHANGEMECHANGEME!!')
app.use session
  secret: 'CHANGEMECHANGEME!!'
  resave: true
  saveUninitialized: true
  cookie:
    # TODO: Renable when SSL cert is in use 
    #secure: true 
    httpOnly: true
    domain: 'changeme.com',
    path: '/',
    # TODO: this should accept a function
    expires: expiryDate

  genid: (req) ->
    return uuid(); # use UUIDs for session IDs 

app.use(passport.initialize());
app.use(passport.session());

# Helmet is a suite of middleware that kills most XSS attacks.
app.use(helmet())

# Set out persistence
app.locals.db = level './data',
  keyEncoding   : 'binary'
  valueEncoding : 'json'

app.set('db', app.locals.db)

#           ===============PASSPORT=================
# Use the LocalStrategy within Passport to login/"signin" users.
passport.use 'local-signin', new LocalStrategy({ passReqToCallback: true }, (req, username, password, done) ->
  (funct.localAuth(app))(username, password)
  # We return a promise from the helper function. 
  # Variations should use promises. 
  .then (user) ->
    if user
      console.log 'LOGGED IN AS: ' + user.userName
      req.session.success = 'You are successfully logged in ' + user.userName + '!'
      return done(null, user)
    if !user
      console.log 'COULD NOT LOG IN'
      req.session.error = 'Could not log user in. Please try again.'
      #inform user could not log them in
      return done(null, user)
  # TODO: This section should be addressed.
  # .fail (err) ->
  #   console.log err.body
  #   return done(null, null)
)

# Use the LocalStrategy within Passport to register/"signup" users.
passport.use 'local-signup', new LocalStrategy({ passReqToCallback: true }, (req, username, password, done) ->
  # We return a promise from the helper function. 
  # Variations should use promises. 
  (funct.localReg(app))(username, password)
  .then (user) ->
    if user
      console.log 'REGISTERED: ' + user.userName
      req.session.success = 'You are successfully registered and logged in ' + user.userName + '!'
      done null, user
    if !user
      console.log 'COULD NOT REGISTER'
      req.session.error = 'That username is already in use, please try a different one.'
      #inform user could not log them in
      done null, user
    return this
  .catch (err) ->
    console.log err.body
    done null, username
    return
  return
)

passport.serializeUser (user, done) ->
  console.log 'serializing ' + user.userName
  done null, user
  return

passport.deserializeUser (obj, done) ->
  console.log 'deserializing ' + obj
  done null, obj
  return
  
# Place this in our secure express routes to validate
ensureAuthenticated = (req, res, next) ->
  if req.isAuthenticated()
    return next()
  req.session.error = 'Please sign in!'
  req.session.origRoute = ''
  # console.log req 
  res.redirect '/signin'
  return

# Session-persisted message middleware - Setting messages in our chain.
app.use (req, res, next) ->
  err = req.session.error
  msg = req.session.notice
  success = req.session.success

  delete req.session.error
  delete req.session.success
  delete req.session.notice

  res.locals.error = err if err 
  res.locals.notice = msg if msg 
  res.locals.success = success if (success) 

  next()

app.use express.static(path.join(__dirname, 'public'))


app.use '/', index
app.use '/users', ensureAuthenticated
app.use '/users', users

#TODO: Rip Out
app.get '/traverse', (req, res) ->
  res.render 'layouts/origFrame'
  return
#displays our signup page
app.get '/signin', (req, res) ->
  res.render 'signin'
  return
#sends the request through our local signup strategy, and if successful takes user to homepage, otherwise returns then to signin page
app.post '/reg-signup', passport.authenticate('local-signup',
  successRedirect: '/'
  failureRedirect: '/signin')
#sends the request through our local login/signin strategy, and if successful takes user to homepage, otherwise returns then to signin page
app.post '/login', passport.authenticate('local-signin',
  successRedirect: '/'
  failureRedirect: '/signin')
#logs user out of site, deleting them from the session, and returns to homepage
app.get '/logout', (req, res) ->
  name = req.user.username
  console.log 'LOGGING OUT ' + req.user.username
  req.logout()
  res.redirect '/'
  req.session.notice = 'You have successfully been logged out ' + name + '!'
  return


# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err
  return

# error handler
app.use (err, req, res, next) ->
  # set locals, only providing error in development
  res.locals.message = err.message
  res.locals.error = if req.app.get('env') == 'development' then err else {}
  # render the error page
  res.status err.status or 500
  res.render 'error'
  return

module.exports = app
