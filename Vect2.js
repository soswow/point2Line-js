// Generated by CoffeeScript 1.7.1
(function() {
  var TWO_PI, Vect2, exports;

  TWO_PI = Math.PI * 2;

  Vect2 = (function() {
    Vect2.prototype.x = 0;

    Vect2.prototype.y = 0;

    Vect2.prototype.isVect2 = true;

    function Vect2() {
      var angle, _ref;
      _ref = (function() {
        switch (arguments.length) {
          case 1:
            if (typeof arguments[0] === 'number') {
              angle = arguments[0];
              return [Math.cos(angle), Math.sin(angle)];
            } else {
              return [arguments[0].x, arguments[0].y];
            }
            break;
          case 2:
            return arguments;
        }
      }).apply(this, arguments), this.x = _ref[0], this.y = _ref[1];
    }

    Vect2.prototype.isZero = function() {
      return this.x === 0 && this.y === 0;
    };

    Vect2.prototype.isAlmostZero = function(target) {
      if (target == null) {
        target = 0.001;
      }
      return Math.abs(this.x) < target && Math.abs(this.y) < target;
    };

    Vect2.prototype.isGreaterThan = function(magnitude) {
      return this.squareMagnitude() > magnitude * magnitude;
    };

    Vect2.prototype.isLessThan = function(magnitude) {
      return this.squareMagnitude() < magnitude * magnitude;
    };

    Vect2.prototype.equals = function(vector) {
      if (vector == null) {
        return false;
      }
      return this.x === vector.x && this.y === vector.y;
    };

    Vect2.prototype.scale = function() {
      var multX, multY, _ref;
      _ref = this._xyFromArguments(arguments), multX = _ref[0], multY = _ref[1];
      this.x *= multX;
      this.y *= multY;
      return this;
    };

    Vect2.prototype.scaled = function(multX, multY) {
      return this.copy().scale(multX, multY);
    };

    Vect2.prototype.divide = function(divider) {
      if (divider === 0) {
        this.scale(0);
      } else {
        this.scale(1 / divider);
      }
      return this;
    };

    Vect2.prototype.divided = function(divider) {
      return this.copy().divide(divider);
    };

    Vect2.prototype.add = function(x, y) {
      var _ref;
      _ref = this._xyFromArguments(arguments), x = _ref[0], y = _ref[1];
      this.x += x;
      this.y += y;
      return this;
    };

    Vect2.prototype.added = function(x, y) {
      return this.copy().add(x, y);
    };

    Vect2.prototype.subtract = function() {
      var x, y, _ref;
      _ref = this._xyFromArguments(arguments), x = _ref[0], y = _ref[1];
      this.x -= x;
      this.y -= y;
      return this;
    };

    Vect2.prototype.subtracted = function(x, y) {
      return this.copy().subtracted(x, y);
    };

    Vect2.prototype.magnitude = function() {
      return Math.sqrt(this.x * this.x + this.y * this.y);
    };

    Vect2.prototype.squareMagnitude = function() {
      return this.x * this.x + this.y * this.y;
    };

    Vect2.prototype.normalize = function() {
      return this.setMagnitude(1);
    };

    Vect2.prototype.normalized = function() {
      return this.copy().normalize();
    };

    Vect2.prototype.setMagnitude = function(magnitude) {
      var mult;
      if (!this.isZero()) {
        mult = magnitude / this.magnitude();
        this.scale(mult);
      }
      return this;
    };

    Vect2.prototype.clip = function(maximum) {
      if (this.magnitude() > maximum) {
        return this.setMagnitude(maximum);
      } else {
        return this;
      }
    };

    Vect2.prototype.clipped = function(maximum) {
      return this.copy().clip(maximum);
    };

    Vect2.prototype.angle = function() {
      var angle;
      angle = Math.atan2(this.y, this.x);
      if (angle < 0) {
        angle += TWO_PI;
        if (angle === TWO_PI) {
          angle = 0;
        }
      }
      return angle;
    };

    Vect2.prototype.rotate = function(deltaAngle) {
      var x, y;
      x = this.x;
      y = this.y;
      this.x = x * Math.cos(deltaAngle) - y * Math.sin(deltaAngle);
      this.y = x * Math.sin(deltaAngle) + y * Math.cos(deltaAngle);
      return this;
    };

    Vect2.prototype.rotated = function(deltaAngle) {
      return this.copy().rotate(deltaAngle);
    };

    Vect2.prototype.setRotation = function(angle) {
      this.set(this.magnitude(), 0);
      this.rotate(angle);
      return this;
    };

    Vect2.prototype.rotateRight = function() {
      var newX;
      newX = this.y;
      this.y = this.x;
      this.x = -newX;
      return this;
    };

    Vect2.prototype.rotatedRight = function() {
      return this.copy().rotateRight();
    };

    Vect2.prototype.rotateLeft = function() {
      var newX;
      newX = this.y;
      this.y = -this.x;
      this.x = newX;
      return this;
    };

    Vect2.prototype.rotatedLeft = function() {
      return this.copy.rotateLeft();
    };

    Vect2.prototype.flip = function() {
      this.x *= -1;
      this.y *= -1;
      return this;
    };

    Vect2.prototype.flipped = function() {
      return this.copy().flip();
    };

    Vect2.distance = function(vector1, vector2) {
      var dx, dy;
      dx = vector1.x - vector2.x;
      dy = vector1.y - vector2.y;
      return Math.sqrt(dx * dx + dy * dy);
    };


    /*
    Returns the dot product of this vector and another.
    The dot product value is in fact the cosine of the angle
    between the two input vectors, multiplied by the lengths
    of those vectors. So, you can easily calculate the cosine
    of the angle by either, making sure that your two vectors
    are both of length 1, or dividing the dot product by the
    lengths.
    cos( theta ) = dot( v1, v2 ) / ( magnitude( v1 )magnitude( v2 ) )
    Values range from 1 to -1. If the two input vectors are
    pointing in the same direction, then the return value will
    be 1. If the two input vectors are pointing in opposite
    directions, then the return value will be -1. If the two
    input vectors are at right angles, then the return value
    will be 0. So, in effect, it is telling you how similar
    the two vectors are.
     */

    Vect2.dot = function(vector1, vector2) {
      return vector1.x * vector2.x + vector1.y * vector2.y;
    };


    /*
    Returns the linear interpolation between two vectors. In some vector
    classes this is referred to as blend().
    Arguments are:
    * `begin` - the vector when interpolator is 0
    * `end` - the vector when interpolator is 1
    * `interpolator` - number (0-1) to lerp between the two vectors
     */

    Vect2.lerp = function(begin, end, interpolator) {
      var x, y;
      x = (end.x - begin.x) * interpolator + begin.x;
      y = (end.y - begin.y) * interpolator + begin.y;
      return new Vect2(x, y);
    };


    /*
    Returns the angle between the forward angles of two vectors.
    
    The result is always positive. If you also need to know the rotational direction
    (clockwise or counter-clockwise) you need to calculate the angle of each vector
    and work it out from there.
     */

    Vect2.angleBetween = function(vector1, vector2) {
      return this.angleBetweenUnits(vector1.normalized(), vector2.normalized());
    };


    /*
    Returns the angle between the forward angles of two unit vectors.
    Use angleBetween() for vectors that are not normalized. This is only included
    to occasionally save a couple of internal normalize calls.
    
    The result is always positive. If you also need to know the rotational direction
    (clockwise or counter-clockwise) you need to calculate the angle of each vector
    and work it out from there.
     */

    Vect2.angleBetweenUnits = function(vector1, vector2) {
      return Math.acos(this.dot(vector1, vector2));
    };

    Vect2.prototype.set = function() {
      var _ref;
      _ref = this._xyFromArguments(arguments), this.x = _ref[0], this.y = _ref[1];
      return this;
    };

    Vect2.prototype.setZero = function() {
      this.x = 0;
      this.y = 0;
      return this;
    };

    Vect2.prototype.copy = function() {
      return new Vect2(this.x, this.y);
    };

    Vect2.prototype.toString = function() {
      return "Vect2( " + this.x + ", " + this.y + " )";
    };

    Vect2.prototype._xyFromArguments = function(args) {
      if (args.length === 1) {
        if (args[0].x && args[0].y) {
          return [args[0].x, args[0].y];
        } else if (typeof args[0] === 'number') {
          return [args[0], args[0]];
        }
      } else if (args.length === 2) {
        return args;
      }
    };

    return Vect2;

  })();

  if (typeof exports !== "undefined") {
    if (typeof module !== "undefined" && module.exports) {
      exports = module.exports = Vect2;
    }
    exports.Vect2 = Vect2;
  } else {
    this.Vect2 = Vect2;
  }

  if (typeof define === 'function' && define.amd) {
    define('Vect2', [], function() {
      return Vect2;
    });
  }

}).call(this);
