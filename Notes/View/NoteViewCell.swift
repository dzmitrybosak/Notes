//
//  NoteViewCell.swift
//  Notes
//
//  Created by Dzmitry Bosak on 6/28/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

class NoteViewCell: UITableViewCell {

    var data = DataInStorage.shared
    
    //MARK: Properties
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var subtitleCell: UILabel!
    
    var note: Note! {
        didSet {
            update()
        }
    }
    
    func update() {
        titleCell.text = note?.title
        subtitleCell.text = data.dateFormat(date: note.date!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
