/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Iterator
 - - - - - - - - - -
 ![Iterator Diagram](Iterator_Diagram.png)
 
 The Iterator Pattern provides a standard way to loop through a collection. This pattern involves two types:
 
 1. The Swift `Iterable` protocol defines a type that can be iterated using a `for in` loop.
 
 2. A **custom object** you want to make iterable. Instead of conforming to `Iterable` directly, however, you can conform to `Sequence`, which itself conforms to `Iterable`. By doing so, you'll get many higher-order functions, including `map`, `filter` and more, implemented for free for you.
 
 ## Code Example
 */
