reverse = (target) ->
  field = this.querySelector("div.field")
  target.listen (value) ->
    return if value == undefined
    field.innerText = value.split("").reverse().join("")
