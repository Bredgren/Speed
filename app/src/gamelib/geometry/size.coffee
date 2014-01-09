
class Size
  # @param [number] width The width
  # @param [number] height The height
  constructor: (width=0, height=0) ->
    @_width = width
    @_height = height

  # Get/set the width.
  #
  # @param [number=] width The new width
  # @return [number] The current width
  width: (width) ->
    @_width = width if width
    return @_width

  # Get/set the height.
  #
  # @param [number=] height The new height
  # @return [number] The current height
  height: (height) ->
    @_height = height if height
    return @_height

  # Returns a copy of this Size.
  #
  # @return [Size] A new Size object with the same values as this one
  copy: () ->
    return new Size(@_width, @_height)