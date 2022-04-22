//
//  BannerModel.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 17.04.2022.
//

import Foundation

struct BannerModel: Decodable {
    let name: String
    let color: String
    let active: Bool
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case color = "color"
        case active = "active"
    }
    
    init( fromBanner banner: Banner){
        self.name = banner.name ?? ""
        self.color = banner.color ?? "#ffffff"
        self.active = banner.active
    }
    
    init( withName name: String, color: String, active: Bool) {
        self.name = name
        self.color = color
        self .active = active
    }
}
