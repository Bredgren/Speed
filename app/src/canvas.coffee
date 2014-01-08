
#_require ./gamelib/geometry/size

# A wrapper for a canvas that remembers where it has drawn and clears only
# those places.
class DirtyCanvas
  constructor: (@canvas, @size) ->
    @ctx = @canvas.getContext('2d')
    @_dirty_rects = []

  drawImage: (img, pos) ->
    #TODO: draw image and save rect

  drawText: (text, pos) ->
    #TODO: draw text and save rect

  clear: () ->
    #TODO: clear all dirty rects

  # Erases the entire canvas. Useful if you draw to the canavs by means
  # other that the provided methods.
  forceClearAll: () ->
    @canvas.clearRect(0, 0, @size.width, @size.height)