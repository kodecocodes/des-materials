/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Composite
 - - - - - - - - - -
 ![Composite Diagram](Composite_Diagram.png)
 
 The composite pattern is a structural pattern that groups a set of objects into a tree so that they may be manipulated as though they were one object. It uses three types:
 
 1. The **component protocol** ensures all constructs in the tree can be treated the same way.
 2. A **leaf** is a component of the tree that does not have child elements.
 3. A **composite** is a container that can hold leaf objects and composites.
 
 ## Code Example
 */
protocol File {
  var name: String { get set }
  func open()
}

final class eBook: File {
  var name: String
  var author: String
  
  init(name: String, author: String) {
    self.name = name
    self.author = author
  }
  
  func open() {
    print("Opening \(name) by \(author) in iBooks...\n")
  }
}

final class Music: File {
  var name: String
  var artist: String
  
  init(name: String, artist: String) {
    self.name = name
    self.artist = artist
  }
  
  func open() {
    print("Playing \(name) by \(artist) in iTunes...\n")
  }
}

final class Folder: File {
  var name: String
  lazy var files: [File] = []
  
  init(name: String) {
    self.name = name
  }
  
  func addFile(file: File) {
    self.files.append(file)
  }
  
  func open() {
    print("Displaying the following files in \(name)...")
    for file in files {
      print(file.name)
    }
    print("\n")
  }
}

let psychoKiller = Music(name: "Psycho Killer", artist: "The Talking Heads")
let rebelRebel = Music(name: "Rebel Rebel", artist: "David Bowie")
let blisterInTheSun = Music(name: "Blister in the Sun", artist: "Violent Femmes")

let justKids = eBook(name: "Just Kids", author: "Patti Smith")

let documents = Folder(name: "Documents")
let musicFolder = Folder(name: "Great 70s Music")

documents.addFile(file: musicFolder)
documents.addFile(file: justKids)

musicFolder.addFile(file: psychoKiller)
musicFolder.addFile(file: rebelRebel)

blisterInTheSun.open()
justKids.open()

documents.open()
musicFolder.open()
