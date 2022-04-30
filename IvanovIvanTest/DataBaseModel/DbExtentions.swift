//
//  DbExtentions.swift
//  IvanovIvanTest
//
//  Created by Valery Dubovoy on 30.04.2022.
//

import Foundation

extension Banner {
    func fillWith( name: String, color: String, active: Bool ) {
        self.name = name
        self.color = color
        self.active = active
    }
}

extension Article {
    func fillWith( title: String, text: String ) {
        self.title = title
        self.text = text
    }
}
