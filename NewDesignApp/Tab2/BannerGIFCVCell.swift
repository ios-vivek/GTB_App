//
//  NearYouCollectionViewCell.swift
//  GTB DUBAI
//
//  Created by Omnie Solutions on 02/02/23.
//

import UIKit
import Alamofire
//import SkeletonView
class BannerGIFCVCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var view1: UIView!



    override func awakeFromNib() {
//        [foodImage,restName,deliveryTimeLbl,foodTypeImage].forEach{
//            $0?.isSkeletonable = true
//        }
//        [foodImage,restName,deliveryTimeLbl,foodTypeImage].forEach{
//            $0?.showAnimatedGradientSkeleton()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
//            self.hideSkeletonCell()
//        }
       // let imageView = UIImageView(frame: CGRectMake(0, 0, 100, 100))
       // updateUI()
       
    }
    func hideSkeletonCell(){
//        [foodImage,restName,deliveryTimeLbl,foodTypeImage].forEach{
//            $0?.hideSkeleton()
//        }
    }
   
    func updateUI(imageurl: String) {
       // gifImage.image = UIImage.init(named: "restaurant")
        gifImage.contentMode = .scaleToFill
        gifImage.layer.cornerRadius = 10
        
        let url = imageurl//"https://www.grabull.com//web-api//images//banner-img.jpg"
        AF.request( url,method: .get).response{ response in

          switch response.result {
           case .success(let responseData):
              self.gifImage.image = UIImage(data: responseData!, scale:1)
           case .failure(let error):
               print("error--->",error)
           }
       }
        view1.backgroundColor = themeBackgrounColor
        view1.layer.cornerRadius = 10
        view1.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.backgroundColor = .white
    }
  
}
