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

import Foundation

public final class DiskCaretaker {
  public static let decoder = JSONDecoder()
  public static let encoder = JSONEncoder()
  
  public static func save<T: Codable>(_ object: T, to fileName: String) throws {
    do {
      let url = createDocumentURL(withFileName: fileName)
      let data = try encoder.encode(object)
      try data.write(to: url, options: .atomic)
    } catch (let error) {
      print("Save failed: Object: `\(object)`, Error: `\(error)`")
      throw error
    }
  }
  
  public static func retrieve<T: Codable>(_ type: T.Type, from fileName: String) throws -> T {
    let url = createDocumentURL(withFileName: fileName)
    return try retrieve(T.self, from: url)
  }
  
  public static func retrieve<T: Codable>(_ type: T.Type, from url: URL) throws -> T {
    do {
      let data = try Data(contentsOf: url)
      return try decoder.decode(T.self, from: data)
    } catch (let error) {
      print("Retrieve failed: URL: `\(url)`, Error: `\(error)`")
      throw error
    }
  }
  
  public static func createDocumentURL(withFileName fileName: String) -> URL {
    let fileManager = FileManager.default
    let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    return url.appendingPathComponent(fileName).appendingPathExtension("json")
  }
}
