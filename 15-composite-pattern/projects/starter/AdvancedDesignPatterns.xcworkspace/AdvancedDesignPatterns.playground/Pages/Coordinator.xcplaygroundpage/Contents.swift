/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Coordinator
 - - - - - - - - - -
 ![Coordinator](Coordinator_Diagram.png)
 
 The coordinator pattern is a structural design pattern for organizing flow logic between view controllers. It involves these components:
 
 1. The **Coordinator** is a protocol that defines methods and properties all concrete coordinators must implement. Specifically, it defines relationship properties, `children` and `router`, and presentation methods, `present` and `dismiss`.
 
 2. The **Concrete Coordinator** implements the coordinator protocol. It knows how to create concrete view controllers and the order that view controllers should be displayed.
 
 3. The **Router** is a protocol that defines methods all concrete routers must implement. Specifically, it defines `present` and `dismiss` methods for showing and dismissing view controllers.
 
 4. The **Concrete Router** knows how to present view controllers, but it doesn't know what exactly is being presented or which view controller will be presented next.
 
 5. The **Concrete View Controllers** are your typical `UIViewController` subclasses found in MVC. However, they _don't_ know about other view controllers. Instead, they delegate to the coordinator whenever a transition needs to performed.
 
 ## Code Example
 */
