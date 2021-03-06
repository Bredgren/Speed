
#_require ./geometry/point
#_require ./geometry/rectangle
#_require ./geometry/size

#TODO: trigger update method

class Camera
  _pos: new Point()

  # @property The possible movement types
  MOVE_MODE:
    INSTANT: 1                  # The camera is always at the target
    APPROACH: 2                 # The camera approaches the target
  _modes: 2
  _mode: 1

  # Creates a new camera.
  #
  # @param [Point] target The initial target coordinate (in world space)
  # @param [Size] size The initial size
  # @param [number] move_factor Percent of distance to target to move each
  #                             update
  constructor: (target=new Point(), size=new Size(), move_factor=1/10) ->
    @_target = target
    @_size = size
    @_move_factor = move_factor

  # Get/set the move factor.
  #
  # @param [number=] move_factor The new move factor
  # @return [number] The current move factor
  moveFactor: (move_factor) ->
    @_move_factor = move_factor if move_factor
    return @_move_factor

  # Get/set the size of the camera.
  #
  # @param [Size=] size The new size
  # @return [Size] The current size
  size: (size) ->
    @_size = size.copy() if size
    return @_size.copy()

  # Get/set the target position.
  #
  # @param [Point=] target The new target coordinate
  # @return [Point] The current target position
  target: (target) ->
    @_target = target.copy() if target
    return @_target.copy()

  # Gets the camera's current position. If mode is INSTANT then this returns
  # a Point with the same coordinates as the target method.
  #
  # @return [Point] The current camera position
  pos: () ->
    return @_pos.copy()

  # Get/set the movement mode of the camera. Note that the parameter/return
  # values should/will be from MOVE_MODE.
  #
  # @param [number=] mode The desired mode
  # @return [number] The current move mode
  mode: (mode) ->
    if mode
      if mode > @_modes
        mode = @_modes
      @_mode = mode
    return @_mode

  # Converts the given set of world coordinates to it's location on the
  # screen.
  #
  # @param [Point] world_point Coordinates in world space
  # @return [Point] The given coordinates in screen space
  worldToScreenPoint: (world_point) ->
    screen_point = world_point.minus(@_pos)
    return screen_point

  # Converts the given set of screen coordinates to it's location in the
  # world.
  #
  # @param [Point] screen_point Coordinates in screen space
  # @return [Point] The given coordinates in world space
  screenToWorldPoint: (screen_point) ->
    world_point = screen_point.plus(@_pos)
    return world_point

  # Converts the given rect specified in world space to screen space.
  #
  # @param [Rectangle] world_rect Rect in world space
  # @return [Rectangle] New Rect in screen space
  worldToScreenRect: (world_rect) ->
    world_pos = world_rect.topleft()
    screen_pos = worldToScreenPoint(world_pos)
    screen_rect = new Rectangle(screen_pos, world_rect.size())
    return screen_rect

  # Converts the given rect specified in screen space to world space.
  #
  # @param [Rectangle] screen_rect Rect in screen space
  # @return [Rectangle] New Rect in world space
  screenToWorldRect: (screen_rect) ->
    screen_pos = screen_rect.topleft()
    world_pos = screenToWorldPoint(screen_pos)
    world_rect = new Rectangle(world_pos, screen_rect.size())
    return world_rect

  # Takes screen coordinates and returns true if it is a point within view
  # of the camera
  #
  # @param [Point] point Some screen coordinates
  # @param [boolean] world_space If true then the point's coordinates will
  #                              be treated as world coordinates, otherwise
  #                              they will be treated as screen coordinates.
  # @return [boolean] true if the point is within view, false otherwise
  pointOnScreen: (point, world_space=false) ->
    if world_space
      point = @worldToScreenPoint(point)

    return 0 <= point.x() < @_size.width() and
           0 <= point.y() < @_size.height()

  # Tests if any part of a rectangle is visible on the screen.
  rectOnScreen: (rect, world_space=false) ->
    return pointOnScreen(rect.topleft(), world_space) or
           pointOnScreen(rect.topright(), world_space) or
           pointOnScreen(rect.bottomright(), world_space) or
           pointOnScreen(rect.bottomleft(), world_space)

  # Updates the camera's position
  _update: () ->
    if @_mode is @MOVE_MODE.INSTANT
      @_pos = @_target.copy()
    else if @_mode is @MOVE_MODE.APPROACH
      dir = @_target.minus(@_pos)
      @_pos = @_pos.plus(dir.times(@_move_factor))

camera = new Camera()
