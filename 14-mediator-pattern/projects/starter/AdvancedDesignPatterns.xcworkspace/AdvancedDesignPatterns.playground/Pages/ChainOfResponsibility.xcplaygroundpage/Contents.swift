/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Chain Of Responsibility
 - - - - - - - - - -
 ![Chain Of Responsibility Diagram](ChainOfResponsibility_Diagram.png)
 
The chain of responsibility pattern is a behavioral design pattern that allows an event to be processed by one of many handlers. It involves three types:
 
 1. The **client** accepts and passes events to an instance of a handler protocol.
 
 2. The **handler protocol** defines required properties and methods that concrete handlers must implement.
 
 3. The first **concrete handler** implements the handler protocol and is stored directly by the client. It first attempts to handle the event that's passed to it. If it's not able to do so, it passes the event onto its **next** concrete handler, which it holds as a strong property.
 
 ## Code Example
 */
