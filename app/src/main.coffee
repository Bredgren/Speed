
#_require ./config
#_require ./scene
#_require ./gamelib/camera
#_require ./gamelib/assets/assetmanager

# TODO: keep track of loop time (see html5 performance)

class Main
  FPS: 1000 / 60

  constructor: () ->
    @bgd = new Background()

    @fgd_canvas = $('#fgd-canvas')[0]
    @fgd_ctx = @fgd_canvas.getContext('2d')
    @sprite_canvas = $('#sprite-canvas')[0]
    @sprite_ctx = @sprite_canvas.getContext('2d')
    @hud_canvas = $('#hud-canvas')[0]
    @hud_ctx = @hud_canvas.getContext('2d')

    @_setupCanvas()

    assets = new AssetManager()

  # Preloads assets that need to be preloaded
  loadAssets: () ->
    # img = config.img
    # assets.image(img.cityBgd1)
    # assets.image(img.street2Lane)
    # assets.image(img.building1)
    # assets.image(img.guy)

  onUpdate: () ->
    console.log('update')

  onDraw: () ->
    img = config.img

    @bgd.draw()

    @_clearHud()
    @hud_ctx.font = "20px"
    @hud_ctx.fillStyle = "white"
    @hud_ctx.fillText("x: #{camera.pos().x()}", 0, 10)
    @hud_ctx.fillText("y: #{camera.pos().y()}", 0, 20)

    # street = assets.image(img.street2Lane)
    # street_y = @fgd_canvas.height - street.height
    # @fgd_ctx.drawImage(street, 0, street_y)

    # building = assets.image(img.building1)
    # building_y = street_y - building.height
    # @fgd_ctx.drawImage(building, 30, building_y)
    # @fgd_ctx.drawImage(building, 410, building_y)

    # guy = assets.image(img.guy)
    # @sprite_ctx.drawImage(guy, 200, street_y + 30)

  run: () ->
    @loadAssets()
    setInterval(@onUpdate, @FPS)

    @animFrame = window.requestAnimationFrame       or
                 window.webkitRequestAnimationFrame or
                 window.mozRequestAnimationFrame    or
                 window.oRequestAnimationFrame      or
                 window.msRequestAnimationFrame     or
                 null

    if @animFrame isnt null
      recursiveAnim = =>
        @onDraw()
        @animFrame(recursiveAnim)

      @animFrame(recursiveAnim)
    else
      setInterval(@onDraw, @FPS)

  _setupCanvas: () ->
    @fgd_canvas.width = config.width
    @fgd_canvas.height = config.height

    @sprite_canvas.width = config.width
    @sprite_canvas.height = config.height

    @hud_canvas.width = config.width
    @hud_canvas.height = config.height

  _clearFgd: () ->
    @fgd_ctx.clearRect(0, 0, @fgd_canvas.width, @fgd_canvas.height)

  _clearSprites: () ->
    @sprite_ctx.clearRect(0, 0, @sprite_canvas.width, @sprite_canvas.height)

  _clearHud: () ->
    @hud_ctx.clearRect(0, 0, @hud_canvas.width, @hud_canvas.height)

$ ->
  main = new Main()
  main.run()
