/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import RNCryptor
import SwiftKeychainWrapper

public class PasswordClient {

  // MARK: - Instance Properties
  public private(set) var passwords: [String] {
    didSet { setupDecryptionHandler() }
  }
  private let keychain = KeychainWrapper.standard
  private let passwordKey = "passwords"

  // MARK: - Object Lifecycle
  public init() {
    passwords = keychain.object(forKey: passwordKey) as? [String] ?? []
    setupDecryptionHandler()
  }

  private func setupDecryptionHandler() {
    // TODO: - Write this
  }

  // MARK: - Password Management
  public func addPassword(_ password: String) {
    guard !passwords.contains(password) else { return }
    passwords.append(password)
    passwords.sort()
    savePasswordsToKeychain()
  }

  public func removePassword(at index: Int) {
    passwords.remove(at: index)
    savePasswordsToKeychain()
  }

  public func removePassword(_ password: String) {
    guard let index = passwords.firstIndex(of: password) else { return }
    passwords.remove(at: index)
    savePasswordsToKeychain()
  }

  private func savePasswordsToKeychain() {
    keychain.set(passwords as NSArray, forKey: passwordKey)
  }

  // MARK: - Encrypt
  public func encrypt(_ text: String, usingPassword password: String) -> String {
    let data = text.data(using: .utf8)!
    let encryptedData = RNCryptor.encrypt(data: data, withPassword: password)
    return encryptedData.base64EncodedString()
  }

  // MARK: - Decrypt
  public func decrypt(_ base64EncodedString: String) -> String? {
    // TODO: - Write this
    return nil
  }
}
