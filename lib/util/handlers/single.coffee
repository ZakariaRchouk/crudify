extendQueryFromParams = require '../extendQueryFromParams'
executeAndSendQuery = require '../executeAndSendQuery'

module.exports = (route) ->
  [Model] = route.meta.models
  out = {}
    
  out.get = (req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    query = Model.findById singleId
    query = extendQueryFromParams query, req.query
    executeAndSendQuery query, res

  # TODO: actually make a put
  out.put = out.patch = (req, res, next) ->
    delete req.body._id
    singleId = req.params[route.meta.primaryKey]
    query = Model.findByIdAndUpdate singleId, $set: req.body
    query = extendQueryFromParams query, req.query
    executeAndSendQuery query, res

  out.delete = (req, res, next) ->
    singleId = req.params[route.meta.primaryKey]
    query = Model.findByIdAndRemove singleId
    query = extendQueryFromParams query, req.query
    executeAndSendQuery query, res

  delete out[k] for k,v of out when !(k in route.methods) # adhere to given limits
  return out