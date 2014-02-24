# for internal calculations
TWO_PI = Math.PI * 2

class Vect2
  # The x, y components of the vector
  x: 0
  y: 0

  isVect2: true

  # Vect2 can be constructed with following options:
  # new Vect2() - Zero vector
  # new Vect2(Math.PI / 4) - Unit vector at a specific angle (angle in radians)
  # new Vect2(vect) - Vector to copy into new vector
  # new Vect2(x, y) - x,y components of new vector
  constructor: ->
    [@x, @y] =
      switch arguments.length
        when 1
          if typeof arguments[0] is 'number'
            angle = arguments[0]
            [Math.cos(angle), Math.sin(angle)]
          else
            [arguments[0].x, arguments[0].y]
        when 2 then arguments

  # Returns true if the vector is zero.
  isZero: ->
    @x is 0 and @y is 0


  # Returns a boolean that is true if the vector is almost zero.
  # This is useful when easing towards zero to
  # check if the target has been reached. Default target number is +/- 0.001,
  # but can be changed with only argument.
  isAlmostZero: (target=0.001) ->
    Math.abs(@x) < target and Math.abs(@y) < target


  # Returns a boolean that is true if the vector is longer than the
  # input magnitude. This is about ten times faster than
  # a regular distance check, because it avoids using square root and division.
  isGreaterThan: (magnitude) ->
    @squareMagnitude() > magnitude * magnitude


  # Returns a boolean that is true if the vector is shorter than the
  # input magnitude. This is about ten times faster than
  # a regular distance check, because it avoids using square root and division.
  isLessThan: (magnitude) ->
    @squareMagnitude() < magnitude * magnitude


  # Returns a boolean that is true if the vector is equals an input vector.
  equals: (vector) ->
    return false  unless vector?
    @x is vector.x and @y is vector.y


  # Multiplies the vector by an input value and stores the result.
  #
  # Possible argument:
  # * `multiplier` - to scale both x and y with number
  # * `multX, multY` - to scale x and y separatly
  # * `multVect` - Another vector to take x and y of it
  # Returns self for chaining.
  scale: ->
    [multX, multY] = @_xyFromArguments arguments
    @x *= multX
    @y *= multY
    this


  # Multiplies the vector by an input value and returns new vector without changing the original.
  # For possible arguments see ```scale()```
  scaled: (multX, multY) ->
    @copy().scale(multX, multY)


  # Divides the vector by a divider and stores the result.
  # Returns self for chaining.
  divide: (divider) ->
    if divider is 0
      @scale 0
    else
      @scale 1 / divider
    this


  # Divides the vector by a divider and returns new vector without changing the original.
  divided: (divider) ->
    @copy().divide(divider)


  # Adds an input vector to the vector and stores the result.
  #
  # Possible arguments:
  # * `x, y` - numbers to add
  # * `vector` - vector to add
  #
  # Returns self for chaining.
  add: (x, y) ->
    [x, y] = @_xyFromArguments arguments
    @x += x
    @y += y
    this


  # Adds an input vector to the vector and returns new vector without changing the original.
  # For possible arguments see ```add()```
  added: (x, y) ->
    @copy().add(x, y)


  # Subtracts an input from the vector and stores the result.
  #
  # Possible arguments:
  # * `x, y` - numbers to subtract
  # * `vector` - vector to subtract
  #
  # Returns self for chaining.
  subtract: ->
    [x, y] = @_xyFromArguments arguments
    @x -= x
    @y -= y
    this


  # Subtracts and input vector from the vector and returns new vector without changing the originals.
  # For possible arguments see ```subtract()```
  subtracted: (x, y) ->
    @copy().subtracted(x, y)


  # Returns the magnitude of the vector, also referred to as the length.
  magnitude: ->
    Math.sqrt @x * @x + @y * @y


  # Returns the square magnitude (square length) of the vector.
  #
  # The square root which is used when calling magnitude() is horrendously slow,
  # so try to avoid calculating vector lengths whenever you can. A common problem in computer
  # graphics is to find the shortest vector in a list, in this case you only need to calculate
  # the square magnitude (x * x + y * y) for each of them and find the smallest value from that
  # (since the vector with the shortest length will also have the smallest squared length).
  squareMagnitude: ->
    @x * @x + @y * @y


  # Normalizes the vector. Same as calling ```setMagnitude(1)```
  normalize: ->
    @setMagnitude 1


  # Returns a copy that has been normalized.
  normalized: ->
    @copy().normalize()


  # Sets the magnitude (length) of the vector.
  # Returns self for chaining.
  setMagnitude: (magnitude) ->
    unless @isZero()
      mult = magnitude / @magnitude()
      @scale mult
    this


  # Clips the magnitude of the vector. In other words, if the
  # magnitude exceeds the input value, it is set to that value.
  # Returns self for chaining.
  clip: (maximum) ->
    if @magnitude() > maximum
      @setMagnitude maximum
    else
      this


  # Returns a copy of the vector that has been clipped.
  clipped: (maximum) ->
    @copy().clip(maximum)


  # Returns the angle of the vector in radians. All rotations are based on
  # the unit circle where angle 0 and PI*2 is 3 o'clock.
  angle: ->
    angle = Math.atan2 @y, @x
    if angle < 0
      angle += TWO_PI
      angle = 0 if angle is TWO_PI
    angle


  # Rotates the vector clockwise by a delta angle (in radians)
  # (turning left from the vectors forward direction).
  # Returns self for chaining.
  rotate: (deltaAngle) ->
    x = @x
    y = @y
    @x = x * Math.cos(deltaAngle) - y * Math.sin(deltaAngle)
    @y = x * Math.sin(deltaAngle) + y * Math.cos(deltaAngle)
    this


  # Returns a copy that is rotated clockwise from the vector by a specified angle (in radians)
  # (turning left from the vectors forward direction).
  rotated: (deltaAngle) ->
    @copy().rotate(deltaAngle)


  # Sets the rotation of the vector. All rotations are based on
  # the unit circle where angle 0 and PI*2 is 3 o'clock. It is slightly
  # faster to call rotate() by a delta angle.
  # Returns self for chaining.
  setRotation: (angle) ->
    @set @magnitude(), 0
    @rotate angle
    this


  # Rotates the vector 90 degrees right. The magnitude is left unchanged.
  # This is much faster than rotate() or setRotation().
  # Returns self for chaining.
  rotateRight: ->
    newX = @y
    @y = @x
    @x = -newX
    this


  # Returns a copy that has been rotated 90 degrees clockwise from the vector's forward angle.
  # The magnitude is unchanged.
  # This is much faster than rotate() or setRotation().
  rotatedRight: ->
    @copy().rotateRight()


  # Rotates the vector 90 degrees left. The magnitude is left unchanged.
  # This is much faster than rotate() or setRotation().
  # Returns self for chaining.
  rotateLeft: ->
    newX = @y
    @y = -@x
    @x = newX
    this


  # Returns a copy that has been rotated 90 degrees counter clockwise from the vector's forward angle.
  # The magnitude is unchanged.
  # This is much faster than rotate() or setRotation().
  rotatedLeft: ->
    @copy.rotateLeft()


  # Flips the vector 180 degrees from it's forward angle.
  # Returns self for chaining.
  flip: ->
    @x *= -1
    @y *= -1
    this


  # Returns a copy that is flipped 180 degrees from the vector's forward angle.
  flipped: ->
    @copy().flip()


  # Returns the euclidean distance between to positions stored in two vectors.
  @distance: (vector1, vector2) ->
    dx = vector1.x - vector2.x
    dy = vector1.y - vector2.y
    Math.sqrt dx * dx + dy * dy


  ###
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
  ###
  @dot: (vector1, vector2) ->
    vector1.x * vector2.x + vector1.y * vector2.y


  ###
  Returns the linear interpolation between two vectors. In some vector
  classes this is referred to as blend().
  Arguments are:
  * `begin` - the vector when interpolator is 0
  * `end` - the vector when interpolator is 1
  * `interpolator` - number (0-1) to lerp between the two vectors
  ###
  @lerp: (begin, end, interpolator) ->
    x = (end.x - begin.x) * interpolator + begin.x
    y = (end.y - begin.y) * interpolator + begin.y
    new Vect2(x, y)


  ###
  Returns the angle between the forward angles of two vectors.

  The result is always positive. If you also need to know the rotational direction
  (clockwise or counter-clockwise) you need to calculate the angle of each vector
  and work it out from there.
  ###
  @angleBetween: (vector1, vector2) ->
    @angleBetweenUnits vector1.normalized(), vector2.normalized()


  ###
  Returns the angle between the forward angles of two unit vectors.
  Use angleBetween() for vectors that are not normalized. This is only included
  to occasionally save a couple of internal normalize calls.

  The result is always positive. If you also need to know the rotational direction
  (clockwise or counter-clockwise) you need to calculate the angle of each vector
  and work it out from there.
  ###
  @angleBetweenUnits: (vector1, vector2) ->
    Math.acos @dot vector1, vector2


  # Sets vector's x, y components.
  #
  # Possible arguments:
  # * `x, y` - numbers to set
  # * `vector` - vector which x, y will be set
  #
  # Returns self for chaining.
  set: ->
    [@x, @y] = @_xyFromArguments arguments
    this


  # Sets the vector to zero.
  setZero: ->
    @x = 0
    @y = 0
    this


  # Returns a copy of the vector. Use this when you want to avoid creating
  # references between vectors instead of doing ```v1 = v2```, do ```v1 = v2.copy```
  copy: ->
    new Vect2 @x, @y


  # Returns a string containing the (<code>x,y</code>) components of this vector.
  toString: ->
    "Vect2( " + @x + ", " + @y + " )"


  # Internal function to return x, y from arguments depending on number and type of those
  _xyFromArguments: (args) ->
    if args.length is 1
      if args[0].x and args[0].y
        [args[0].x, args[0].y]
      else if typeof args[0] is 'number'
        [args[0], args[0]]
    else if args.length is 2
      args



if typeof exports isnt "undefined"
  if typeof module isnt "undefined" and module.exports
    exports = module.exports = Vect2
  exports.Vect2 = Vect2
else
  @Vect2 = Vect2

if typeof define is 'function' and define.amd
  define 'Vect2', [], -> Vect2