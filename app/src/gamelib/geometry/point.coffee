
#_require ./util

# A point in 2d space
class Point
  constructor: (@_x=0, @_y=0) ->

  x: () ->
    return @_x

  y: () ->
    return @_y

  plus: (other) ->
    return new Point(@_x + other.x, @_y + other.y)

  minus: (other) ->
    return new Point(@_x - other.x, @_y - other.y)

  times: (value) ->
    return new Point(@_x * value, @_y * value)

  scaled: (scale) ->
    return new Point(@_x * scale.x, @_y * scale.y)

  rounded: () ->
    return new Point(round(@_x), round(@_y))

  copy: () ->
    return new Point(@_x, @_y)

  toString: () ->
    return "(#{@_x}, #{@_y})"