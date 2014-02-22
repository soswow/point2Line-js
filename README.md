#What is this?
This lightweight Processing/JavaScript library contains basic tools for calculating geometry in two dimensions. It includes a vector class that offers an alternative to the build in PVector class. The library only adds functions that I either miss in the existing collection of libraries or think could be simplified.

[Vect2](Vect2.coffee) stores and manipulates vectors and positions in 2D.
[Space2](Space2.coffee) serves as a toolbox for geometry calculations in 2D.

The library does not depend on other libraries and should be able to run on most Processing versions and all OS platforms (please report problems).

This is implementation/translation of original [point2line](http://sixthsensor.dk/code/p5/point2line/index.htm) library made and maintained by Carl Emil Carlsen and Daniel Hoeier Oehrgaard.

#Vect2
Vect2 is a class for storing and manipulating vectors and positions in 2D.

##Why another vector class?
There are a great number of open source vector classes available that does
practically the same, so choosing a vector class for consistent use is mostly
about taste. Processing already has the build-in PVector class by [Daniel Shiffman](http://shiffman.net/).
The main arguments for using Vect2 are:
* Additional commonly used methods
* Optimized convenience methods
* Method chaining

Also, PVector is made for both 2D and 3D purposes which makes Vect2 slightly faster
when working in 2D. I have chosen meaningful naming in favor of short keywords,
making it more attractive for non-programmers.

##About method chaining
The methods that are named in past tense (eg. ```added(), flipped()```) all return
a copy of the vector, leaving the original untouched. These are all convenience methods
that allow to make series of methods calls in one line. Example:<br/>
```var force = pos1.subtracted(pos2).normalized().scaled(maxForce);```

##Methods

###`constructor(angle | vector | x, y)`
Vect2 can be constructed with following options:
* ```new Vect2()``` - Zero vector
* ```new Vect2(Math.PI / 4)``` - Unit vector at a specific angle (angle in radians)
* ```new Vect2(vect)``` - Vector to copy into new vector
* ```new Vect2(x, y)``` - x,y components of new vector

###`isZero()`
Returns true if the vector is zero.
  
###`isAlmostZero([target])`
Returns a boolean that is true if the vector is almost zero. This is useful when easing towards zero to check if the target has been reached. Default target number is +/- 0.001, but can be changed with only argument.

###`isGreaterThan(magnitude)`
Returns a boolean that is true if the vector is longer than the input magnitude. This is about ten times faster than a regular distance check, because it avoids using square root and division.

###`isLessThan(magnitude)`
Returns a boolean that is true if the vector is shorter than the input magnitude. This is about ten times faster than a regular distance check, because it avoids using square root and division.

###`equals(vector)`
Returns a boolean that is true if the vector is equals an input vector.

###`scale(multiplier | vector | x, y)`
Multiplies the vector by an input value and stores the result. Returns self for chaining.
Possible argument:                                            
* `multiplier` - to scale both x and y with number            
* `x, y` - to scale x and y separatly                 
* `vector` - Another vector to take x and y of it

###`scaled(multiplier | vector | x, y)`
Multiplies the vector by an input value and returns new vector without changing the original.

###`divide(divider)`
Divides the vector by a divider and stores the result.
Returns self for chaining.

###`divided(divider)`
Divides the vector by a divider and returns new vector without changing the original.

###`add(vector | x, y)`
Adds an input vector to the vector and stores the result. Returns self for chaining.
Possible arguments:
* `x, y` - numbers to add
* `vector` - vector to add

###`added(vector | x, y)`
Adds an input vector to the vector and returns new vector without changing the original.

###`subtract(vector | x, y)`
Subtracts an input from the vector and stores the result. Returns self for chaining. 
Possible arguments:                                      
* `x, y` - numbers to subtract
* `vector` - vector to subtract


###`subtracted(vector | x, y)`
Subtracts and input vector from the vector and returns new vector without changing the originals.
For possible arguments see ```subtract()```                                                      

###`magnitude()`
Returns the magnitude of the vector, also referred to as the length.

###`squareMagnitude()`
Returns the square magnitude (square length) of the vector.                                

The square root which is used when calling magnitude() is horrendously slow,               
so try to avoid calculating vector lengths whenever you can. A common problem in computer  
graphics is to find the shortest vector in a list, in this case you only need to calculate 
the square magnitude `(x * x + y * y)` for each of them and find the smallest value from that
(since the vector with the shortest length will also have the smallest squared length).    

###`normalize()`
Normalizes the vector. Same as calling ```setMagnitude(1)```

###`normalized()`
Returns a copy that has been normalized.

###`setMagnitude(length)`
Sets the magnitude (length) of the vector. Returns self for chaining.                

###`clip(maximumLength)`
Clips the magnitude of the vector. In other words, if the magnitude exceeds the input value, it is set to that value. Returns self for chaining.

###`clipped(maximum)`
Returns a copy of the vector that has been clipped.

###`angle()`
Returns the angle of the vector in radians. All rotations are based on the unit circle where angle 0 and PI*2 is 3 o'clock.

###`rotate(deltaAngle)`
Rotates the vector clockwise by a delta angle (in radians) (turning left from the vectors forward direction). Returns self for chaining.

###`rotated(deltaAngle)`
Returns a copy that is rotated clockwise from the vector by a specified angle (in radians) (turning left from the vectors forward direction).

###`setRotation(angle)`
Sets the rotation of the vector. All rotations are based on the unit circle where angle 0 and PI*2 is 3 o'clock. It is slightly faster to call rotate() by a delta angle. Returns self for chaining.                                         

###`rotateRight()`
Rotates the vector 90 degrees right. The magnitude is left unchanged. This is much faster than rotate() or setRotation(). Returns self for chaining.                  

###`rotatedRight()`
Returns a copy that has been rotated 90 degrees clockwise from the vector's forward angle.
The magnitude is unchanged. This is much faster than rotate() or setRotation().

###`rotateLeft()`
Rotates the vector 90 degrees left. The magnitude is left unchanged. This is much faster than rotate() or setRotation(). Returns self for chaining.

###`rotatedLeft()`
Returns a copy that has been rotated 90 degrees counter clockwise from the vector's forward angle. The magnitude is unchanged. This is much faster than rotate() or setRotation().

###`flip()`
Flips the vector 180 degrees from it's forward angle. Returns self for chaining.

###`flipped()`
Returns a copy that is flipped 180 degrees from the vector's forward angle.

###`Vect2.distance(vector, vector)`
Returns the euclidean distance between to positions stored in two vectors.

###`Vect2.dot(vector, vector)`
Returns the dot product of this vector and another.              
The dot product value is in fact the cosine of the angle         
between the two input vectors, multiplied by the lengths         
of those vectors. So, you can easily calculate the cosine        
of the angle by either, making sure that your two vectors        
are both of length 1, or dividing the dot product by the         
lengths. `cos( theta ) = dot( v1, v2 ) / ( magnitude( v1 )magnitude( v2 ) )`
Values range from 1 to -1. If the two input vectors are          
pointing in the same direction, then the return value will       
be 1. If the two input vectors are pointing in opposite          
directions, then the return value will be -1. If the two         
input vectors are at right angles, then the return value         
will be 0. So, in effect, it is telling you how similar          
the two vectors are.                                             

###`Vect2.lerp(begin, end, interpolator)`
Returns the linear interpolation between two vectors. In some vector
classes this is referred to as blend(). Arguments are:                                                      
* `begin` - the vector when interpolator is 0                       
* `end` - the vector when interpolator is 1                         
* `interpolator` - number (0-1) to lerp between the two vectors     
 
###`Vect2.angleBetween(vector, vector)`
Returns the angle between the forward angles of two vectors.

The result is always positive. If you also need to know the rotational direction
(clockwise or counter-clockwise) you need to calculate the angle of each vector
and work it out from there.

###`Vect2.angleBetweenUnits(vector, vector)`
Returns the angle between the forward angles of two unit vectors. Use `angleBetween()` for vectors that are not normalized. This is only included to occasionally save a couple of internal normalize calls.

The result is always positive. If you also need to know the rotational direction (clockwise or counter-clockwise) you need to calculate the angle of each vector and work it out from there.

###`set(vector | x, y)`
Sets vector's x, y components. Returns self for chaining. Possible arguments:
* `x, y` - numbers to set
* `vector` - vector which x, y will be set

###`setZero()`
Sets the vector to zero. Returns self for chaining.

###`copy()`
Returns a copy of the vector. Use this when you want to avoid creating references between vectors instead of doing ```v1 = v2```, do ```v1 = v2.copy()```

###`toString()`
Returns a string containing the `x, y` components of this vector.


#Space2
Space2 is a class that compiles a bunch of useful functions
for calculating geometry in 2D space and is only meant to be
accessed statically.

##Methods

##Authors
* [Carl Emil Carlsen](http://sixthsensor.dk/) - original library author
* [Daniel Hoeier Oehrgaard](http://stimulacrum.com/) - original library author
* Aleksandr Motsjonov - translated to CoffeeScript/JavaScript

##Licence
The library is free software; you can redistribute it
and/or modify it for any desirable purpose. It is distributed in the hope that
it will be useful, but without any warranty.
