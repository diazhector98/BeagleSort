//
//  Transition.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 13/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import Foundation

class Transition: AlgorithmStep {
    public var fromIndex: Int!
    public var toIndex: Int!
    public var fromValue: Int!
    public var toValue: Int!
    
    init(from: Int, to: Int, fromValue: Int, toValue: Int) {
        self.fromIndex = from
        self.toIndex = to
        self.fromValue = fromValue
        self.toValue = toValue
    }
}

