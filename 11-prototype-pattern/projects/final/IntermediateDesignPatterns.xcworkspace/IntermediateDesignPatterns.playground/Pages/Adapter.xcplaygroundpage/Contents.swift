/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Adapter
 - - - - - - - - - -
 ![Adapter Diagram](Adapter_Diagram.png)
 
 The adapter pattern allows incompatible types to work together. It involves four components:
 
 1. An **object using an adapter** is the object that depends on the new protocol.
 
 2. The **new protocol** that is desired to be used.
 
 3. A **legacy object** that existed before the protocol was made and cannot be modified directly to conform to it.
 
 4. An **adapter** that's created to conform to the protocol and passes calls onto the legacy object.
 
 ## Code Example
 */
// Third-Party Classes
public class GoogleAuthenticator {
  public  func login(email: String,
                     password: String,
                     completion: @escaping (GoogleUser?, Error?) -> Void) {
    
    // Make networking calls, which return a `Token`
    let token = "special-token-value"
    
    let user = GoogleUser(email: email, password: password, token: token)
    completion(user, nil)
  }
}

public  struct GoogleUser {
  public var email: String
  public var password: String
  public var token: String
}

// AuthenticationService
public protocol AuthenticationService {
  func login(email: String,
             password: String,
             success: @escaping (User, Token) -> Void,
             failure: @escaping (Error?) -> Void)
}

public struct User {
  public let email: String
  public let password: String
}

public struct Token {
  public let value: String
}

public class GoogleAuthenticatorAdapter: AuthenticationService {
  
  private var authenticator = GoogleAuthenticator()
  
  public func login(email: String,
                    password: String,
                    success: @escaping (User, Token) -> Void,
                    failure: @escaping (Error?) -> Void) {
    
    authenticator.login(email: email, password: password) { (googleUser, error) in
      guard let googleUser = googleUser else {
        failure(error)
        return
      }
      
      let user = User(email: googleUser.email, password: googleUser.password)
      let token = Token(value: googleUser.token)
      success(user, token)
    }
  }
}

// MARK: - Example
var authService: AuthenticationService = GoogleAuthenticatorAdapter()
authService.login(
  email: "user@example.com", password: "password",
  success: { user, token in
    print("Auth succeeded: \(user.email), \(token.value)")
    
}, failure: { error in
  print("Auth failed with error: \(error as Any)")
})
