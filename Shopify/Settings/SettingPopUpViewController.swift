//
//  SettingPopUpViewController.swift
//  Shopify
//
//  Created by ezpenju on 2018-05-08.
//  Copyright © 2018 com.jpeng.go.shopify. All rights reserved.
//

import UIKit

class SettingPopUpViewController: UIViewController {

    @IBOutlet weak var yearBtn: UIButton!
    @IBOutlet weak var provinceBtn: UIButton!

    @IBOutlet weak var yearPanel: UIView!
    @IBOutlet weak var provincePanel: UIView!

    @IBOutlet weak var checkYear: UIImageView!
    @IBOutlet weak var checkProvince: UIImageView!

    var isOrderedByYear: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        updateFlag()
        yearPanel.layer.cornerRadius = 12
        provincePanel.layer.cornerRadius = 12
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didClose(_: Any) {
        saveSelection()
        if let bottomView = self.presentingViewController as? HomeViewController {
            let overlay = bottomView.blurEffectView
            bottomView.reloadOrders(isYear: isOrderedByYear, completion: {
                UIView.animate(withDuration: 0.25, animations: {
                    self.dismiss(animated: true, completion: nil)
                    overlay.alpha = 0
                }, completion: { _ in
                    overlay.removeFromSuperview()
                })
            })
        }
    }

    func saveSelection() {
        UserDefaults.standard.set(isOrderedByYear, forKey: Constants.keyOrderFlag)
    }

    func updateFlag() {

        if let flag = UserDefaults.standard.object(forKey: Constants.keyOrderFlag) as? Bool {
            isOrderedByYear = flag
        } else {
            // default: order by year
            isOrderedByYear = true
        }

        checkYear.isHidden = !isOrderedByYear
        checkProvince.isHidden = isOrderedByYear
    }

    @IBAction func didProBtnOnClick(_: Any) {

        checkProvince.alpha = 0
        checkYear.alpha = 1
        checkProvince.isHidden = false
        checkYear.isHidden = true

        UIView.animate(withDuration: 0.25, animations: {
            self.checkProvince.alpha = 1
            self.checkYear.alpha = 0
            self.isOrderedByYear = false
        }, completion: nil)
    }

    @IBAction func didYearOnClick(_: Any) {
        checkProvince.alpha = 1
        checkYear.alpha = 0
        checkProvince.isHidden = true
        checkYear.isHidden = false

        UIView.animate(withDuration: 0.25, animations: {
            self.checkProvince.alpha = 0
            self.checkYear.alpha = 1
            self.isOrderedByYear = true
        }, completion: nil)
    }
}
