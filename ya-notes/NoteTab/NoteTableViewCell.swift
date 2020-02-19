//
//  NoteTableViewCell.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/16/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView! {
        didSet {
            colorView.layer.borderWidth = 1.0
            colorView.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
