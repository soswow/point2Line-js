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