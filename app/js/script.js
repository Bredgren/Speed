// Generated by CoffeeScript 1.6.2
(function() {
  var AssetManager, Background, Camera, Circle, DirtyCanvas, Foreground, Main, Map, Point, Rect, Size, assets, camera, config, round,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Size = (function() {
    function Size(_width, _height) {
      this._width = _width != null ? _width : 0;
      this._height = _height != null ? _height : 0;
    }

    Size.prototype.width = function(_width) {
      this._width = _width;
      return this._width;
    };

    Size.prototype.height = function(_height) {
      this._height = _height;
      return this._height;
    };

    Size.prototype.copy = function() {
      return new Size(this._width, this._height);
    };

    return Size;

  })();

  DirtyCanvas = (function() {
    function DirtyCanvas(canvas, size) {
      this.canvas = canvas;
      this.size = size;
      this.ctx = this.canvas.getContext('2d');
      this._dirty_rects = [];
    }

    DirtyCanvas.prototype.drawImage = function(img, pos) {};

    DirtyCanvas.prototype.drawText = function(text, pos) {};

    DirtyCanvas.prototype.clear = function() {};

    DirtyCanvas.prototype.forceClearAll = function() {
      return this.canvas.clearRect(0, 0, this.size.width, this.size.height);
    };

    return DirtyCanvas;

  })();

  config = {
    fps: 1000 / 60,
    width: 800,
    height: 600,
    camera_move_factor: 1 / 10,
    img: {
      cityBgd1: "background.png",
      street2Lane: "street.png",
      building1: "building1.png",
      guy: "guy.png"
    }
  };

  round = function(num) {
    return (0.5 + num) | 0;
  };

  Point = (function() {
    function Point(_x, _y) {
      this._x = _x != null ? _x : 0;
      this._y = _y != null ? _y : 0;
    }

    Point.prototype.x = function() {
      return this._x;
    };

    Point.prototype.y = function() {
      return this._y;
    };

    Point.prototype.plus = function(other) {
      return new Point(this.x + other.x, this.y + other.y);
    };

    Point.prototype.minus = function(other) {
      return new Point(this.x - other.x, this.y - other.y);
    };

    Point.prototype.times = function(value) {
      return new Point(this.x * value, this.y * value);
    };

    Point.prototype.scaled = function(scale) {
      return new Point(this.x * scale.x, this.y * scale.y);
    };

    Point.prototype.rounded = function() {
      return new Point(round(this.x), round(this.y));
    };

    Point.prototype.copy = function() {
      return new Point(this.x, this.y);
    };

    Point.prototype.toString = function() {
      return "(" + this.x + ", " + this.y + ")";
    };

    return Point;

  })();

  Rect = (function() {
    function Rect(topleft, size) {
      this._topleft = topleft.copy();
      this._bottomright = new Point(this._topleft.x + size.width, this._topleft.y + size.height);
    }

    Rect.prototype.topleft = function(topleft) {
      if (topleft) {
        this._topleft = topleft.copy();
      }
      return this._topleft.copy();
    };

    Rect.prototype.topright = function(topright) {
      if (topright) {
        this._topleft = new Point(this._topleft.x(), topright.y());
        this._bottomright = new Point(topright.x(), this._bottomright.x());
      } else {
        topright = new Point(this._bottomright.x(), this._topleft.y());
      }
      return topright;
    };

    Rect.prototype.bottomright = function(bottomright) {
      if (bottomright) {
        this._bottomright = bottomright.copy();
      }
      return this._bottomright.copy();
    };

    Rect.prototype.bottomleft = function(bottomleft) {
      if (bottomleft) {
        this._topleft = new Point(bottomleft.x(), this._topleft.y());
        this._bottomright = new Point(this._bottomright.x(), bottomleft.y());
      } else {
        bottomleft = new Point(this._bottomright.x(), this._topleft.y());
      }
      return bottomleft;
    };

    Rect.prototype.center = function(center) {
      var half_size, size;

      size = this.size();
      half_size = new Point(size.width / 2, size.height / 2);
      if (center) {
        this._topleft = center.minus(half_size);
        this._bottomright = center.plus(half_size);
      } else {
        center = this._topleft.plus(half_size);
      }
      return center;
    };

    Rect.prototype.size = function(size) {
      return new Size(this._bottomright.x() - this.topleft.x(), this._bottomright.y() - this.topleft.y());
    };

    Rect.prototype.pointInside = function(point) {
      var _ref, _ref1;

      return (this._topleft.x() < (_ref = point.x()) && _ref < this._bottomright.x()) && (this._topleft.y() < (_ref1 = point.y()) && _ref1 < this._bottomright.y());
    };

    Rect.prototype.copy = function() {
      return new Rect(this._topleft, this.size());
    };

    return Rect;

  })();

  Camera = (function() {
    Camera.prototype._pos = new Point();

    Camera.prototype.MOVE_MODE = {
      INSTANT: 1,
      APPROACH: 2
    };

    Camera.prototype._modes = 2;

    Camera.prototype._mode = 1;

    function Camera(_target, _size, _move_factor) {
      this._target = _target != null ? _target : new Point();
      this._size = _size != null ? _size : new Size();
      this._move_factor = _move_factor != null ? _move_factor : 1 / 10;
    }

    Camera.prototype.moveFactor = function(_move_factor) {
      this._move_factor = _move_factor;
      return this._move_factor;
    };

    Camera.prototype.size = function(size) {
      if (size) {
        this._size = size.copy();
      }
      return this._size.copy();
    };

    Camera.prototype.target = function(target) {
      if (target) {
        this._target = target.copy();
      }
      return this._target.copy();
    };

    Camera.prototype.pos = function() {
      return this._pos.copy();
    };

    Camera.prototype.mode = function(mode) {
      if (mode) {
        if (mode > this._modes) {
          mode = this._modes;
        }
        this._mode = mode;
      }
      return this._mode;
    };

    Camera.prototype.worldToScreenPoint = function(world_point) {
      var screen_point;

      screen_point = world_point.minus(this._pos);
      return screen_point;
    };

    Camera.prototype.screenToWorldPoint = function(screen_point) {
      var world_point;

      world_point = screen_point.plus(this._pos);
      return world_point;
    };

    Camera.prototype.worldToScreenRect = function(world_rect) {
      var screen_pos, screen_rect, world_pos;

      world_pos = world_rect.topleft();
      screen_pos = worldToScreenPoint(world_pos);
      screen_rect = Rect(screen_pos, world_rect.size());
      return screen_rect;
    };

    Camera.prototype.screenToWorldRect = function(screen_rect) {
      var screen_pos, world_pos, world_rect;

      screen_pos = screen_rect.topleft();
      world_pos = screenToWorldPoint(screen_pos);
      world_rect = Rect(world_pos, screen_rect.size());
      return world_rect;
    };

    Camera.prototype.pointOnScreen = function(point, world_space) {
      var _ref, _ref1;

      if (world_space == null) {
        world_space = false;
      }
      if (world_space) {
        point = this.worldToScreenPoint(point);
      }
      return (0 <= (_ref = point.x()) && _ref < this._size.width()) && (0 <= (_ref1 = point.y()) && _ref1 < this._size.height());
    };

    Camera.prototype.rectOnScreen = function(rect, world_space) {
      if (world_space == null) {
        world_space = false;
      }
      return pointOnScreen(rect.topleft(), world_space) || pointOnScreen(rect.topright(), world_space) || pointOnScreen(rect.bottomright(), world_space) || pointOnScreen(rect.bottomleft(), world_space);
    };

    Camera.prototype._update = function() {
      var dir;

      if (this._move === this.MOVE_MODE.INSTANT) {
        return this._pos = this._target.copy();
      } else if (this._move === this.MOVE_MODE.APPROACH) {
        dir = this._target.minus(this._pos);
        return this._pos = this._pos.plus(dir.times(this._move_factor));
      }
    };

    return Camera;

  })();

  camera = new Camera();

  AssetManager = (function() {
    AssetManager.prototype.IMG_FILE = "img/";

    AssetManager.prototype.SFX_FILE = "sfx/";

    function AssetManager() {
      this._load_img = __bind(this._load_img, this);      this._img = {};
      this._sfx = {};
    }

    AssetManager.prototype.image = function(file_name, onload) {
      var img;

      img = this._img[file_name];
      if (!img) {
        img = this._load_img(file_name, onload);
      }
      return img;
    };

    AssetManager.prototype.unloadImage = function(file_name) {
      return delete this._img[file_name];
    };

    AssetManager.prototype._load_img = function(file_name, onload) {
      var img;

      img = new Image();
      img.src = "" + this.IMG_FILE + file_name;
      if (onload) {
        img.onload = onload;
      }
      this._img[file_name] = img;
      return img;
    };

    return AssetManager;

  })();

  assets = new AssetManager();

  Background = (function() {
    function Background() {
      var onBgdLoad,
        _this = this;

      this.ready = false;
      onBgdLoad = function() {
        var y;

        y = (_this.canvas.height - _this.image.height) / config.pxpm;
        _this.pos = new Point(0, y);
        _this.wrap = new Point(_this.image.width, 0);
        return _this.ready = true;
      };
      this.image = assets.image(config.img.cityBgd1, onBgdLoad);
      this.canvas = $('#bgd-canvas')[0];
      this.canvas.width = config.width;
      this.canvas.height = config.height;
      this.ctx = this.canvas.getContext('2d');
      this.parallax = new Point(0.1, 1.0);
    }

    Background.prototype.draw = function() {
      var pos2;

      if (!this.ready) {
        return;
      }
      camera.drawImage(this.image, this.ctx, this.pos, this.parallax, this.wrap);
      pos2 = this.pos.plus(new Point(this.canvas.width, 0));
      return camera.drawImage(this.image, this.ctx, pos2, this.parallax, this.wrap);
    };

    Background.prototype.clear = function() {
      return this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    };

    return Background;

  })();

  Foreground = (function() {
    function Foreground() {}

    return Foreground;

  })();

  Map = (function() {
    function Map() {
      this.buildings = [10, 100, 300, 500, 700, 1000];
    }

    return Map;

  })();

  Main = (function() {
    Main.prototype.FPS = 1000 / 60;

    function Main() {
      this.bgd = new Background();
      this.fgd_canvas = $('#fgd-canvas')[0];
      this.fgd_ctx = this.fgd_canvas.getContext('2d');
      this.sprite_canvas = $('#sprite-canvas')[0];
      this.sprite_ctx = this.sprite_canvas.getContext('2d');
      this.hud_canvas = $('#hud-canvas')[0];
      this.hud_ctx = this.hud_canvas.getContext('2d');
      this._setupCanvas();
      assets = new AssetManager();
    }

    Main.prototype.loadAssets = function() {};

    Main.prototype.onUpdate = function() {
      console.log('update');
      return camera.moveRight(0.25);
    };

    Main.prototype.onDraw = function() {
      var img;

      img = config.img;
      this.bgd.draw();
      this._clearHud();
      this.hud_ctx.font = "20px";
      this.hud_ctx.fillStyle = "white";
      this.hud_ctx.fillText("x: " + camera.offset.x, 0, 10);
      return this.hud_ctx.fillText("y: " + camera.offset.y, 0, 20);
    };

    Main.prototype.run = function() {
      var animFrame, recursiveAnim,
        _this = this;

      this.loadAssets();
      setInterval(this.onUpdate, this.FPS);
      animFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || null;
      if (animFrame !== null) {
        recursiveAnim = function() {
          _this.onDraw();
          return animFrame(recursiveAnim);
        };
        return animFrame(recursiveAnim);
      } else {
        return setInterval(onDraw, this.FPS);
      }
    };

    Main.prototype._setupCanvas = function() {
      this.fgd_canvas.width = config.width;
      this.fgd_canvas.height = config.height;
      this.sprite_canvas.width = config.width;
      this.sprite_canvas.height = config.height;
      this.hud_canvas.width = config.width;
      return this.hud_canvas.height = config.height;
    };

    Main.prototype._clearFgd = function() {
      return this.fgd_ctx.clearRect(0, 0, this.fgd_canvas.width, this.fgd_canvas.height);
    };

    Main.prototype._clearSprites = function() {
      return this.sprite_ctx.clearRect(0, 0, this.sprite_canvas.width, this.sprite_canvas.height);
    };

    Main.prototype._clearHud = function() {
      return this.hud_ctx.clearRect(0, 0, this.hud_canvas.width, this.hud_canvas.height);
    };

    return Main;

  })();

  $(function() {
    var main;

    main = new Main();
    return main.run();
  });

  Circle = (function() {
    function Circle(_center, _radius) {
      this._center = _center != null ? _center : new Point();
      this._radius = _radius != null ? _radius : 1;
    }

    return Circle;

  })();

}).call(this);
