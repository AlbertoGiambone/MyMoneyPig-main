//
//  Models.swift
//  MyMoneyPig
//
//  Created by Alberto Giambone on 08/02/21.
//

import Foundation

struct conto {
    
    var UID: String
    var subject: String
    var BillDate: String
    var amount: String
    var docID: String
    var sign: String
    
    var dict: [String: String] {
    return [
    
        "UID": UID,
        "subject": subject,
        "Bill date": BillDate,
        "amount": amount,
        "docID": docID,
        "sign": sign
        ]
    }
    
}
