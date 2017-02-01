bcrypt = require('bcryptjs')
whenjs = require('when')
express = require('express')
uuid = require('uuid4')

app = express()
# config = require('./config.js')
# config file should contain all tokens and other private info

#used in local-signup strategy
exports.localReg = (app) ->
  (userName, password) ->
    db = app.locals.db
    # TODO: Verify that Passport accepts promises.
    return whenjs.promise (resolve, reject, notify) ->
      db.get 'userName_' + userName, (err, result) ->
        # userName exists
        console.log ":helper-reg: ", err, user
        if result
          console.log 'User Name ALREADY EXISTS:', result.userName
          resolve false
        else
          hash = bcrypt.hashSync(password, 8)
          user = 
            'userName': userName
            'password': hash
            'uuid': uuid()
            'avatar': 'http://placekitten/200/300'
          
          console.log 'CREATING USER:', userName
          # TODO: Add replacer to json.Stringify / but change LevelDB options 
          # TODO: Include UUID in key
          db.put 'userName_' + userName, JSON.stringify(user), () ->
            resolve user
            
# check if user exists
# if user exists check if passwords match (use bcrypt.compareSync(password, hash) 
#   true where 'hash' is password in DB)
# if password matches take into website
# if user doesn't exist or password doesn't match tell them it failed
exports.localAuth = (app) ->
  return (userName, password) ->
    return whenjs.promise (resolve, reject, notify) ->
      db = app.locals.db
      db.get 'userName_' + userName, (err, result) -> 
        unless result
          console.log 'userName NOT FOUND:', userName
          resolve false
        else
          # TODO: CHANGE if we change storage types
          result = JSON.parse(result)
          hash = result.password
          console.log 'FOUND USER: ' + result.userName
          if bcrypt.compareSync(password, hash)
            resolve result
          else
            console.log 'AUTHENTICATION FAILED'
            resolve false
    
