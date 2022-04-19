//
//  ReviewCell.swift
//  Navi-App
//
//  Created by Brandon Mack on 4/9/22.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var cellStar1: UIImageView!
    @IBOutlet weak var cellStar2: UIImageView!
    @IBOutlet weak var cellStar3: UIImageView!
    @IBOutlet weak var cellStar4: UIImageView!
    @IBOutlet weak var cellStar5: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
