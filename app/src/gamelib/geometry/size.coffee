
class Size
  # @param [Number] _width The width
  # @param [Number] _height The height
  constructor: (@_width=0, @_height=0) ->

  # Gets/sets the width.
  #
  # @param [Number] _width The new width
  # @return [Number] The current width
  width: (@_width=@_width) ->
    return @_width

  # Gets/sets the height.
  #
  # @param [Number] _height The new height
  # @return [Number] The current height
  height: (@_height=@_height) ->
    return @_height

  # Returns a copy of this Size.
  #
  # @return [Size] A new Size object with the same values as this one
  copy: () ->
    return new Size(@_width, @_height)