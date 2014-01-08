
class AssetManager
  IMG_FILE: "img/"
  SFX_FILE: "sfx/"

  constructor: () ->
    @_img = {}
    @_sfx = {}

  # Returns image object. Loads the image if it needs to.
  image: (file_name, onload) ->
    img = @_img[file_name]
    if not img
      img = @_load_img(file_name, onload)

    return img

  unloadImage: (file_name) ->
    delete @_img[file_name]

  _load_img: (file_name, onload) =>
    img = new Image()
    img.src = "#{@IMG_FILE}#{file_name}"
    if onload
      img.onload = onload
    @_img[file_name] = img
    return img

assets = new AssetManager()