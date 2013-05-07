extendQueryFromParams = require '../extendQueryFromParams'
executeAndSendQuery = require '../executeAndSendQuery'
sendError = require '../sendError'
getAllPaths = require '../getAllPaths'

module.exports = (route) ->
  [Model] = route.meta.models
  out = {}
    
  out.get = (req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query
    executeAndSendQuery query, res

  out.put = (req, res, next) ->
    return sendError res, new Error("Invalid body") unless typeof req.body is 'object'
    delete req.body._id
    delete req.body.__v
    singleId = req.params[route.meta.primaryKey]
    update =
      $unset: {}
      $set: req.body
    update.$unset[k]=1 for k in getAllPaths(Model) when !req.body[k]
    delete update.$unset._id
    delete update.$unset.__v
    query = Model.findByIdAndUpdate singleId, update
    query = extendQueryFromParams query, req.query
    executeAndSendQuery query, res

  out.patch = (req, res, next) ->
    return sendError res, new Error("Invalid body") unless typeof req.body is 'object'
    delete req.body._id
    delete req.body.__v
    singleId = req.params[route.meta.primaryKey]
    update = $set: req.body
    query = Model.findByIdAndUpdate singleId, update
    query = extendQueryFromParams query, req.query
    executeAndSendQuery query, res

  out.delete = (req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    query = Model.findByIdAndRemove singleId
    query = extendQueryFromParams query, req.query
    executeAndSendQuery query, res

  return out