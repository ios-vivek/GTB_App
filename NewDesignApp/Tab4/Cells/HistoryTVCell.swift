//
//  HistoryTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 28/10/24.
//

import UIKit
import Alamofire

class HistoryTVCell: UITableViewCell {
    @IBOutlet weak var reOrderBtn: UIButton!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var restNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var restImage: UIImageView!
    var starRatingView: StarRatingView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        reOrderBtn.setRounded(cornerRadius: 4)
        rateBtn.setRounded(cornerRadius: 4)
        reOrderBtn.layer.borderWidth = 1
        reOrderBtn.layer.borderColor = themeBackgrounColor.cgColor
        rateBtn.layer.borderWidth = 1
        rateBtn.layer.borderColor = themeBackgrounColor.cgColor
        
        restImage.layer.cornerRadius = 10
        let size = UIScreen.main.bounds.size.width
        if size == 430.0 {
            //iphone plus
            starRatingView = StarRatingView(frame: CGRect(origin: .init(x: (self.bounds.size.width) - 85, y: self.bounds.size.height - 70), size: CGSize(width: 100, height: 40)), rating: 0.0, color: .gGray100, starRounding: .roundToHalfStar)
        }
        else if size == 440.0 {
            //iphone pro max
            starRatingView = StarRatingView(frame: CGRect(origin: .init(x: (self.bounds.size.width) - 75, y: self.bounds.size.height - 70), size: CGSize(width: 100, height: 40)), rating: 0.0, color: .gGray100, starRounding: .roundToHalfStar)

        }
        else if size == 402 {
            //iphone pro
            starRatingView = StarRatingView(frame: CGRect(origin: .init(x: (self.bounds.size.width) - 115, y: self.bounds.size.height - 70), size: CGSize(width: 100, height: 40)), rating: 0.0, color: .gGray100, starRounding: .roundToHalfStar)

        }
        else {
            starRatingView = StarRatingView(frame: CGRect(origin: .init(x: (self.bounds.size.width) - 125, y: self.bounds.size.height - 70), size: CGSize(width: 100, height: 40)), rating: 0.0, color: .gGray100, starRounding: .roundToHalfStar)
        }
        starRatingView.starColor = kOrangeColor
        starRatingView.rating = 0.0
        starRatingView.isUserInteractionEnabled = false
        self.contentView.addSubview(starRatingView)
    }
    func updateUI(order: HistoryOrder) {
        starRatingView.rating = Float(order.rating ?? "0.0") ?? 0.0
        restNameLbl.text = order.resturant
        addressLbl.text = order.type == "Pickup" ? order.pickup_address : order.address
        priceLbl.text = "\(UtilsClass.getCurrencySymbol())\(order.total)"
        dateLbl.text = order.date2
        let url = OldServiceType.restaurantImageUrl + order.img
        AF.request( url,method: .get).response{ response in
            switch response.result {
            case .success(let responseData):
                if responseData != nil {
                    self.restImage.image = UIImage(data: responseData!)
                    self.restImage.contentMode = .scaleToFill
                    if self.restImage.image == nil {
                        self.restImage.image = UIImage(named: "img_midium")
                        self.restImage.contentMode = .center
                    }
                }else {
                    self.restImage.image = UIImage(named: "img_midium")
                    self.restImage.contentMode = .center
                }
            case .failure(let error):
                self.restImage.image = UIImage(named: "img_midium")
                self.restImage.contentMode = .center
            }
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
