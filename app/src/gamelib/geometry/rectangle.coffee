
#_require ./point
#_require ./size

# It's behavior is undefined if you specify a top left that is actually the
# bottom right, and vice versa.
class Rectangle
  # Creates a new rect at the given position with the given size
  #
  # @param [Point] topleft The position of the top left corner
  # @prarm [Size] size The size of the rectangle
  constructor: (topleft, size) ->
    @_topleft = topleft.copy()
    @_bottomright = new Point(@_topleft.x() + size.width(),
                              @_topleft.y() + size.height())

  # Get/set the top left corner of the rectangle.
  #
  # @param [Point=] topleft The position of the top left corner
  # @return [Point] the top left corner
  topleft: (topleft) ->
    @_topleft = topleft.copy() if topleft
    return @_topleft.copy()

  # Get/set the top right corner of the rectangle.
  #
  # @param [Point=] topright The position of the top right corner
  # @return [Point] the top right corner
  topright: (topright) ->
    if topright
      @_topleft = new Point(@_topleft.x(), topright.y())
      @_bottomright = new Point(topright.x(), @_bottomright.x())
    else
      topright = new Point(@_bottomright.x(), @_topleft.y())

    return topright

  # Get/set the bottom right corner of the rectangle.
  #
  # @param [Point=] bottomright The position of the bottom right corner
  # @return [Point] the bottom right corner
  bottomright: (bottomright) ->
    @_bottomright = bottomright.copy() if bottomright
    return @_bottomright.copy()

  # Get/set the bottom left corner of the rectangle.
  #
  # @param [Point=] bottomleft The position of the bottom left corner
  # @return [Point] the bottom left corner
  bottomleft: (bottomleft) ->
    if bottomleft
      @_topleft = new Point(bottomleft.x(), @_topleft.y())
      @_bottomright = new Point(@_bottomright.x(), bottomleft.y())
    else
      bottomleft = new Point(@_bottomright.x(), @_topleft.y())

    return bottomleft

  # Get/set the center of the rectangle.
  #
  # @param [Point=] center The position of the center
  # @return [Point] the center
  center: (center) ->
    size = @size()
    half_size = new Point(size.width() / 2, size.height() / 2)

    if center
      @_topleft = center.minus(half_size)
      @_bottomright = center.plus(half_size)
    else
      center = @_topleft.plus(half_size)

    return center

  # Get/set the size of the rectangle. This preserves the top left corner.
  #
  # @param [Size=] size The new size
  # @return [Size] the size
  size: (size) ->
    return new Size(@_bottomright.x() - @_topleft.x(),
                    @_bottomright.y() - @_topleft.y())

  # Tests if the given point is inside the rectangle.
  #
  # @param [Point] point The point to text
  # @return [boolean] true if the point is within the rectangle
  pointInside: (point) ->
    return @_topleft.x() < point.x() < @_bottomright.x() and
           @_topleft.y() < point.y() < @_bottomright.y()

  # Returns a copy of this Rectangle.
  #
  # @return [Rectangle] A new Rect identical to this one
  copy: () ->
    return new Rectangle(@_topleft, @size())
