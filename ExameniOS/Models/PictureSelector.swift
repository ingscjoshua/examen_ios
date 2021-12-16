//
//  PictureSelector.swift
//  ExameniOS
//
//  Created by Josue Hernandezon 09/11/21.
//

import UIKit

class PictureSelector: UIAlertController {

  let imagePicker = UIImagePickerController()
  weak var parentController: UIViewController?

  convenience init(title: String, parentController: UIViewController) {
    self.init(title: "Load Photo",
              message: "",
              preferredStyle: .actionSheet)
    self.parentController = parentController
    addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
    setupActions()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func setupActions() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
      addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) -> Void in
        self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
        self.imagePicker.allowsEditing = true
        self.parentController?.present(self.imagePicker, animated: true, completion: nil)
      }))
    }

    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
      addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) -> Void in
        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.imagePicker.allowsEditing = true
        self.parentController?.present(self.imagePicker, animated: true, completion: nil)
      }))
    }
  }
}
