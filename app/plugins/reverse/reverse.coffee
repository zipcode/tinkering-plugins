window.register "reverse", (target) ->
  field = this.querySelector("div.field")
  target.listen (value) ->
    return if value == undefined
    field.textContent = value.split("").reverse().join("")
