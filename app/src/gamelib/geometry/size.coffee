
class Size
  constructor: (@_width=0, @_height=0) ->

  width: (@_width) ->
    return @_width

  height: (@_height) ->
    return @_height

  copy: () ->
    return new Size(@_width, @_height)