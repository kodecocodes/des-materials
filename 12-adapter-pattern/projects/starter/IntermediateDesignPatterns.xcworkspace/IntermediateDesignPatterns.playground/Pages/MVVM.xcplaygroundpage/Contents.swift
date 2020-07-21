/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Model-View-ViewModel (MVVM)
 - - - - - - - - - -
 ![MVVM Diagram](MVVM_Diagram.png)
 
 The Model-View-ViewModel (MVVM) pattern separates objects into three types: models, views and view-models.
 
 - **Models** hold onto application data. They are usually structs or simple classes.
 - **View-models** convert models into a format that views can use.
 - **Views** display visual elements and controls on screen. They are usually subclasses of `UIView`.
 
 ## Code Example
 */
import PlaygroundSupport
import UIKit

// MARK: - Model
public class Pet {
  
  public enum Rarity {
    case common
    case uncommon
    case rare
    case veryRare
  }
  
  public let name: String
  public let birthday: Date
  public let rarity: Rarity
  public let image: UIImage
  
  public init(name: String,
              birthday: Date,
              rarity: Rarity,
              image: UIImage) {
    
    self.name = name
    self.birthday = birthday
    self.rarity = rarity
    self.image = image
  }
}

// MARK: - ViewModel
public class PetViewModel {
  
  private let pet: Pet
  private let calendar: Calendar
  
  public init(pet: Pet) {
    self.pet = pet
    self.calendar = Calendar(identifier: .gregorian)
  }
  
  public var name: String {
    return pet.name
  }
  
  public var image: UIImage {
    return pet.image
  }
  
  public var ageText: String {
    let today = calendar.startOfDay(for: Date())
    let birthday = calendar.startOfDay(for: pet.birthday)
    let components = calendar.dateComponents([.year],
                                             from: birthday,
                                             to: today)
    let age = components.year!
    return "\(age) years old"
  }
  
  public var adoptionFeeText: String {
    switch pet.rarity {
    case .common:
      return "$50.00"
    case .uncommon:
      return "$75.00"
    case .rare:
      return "$150.00"
    case .veryRare:
      return "$500.00"
    }
  }
}

extension PetViewModel {
  
  public func configure(_ view: PetView) {
    view.nameLabel.text = name
    view.imageView.image = image
    view.ageLabel.text = ageText
    view.adoptionFeeLabel.text = adoptionFeeText
  }
}

// MARK: - View
public class PetView: UIView {
  
  public let imageView: UIImageView
  public let nameLabel: UILabel
  public let ageLabel: UILabel
  public let adoptionFeeLabel: UILabel
  
  public override init(frame: CGRect) {
    var childFrame = CGRect(x: 0,
                            y: 16,
                            width: frame.width,
                            height: frame.height / 2)
    
    imageView = UIImageView(frame: childFrame)
    imageView.contentMode = .scaleAspectFit
    
    childFrame.origin.y += childFrame.height + 16
    childFrame.size.height = 30
    nameLabel = UILabel(frame: childFrame)
    nameLabel.textAlignment = .center
    
    childFrame.origin.y += childFrame.height
    ageLabel = UILabel(frame: childFrame)
    ageLabel.textAlignment = .center
    
    childFrame.origin.y += childFrame.height
    adoptionFeeLabel = UILabel(frame: childFrame)
    adoptionFeeLabel.textAlignment = .center
    
    super.init(frame: frame)
    
    backgroundColor = .white
    addSubview(imageView)
    addSubview(nameLabel)
    addSubview(ageLabel)
    addSubview(adoptionFeeLabel)
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init?(coder:) is not supported")
  }
}

// MARK: - Example
let birthday = Date(timeIntervalSinceNow: (-2 * 86400 * 366))
let image = UIImage(named: "stuart")!
let stuart = Pet(name: "Stuart",
                 birthday: birthday,
                 rarity: .veryRare,
                 image: image)

let viewModel = PetViewModel(pet: stuart)

let frame = CGRect(x: 0, y: 0, width: 300, height: 420)
let view = PetView(frame: frame)

viewModel.configure(view)

PlaygroundPage.current.liveView = view
