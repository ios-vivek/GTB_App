//
//  DineInTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 17/12/24.
//

import UIKit

class DineInTVCell: UITableViewCell {
    @IBOutlet weak var restaurantLbl: UILabel!
    @IBOutlet weak var peopleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(order: DineInOrder) {
        restaurantLbl.text = order.restaurant
        peopleLbl.text = order.people
        dateLbl.text = order.date
        commentLbl.text = order.comment

    }

}
