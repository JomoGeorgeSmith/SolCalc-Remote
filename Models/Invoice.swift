//
//  Invoice.swift
//  SolCalc
//
//  Created by Jomo Smith on 9/23/22.
//

import Foundation

struct InvoiceGenerator: Codable {
    var logo: String
    var from: String
    var to:String
    var items: [Items]
    var currency: String
}



struct Items : Codable {
    var name: String
    var quantity: Double
    var unit_cost: Double
}




