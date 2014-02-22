PI = Math.PI
TWO_PI = PI * 2
HALF_PI = PI * 0.5

sameSign = (a, b) ->
  a * b >= 0

class Space2

  ###
  Calculates the point on an ellipse at a specific angle.
  Only use this function when absolutely necessary. It is slow. For
  the purpose of drawing an ellipse, simply calculate the points on
  a circle and scale the x and y value. [Source and info] (http://mathforum.org/library/drmath/view/54922.html)

  @param angle in radians (<code>float</code>)
  @param width of the ellipse (<code>float</code>)
  @param height of the ellipse (<code>float</code>)
  @return position (<code>Vect2</code>)
  ###
  @ellipsePoint: (angle, width, height) ->
    angle %%= TWO_PI
    t = Math.atan(width) * Math.tan(angle) / height
    t -= PI  if angle > HALF_PI and angle < PI + HALF_PI
    x = width * 0.5 * Math.cos(t)
    y = height * 0.5 * Math.sin(t)
    new Vect2(x, y)


  ###
  Calculates the distance from a point to a line.

  The distance is positive on the right side of the line (following point A to B),
  and negative on the other side.

  The distance is calculated as if the line is continues infinitely in both ends.

  @param point (<code>Vect2</code>)
  @param linePointA (<code>Vect2</code>)
  @param linePointB (<code>Vect2</code>)
  @return distance (<code>float</code>)
  ###
  @pointToLineDistance: ( point, linePointA, linePointB ) ->
    a = ((linePointA.y - linePointB.y) * point.x) +
          ((linePointB.x - linePointA.x) * point.y) +
          ((linePointA.x * linePointB.y) - (linePointB.x * linePointA.y))

    b = ((linePointB.x - linePointA.x) * (linePointB.x - linePointA.x)) +
        ((linePointB.y - linePointA.y) * (linePointB.y - linePointA.y))

    a / Math.sqrt(b)



  ###
  Calculates whether a point is inside a polygon.

  Code is borrowed from this [Processing.org thread](http://processing.org/discourse/yabb_beta/YaBB.cgi?board=Programsaction=displaynum=1189178826).
  Thanks to [st33d](http://www.robotacid.com/) for the code.

  @param point containing the x,y coordinates to test (<code>Vect2</code>)
  @param vertices defining the polygon in the correct order (<code>Vect2[]</code>)
  @return true if the point is inside the polygon, otherwise false (<code>boolean</code>)
  ###
  @insidePolygon: ({x: x, y: y}, vertices) ->
    poly = new Float32Array(vertices.length * 2)
    p = 0
    for vertex in vertices
      poly[p++] = vertex.x
      poly[p++] = vertex.y

    pnum = vertices.length
    c = 0
    j = pnum - 1
    for i in [0...pnum]
      id1 = i * 2
      id2 = j * 2
      if ( (poly[id1 + 1] <= y and y < poly[id2 + 1]) or
            (poly[id2 + 1] <= y and y < poly[id1 + 1])
      ) and x < (poly[id2] - poly[id1]) * (y - poly[id1 + 1]) / (poly[id2 + 1] - poly[id1 + 1]) + poly[id1]
        c = (c + 1) %% 2
      j = i
    c is 1


  ###
  Calculates the intersection of two lines.

  The code comes from a post on Code & Form by Marius Watz, which led to a
  response with a more efficient algorithm taken from Graphics Gems. See
  the [original discussion](http://workshop.evolutionzone.com/2007/09/10/code-2d-line-intersection/).

  @param p1,p2,p3,p4 two pair of vectors each defining a line (```Vect2,Vect2,Vect2,Vect2```)
  @return null if there is no intersection, otherwise a vector containing the intersection coordinate (```Vect2```)
  ###
  @lineIntersection: ({x: x1, y: y1}, {x: x2, y: y2}, {x: x3, y: y3}, {x: x4, y: y4}) ->
    # Compute a1, b1, c1, where line joining points 1 and 2
    # is "a1 x + b1 y + c1 = 0".
    a1 = y2 - y1
    b1 = x1 - x2
    c1 = (x2 * y1) - (x1 * y2)

    # Compute r3 and r4.
    r3 = ((a1 * x3) + (b1 * y3) + c1)
    r4 = ((a1 * x4) + (b1 * y4) + c1)

    # Check signs of r3 and r4. If both point 3 and point 4 lie on
    # same side of line 1, the line segments do not intersect.
    return null  if (r3 isnt 0) and (r4 isnt 0) and sameSign(r3, r4)

    # Compute a2, b2, c2
    a2 = y4 - y3
    b2 = x3 - x4
    c2 = (x4 * y3) - (x3 * y4)

    # Compute r1 and r2
    r1 = (a2 * x1) + (b2 * y1) + c2
    r2 = (a2 * x2) + (b2 * y2) + c2

    # Check signs of r1 and r2. If both point 1 and point 2 lie
    # on same side of second line segment, the line segments do
    # not intersect.
    return null  if (r1 isnt 0) and (r2 isnt 0) and sameSign(r1, r2)

    #Line segments intersect: compute intersection point.
    denom = (a1 * b2) - (a2 * b1)

    return null  if denom is 0

    offset =
      if denom < 0
        -denom / 2
      else
        denom / 2

    # The denom/2 is to get rounding instead of truncating. It
    # is added or subtracted to the numerator, depending upon the
    # sign of the numerator.

    intersection = new Vect2()

    num = (b1 * c2) - (b2 * c1)
    intersection.x =
      if num < 0
        (num - offset) / denom
      else
        (num + offset) / denom

    num = (a2 * c1) - (a1 * c2)
    intersection.y =
      if num < 0
        (num - offset) / denom
      else
        (num + offset) / denom

    intersection