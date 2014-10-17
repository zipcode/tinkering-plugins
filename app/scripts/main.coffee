require.config
  paths:
    'underscore': '/bower_components/underscore/underscore-min'

require ["underscore"], (_) ->
  input = document.getElementById("text")
  item =
    listeners: []
    listen: (f) -> @listeners.push (event) ->
      f(input.value)
  input.addEventListener "input", (event) ->
    item.listeners.map (listener) -> listener(event)

  registry =
    callbacks: {}
    setTarget: (name, elem) ->
      @callbacks[name] = elem
    register: (name, f) ->
      f.call(@callbacks[name], item)

  window.register = registry.register.bind(registry)

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

  plugins = ["rot13", "reverse"]
  embed_location = document.getElementById("plugins")

  _.map plugins, (plugin) ->
    console.log plugin
    base = "/plugins/" + plugin + "/"
    css = base + plugin + ".css"
    script = base + plugin + ".js"
    div = document.createElement("div")
    div.setAttribute('class', 'plugin-' + plugin)
    get(base + plugin + ".html", { responseType: "document"}).then (doc) ->
      _.map doc.body.childNodes, (node) ->
        div.appendChild(node) if node
      embed_location.appendChild(div)
      script_elem = document.createElement("script")
      script_elem.setAttribute("src", script)
      document.head.appendChild(script_elem)
      css_elem = document.createElement("link")
      css_elem.setAttribute("href", css)
      css_elem.setAttribute("rel", "stylesheet")
      document.head.appendChild(css_elem)
      registry.setTarget plugin, div
