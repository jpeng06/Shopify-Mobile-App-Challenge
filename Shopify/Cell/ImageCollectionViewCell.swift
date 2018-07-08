//
//  ImageCollectionViewCell.swift
//  Shopify
//
//  Created by ezpenju on 2018-05-08.
//  Copyright © 2018 com.jpeng.go.shopify. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var financial_status: UILabel!
    @IBOutlet weak var total_price: UILabel!
    @IBOutlet weak var shipping_address: UILabel!
    @IBOutlet weak var line_items_counts: UILabel!
    @IBOutlet weak var email_address: UILabel!
    @IBOutlet weak var customer_name: UILabel!
    @IBOutlet weak var created_date: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(name: String,
                 email: String,
                 address: String,
                 count: Int,
                 price: String,
                 date: String,
                 statue: String) {

        financial_status.text = statue.uppercased()
        total_price.text = "$\(price)"
        shipping_address.text = address
        line_items_counts.text = appendItemsString(itemCount: count)
        email_address.text = email
        customer_name.text = name
        created_date.text = formatDate(rawDate: date)
    }

    func formatDate(rawDate: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"

        if let date = dateFormatterGet.date(from: rawDate) {
            print(dateFormatterPrint.string(from: date))
            return dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
            return ""
        }
    }

    func appendItemsString(itemCount: Int) -> String {
        return (itemCount > 1) ? "\(itemCount) Items" : "\(itemCount) Item"
    }
}
