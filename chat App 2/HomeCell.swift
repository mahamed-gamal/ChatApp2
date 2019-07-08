//
//  RoomCell.swift
//  chat App 2
//
//  Created by Mohamed Gamal on 6/18/19.
//  Copyright © 2019 ME. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
