//
//  PaymentTypeTVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 22/10/24.
//

import UIKit
protocol PaymentTypeDeledate: AnyObject {
    func selectedPaymentType(index: Int)
}
class PaymentTypeTVCell: UITableViewCell {
    @IBOutlet weak var paymentTypeSegment: UISegmentedControl!
    weak var delegate: PaymentTypeDeledate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        paymentTypeSegment.selectedSegmentTintColor = kBlueColor
        paymentTypeSegment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        self.backgroundColor = .white

    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.delegate?.selectedPaymentType(index: sender.selectedSegmentIndex)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
