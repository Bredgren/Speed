
#_require ./gamelib/camera
#_require ./gamelib/assets/assetmanager
#_require ./gamelib/geometry/point

class Background
  constructor: () ->
    @ready = false

    onBgdLoad = =>
      # pos needs to be in meters
      y = (@canvas.height - @image.height) / config.pxpm
      @pos = new Point(0, y)
      @wrap = new Point(@image.width, 0)
      @ready = true

    @image = assets.image(config.img.cityBgd1, onBgdLoad)

    @canvas = $('#bgd-canvas')[0]
    @canvas.width = config.width
    @canvas.height = config.height

    @ctx = @canvas.getContext('2d')

    @parallax = new Point(0.1, 1.0)

  draw: () ->
    return if not @ready

    camera.drawImage(@image, @ctx, @pos, @parallax, @wrap)
    pos2 = @pos.plus(new Point(@canvas.width, 0))
    camera.drawImage(@image, @ctx, pos2, @parallax, @wrap)

  clear: () ->
    @ctx.clearRect(0, 0, @canvas.width, @canvas.height)

class Foreground
  constructor: () ->
    # @ready = false

    # img_count = 0
    # num_img = 2
    # onImgLoad = =>
    #   img_count++
    #   if img_count is num_img
    #     # pos needs to be in meters
    #     y = (@canvas.height - @image.height) / config.pxpm
    #     @pos = new Point(0, y)
    #     @wrap = new Point(@image.width, 0)
    #     @ready = true

    # @image = assets.image(config.img.street2Lane, onImgLoad)
    # @image = assets.image(config.img.building1, onImgLoad)

    # @canvas = $('#bgd-canvas')[0]
    # @canvas.width = config.width
    # @canvas.height = config.height

    # @ctx = @canvas.getContext('2d')

class Map
  constructor: () ->
    @buildings = [10, 100, 300, 500, 700, 1000]