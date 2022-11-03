//
//  LatestListingModal.swift
//  TradeMe
//
//  Created by ankita khare on 04/11/22.
//

import Foundation

struct LatestListingModel : Codable {
    
    var Title = ""
    var PriceDisplay = ""
    var BuyNowPrice = ""
    var Region = ""
    var PictureHref = ""
    var IsClassified = false
    
    init(dict: [String:Any]) {
        
        self.Title = dict["Title"] as? String ?? ""
        self.PriceDisplay = dict["PriceDisplay"] as? String ?? ""
        self.BuyNowPrice = dict["BuyNowPrice"] as? String ?? ""
        self.Region = dict["Region"] as? String ?? ""
        self.PictureHref = dict["PictureHref"] as? String ?? ""
        self.IsClassified = dict["IsClassified"] as? Bool ?? false
    }
}
