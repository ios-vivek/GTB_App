//
//  FoodTypeTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 10/08/24.
//

import UIKit
protocol MenuTypeSelectedDelegate {
    func selectedMenuType(menuType: Int)
}

class FoodTypeTVCell: UITableViewCell {
    @IBOutlet weak var menu1: UIButton!
    @IBOutlet weak var menu2: UIButton!
    @IBOutlet weak var menu3: UIButton!
    @IBOutlet weak var menu4: UIButton!
    @IBOutlet weak var menus: UISegmentedControl!
    var delegate: MenuTypeSelectedDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        menus.selectedSegmentTintColor = themeBackgrounColor

        menu1.setRounded(cornerRadius: 5)
        menu2.setRounded(cornerRadius: 5)
        menu3.setRounded(cornerRadius: 5)
        menu4.setRounded(cornerRadius: 5)
        menu1.isHidden = true
        menu2.isHidden = true
        menu3.isHidden = true
        menu4.isHidden = true
        menu1.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        menu2.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        menu3.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        menu4.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)

        menus.addTarget(self, action: #selector(menuControlValueChanged(_:)), for: .valueChanged)
        self.backgroundColor = .white

    }
    @objc func menuControlValueChanged(_ sender: UISegmentedControl) {
        self.delegate?.selectedMenuType(menuType: sender.selectedSegmentIndex)
    }
    @objc func buttonTapped(sender : UIButton) {
       // self.delegate?.selectedMenuType(menuType: (sender.titleLabel?.text)!)
                }
    func updateUI(menuType: [String] , selectedMenu: Int) {
//        if !Cart.shared.tempRestDetails.ordertypes.contains("Catering"){
//            self.menus.setEnabled(false, forSegmentAt: 1)
//    }

        self.menus.selectedSegmentIndex = selectedMenu
        menu1.backgroundColor = .gGray100
        menu2.backgroundColor = .gGray100
        menu3.backgroundColor = .gGray100
        menu4.backgroundColor = .gGray100
        menu1.titleLabel?.textColor = .black
        menu2.titleLabel?.textColor = .black
        menu3.titleLabel?.textColor = .black
        menu4.titleLabel?.textColor = .black
        for (index, item) in menuType.enumerated() {
            if index == 0 {
                menu1.setTitle(item, for: .normal)
                menu1.isHidden = false
                if selectedMenu == 0 {
                    menu1.backgroundColor = themeBackgrounColor
                    menu1.setTitleColor(.white, for: .normal)
                }
            }
            if index == 1 {
                menu2.setTitle(item, for: .normal)
                menu2.isHidden = false
                if selectedMenu == 1 {
                    menu2.backgroundColor = themeBackgrounColor
                    menu2.setTitleColor(.white, for: .normal)
                }
            }
            if index == 2 {
                menu3.setTitle(item, for: .normal)
                menu3.isHidden = false
                if selectedMenu == 2 {
                    menu3.backgroundColor = themeBackgrounColor
                    menu3.setTitleColor(.white, for: .normal)
                }
            }
            if index == 3 {
                menu4.setTitle(item, for: .normal)
                menu4.isHidden = false
                if selectedMenu == 3 {
                    menu4.backgroundColor = themeBackgrounColor
                    menu4.setTitleColor(.white, for: .normal)
                }
            }
        }
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
