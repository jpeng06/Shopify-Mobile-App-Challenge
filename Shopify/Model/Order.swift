//
//  Order.swift
//  Shopify
//
//  Created by ezpenju on 2018-05-08.
//  Copyright © 2018 com.jpeng.go.shopify. All rights reserved.
//

import Foundation

class Order {
    var status: String
    var price: String
    var address: String
    var count: Int
    var email: String
    var name: String
    var date: String
    var year: Int
    var province: String
    var color: Int

    init() {
        status = ""
        price = ""
        address = ""
        count = 0
        email = ""
        name = ""
        date = ""
        year = 0
        province = ""
        color = 0
    }

    init(cName: String,
         cEmail: String,
         fAddress: String,
         iCount: Int,
         tPrice: String,
         cDate: String,
         fStatue: String,
         fYear: Int,
         cProvince: String,
         colorIndex: Int) {
        status = fStatue
        email = cEmail
        address = fAddress
        count = iCount
        price = tPrice
        date = cDate
        name = cName
        year = fYear
        province = cProvince
        color = colorIndex
    }
}
