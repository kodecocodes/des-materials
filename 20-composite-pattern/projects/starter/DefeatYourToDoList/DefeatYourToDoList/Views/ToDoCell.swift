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

import UIKit

public class ToDoCell: UICollectionViewCell {

  // MARK: - IBOutlets
  @IBOutlet var toDoLabel: UILabel!
  @IBOutlet var checkBoxView: UIView!
  @IBOutlet var subTaskCollectionView: UICollectionView!

  // MARK: - Properties
  var subtasks: [ToDoItem] = []
  
  public override func layoutSubviews() {
    checkBoxView.layer.borderWidth = 1
    checkBoxView.layer.borderColor = UIColor.black.cgColor
    
    subTaskCollectionView.register(UINib(nibName: "ToDoCell", bundle: nil),
                                   forCellWithReuseIdentifier: "cell")
    subTaskCollectionView.delegate = self
    subTaskCollectionView.dataSource = self

    super.layoutSubviews()
  }
}

extension ToDoCell: UICollectionViewDataSource {

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return subtasks.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ToDoCell

    let currentToDo = subtasks[indexPath.row]
    if currentToDo.isComplete {
      cell.checkBoxView.backgroundColor = UIColor(red: 0.24, green: 0.56, blue: 0.30, alpha: 1.0)
    } else {
      cell.checkBoxView.backgroundColor = .white
    }

    cell.toDoLabel.text = currentToDo.name
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension ToDoCell: UICollectionViewDelegate {

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let currentToDo = subtasks[indexPath.row]

    if currentToDo.isComplete {
      currentToDo.isComplete = false
    } else {
      currentToDo.isComplete = true
    }
    collectionView.reloadData()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ToDoCell: UICollectionViewDelegateFlowLayout {

  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    let height: CGFloat = 60
    
    return CGSize(width: width, height: height)
  }
  
  public func collectionView(_ collectionView: UICollectionView,
                             layout collectionViewLayout: UICollectionViewLayout,
                             minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout
    collectionViewLayout: UICollectionViewLayout,
                             minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
}
