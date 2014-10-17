window.register "rot13", (target) ->
  field = this.querySelector("div.field")
  target.listen (value) ->
    return if value == undefined
    field.textContent = value.replace /[a-zA-Z]/g, (c) ->
      top = (c <= "Z") && 90 || 122
      cc = c.charCodeAt(0)+13
      res = (top > cc) && cc || cc - 26
      String.fromCharCode res
