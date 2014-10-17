require.config
  paths:
    'underscore': '/bower_components/underscore/underscore-min'

require ["underscore"], (_) ->
  # UGH I CANNOT BELIEVE ES6 DOESN'T SUPPLY THIS JEEEEZE
  Promise.when = (promises...) ->
    if promises.length == 0
      return Promise.resolve []
    promises[0].then (result) ->
      Promise.when.apply(this, promises.slice(1)).then (results) ->
        results.unshift(result)
        results

  window.get = get = (url, options) -> new Promise (resolve, reject) ->
    options = options || {}
    r = new XMLHttpRequest()
    r.responseType = options.responseType if options.responseType
    r.open('get', url)
    r.addEventListener "readystatechange", ->
      return if r.readyState != 4
      if (r.status == 200)
        resolve(r.response)
      else
        reject(r.response)
    r.send()

  input = document.getElementById("text")
  item =
    listen: (f) -> input.addEventListener "input", (event) ->
      f(input.value)

  plugins = ["reverse"]
  embed_location = document.getElementById("plugins")

  _.map plugins, (plugin) ->
    console.log plugin
    base = "/plugins/" + plugin + "/"
    doc = get(base + plugin + ".html", { responseType: "document"})
    css = get(base + plugin + ".css")
    script = get(base + plugin + ".js")
    div = document.createElement("div")
    Promise.when(doc, css, script).then ([doc, css, script]) ->
      _.map doc.body.childNodes, (node) ->
        div.appendChild(node)
      embed_location.appendChild(div)