//
//  Beverages.swift
//  BruRestaurant
//
//  Created by Simon Mc Neil on 2018-11-25.
//  Copyright © 2018 Simon Mc Neil. All rights reserved.
//

import Foundation

class Beverages {
    
    var desctription: String
    var image: String
    var title: String
    
    init(dictionary: [String: AnyObject]) {
        self.title = dictionary["Title"] as! String
        self.desctription = dictionary["Description"] as! String
        self.image = dictionary["Image"] as! String
    }
}
