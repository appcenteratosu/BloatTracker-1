//
//  Cattle.swift
//  JDRealHeatMap
//
//  Created by OSU App Center on 1/17/19.
//  Copyright © 2019 james12345. All rights reserved.
//

import Foundation
import Firebase

struct Cattle {
    let ref: DatabaseReference?
    var cattle_bloated: Int
    var cattle_dead: Int
    var cattle_Pasture: Int
//    var pasturetype: String
    
    init(cattle_bloated: Int, cattle_dead: Int, cattle_Pasture: Int) {
        self.ref = nil
        self.cattle_bloated = cattle_bloated
        self.cattle_dead = cattle_dead
        self.cattle_Pasture = cattle_Pasture
//        self.pasturetype = pasturetype
    }
    
    func toAnyObject() -> Any {
        return [
            "cattle_bloated": cattle_bloated,
            "cattle_dead": cattle_dead,
            "cattle_Pasture": cattle_Pasture,
//            "pasturetype": pasturetype
        ]
    }
}
