/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Singleton
 - - - - - - - - - -
 ![Singleton Diagram](Singleton_Diagram.png)
 
 The singleton pattern restricts a class to have only _one_ instance.
 
 The "singleton plus" pattern is also common, which provides a "shared" singleton instance, but it also allows other instances to be created too.
 
 ## Code Example
 */
import UIKit

// Singleton pattern, you cannot create more than one instance
let app = UIApplication.shared
//let app2 = UIApplication()

public class MySingleton {
    
    static let shared = MySingleton()
    
    private init() {}
    
}

public class MySingletonPlus {

  static let shared = MySingletonPlus()

  public init() { }
}


let singletonPlus = MySingletonPlus.shared
let singletonPlus2 = MySingletonPlus()


let mySingleton = MySingleton.shared
//let singleton2 = MySingleton()


// Proof of a Singleton Plus patern
let defaultFileManager = FileManager.default
let customFileManger = FileManager()
