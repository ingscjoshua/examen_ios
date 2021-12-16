//
//  PhotoCell.swift
//  ExameniOS
//
//  Created by Josue Hernandezon 09/11/21.
//

import UIKit

class PhotoCell: UITableViewCell {
  @IBOutlet weak var pictureView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func bindWithImage(image: UIImage?){
    guard let loadImage = image else {return}
    pictureView.image = loadImage
  }
    
}
