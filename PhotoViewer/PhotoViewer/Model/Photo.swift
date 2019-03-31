//
//  Photo.swift
//  PhotoViewer
//
//  Created by admin on 3/30/19.
//  Copyright © 2019 Alexey Sen. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Photo {
    var smallImage: String
    var bigImage: String
    
    init?(json: JSON) {
        guard let urlQ = json["url_q"].string,
            let urlZ = json["url_z"].string else {
                return nil
        }
        
        self.smallImage = urlQ
        self.bigImage = urlZ
    }
}



















