//
//  HttpMethod.swift
//  GoKaliningrad
//
//  Created by Admin on 20.09.2021.
//

import Foundation

public enum HTTPMethod : CustomStringConvertible {
    case Get
    case PostFormData
    case PostJson
    case PostMultipartFormData
    
    public var description: String {
        switch self {
            case .Get: return "GET"
            case .PostFormData, .PostJson, .PostMultipartFormData: return "POST"
        }
    }
}
