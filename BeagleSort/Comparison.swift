//
//  Comparison.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 13/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class Comparison: AlgorithmStep {
    public var indexA: Int!
    public var indexB: Int!
    public var valueA: Int!
    public var valueB: Int!
    public var sign: String!
    
    init(indexA: Int, indexB: Int, valueA: Int, valueB: Int, sign: String) {
        self.indexA = indexA
        self.indexB = indexB
        self.valueA = valueA
        self.valueB = valueB
        self.sign = sign
    }
}
