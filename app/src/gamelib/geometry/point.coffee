
#_require ./util

# A point in 2d space
class Point
  constructor: (@_x=0, @_y=0) ->

  x: () ->
    return @_x

  y: () ->
    return @_y

  plus: (other) ->
    return new Point(@x + other.x, @y + other.y)

  minus: (other) ->
    return new Point(@x - other.x, @y - other.y)

  times: (value) ->
    return new Point(@x * value, @y * value)

  scaled: (scale) ->
    return new Point(@x * scale.x, @y * scale.y)

  rounded: () ->
    return new Point(round(@x), round(@y))

  copy: () ->
    return new Point(@x, @y)

  toString: () ->
    return "(#{@x}, #{@y})"