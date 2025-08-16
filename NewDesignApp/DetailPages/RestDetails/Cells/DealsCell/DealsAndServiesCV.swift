//
//  DealsAndServiesCV.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 15/08/24.
//

import UIKit
import Lottie
class DealsAndServiesCV: UICollectionViewCell {
    @IBOutlet weak var headingTitle: UILabel!
    @IBOutlet weak var subHeadingTitle: UILabel!
    @IBOutlet weak var offerImageView: LottieAnimationView!


    @IBOutlet weak var roundView: UIView!
    
    func updateUI(offerItem: RestOffer?) {
        offerImageView.play()
        offerImageView.loopMode = .loop
        roundView.backgroundColor = .clear
        headingTitle.textColor = .black
        if offerItem?.types == "%" {
            headingTitle.text = "Flat \(offerItem?.amount ?? 0.0)\(offerItem?.types ?? "") OFF"

        } else {
            headingTitle.text = "Flat \(offerItem?.types ?? "")\(offerItem?.amount ?? 0.0) OFF"
        }
        subHeadingTitle.text = "Minimim purchase of \(UtilsClass.getCurrencySymbol())\(offerItem?.minorder ?? 0) "
    }
}
