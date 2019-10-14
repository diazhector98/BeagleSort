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
    public var sign: String!
    
    init(indexA: Int, indexB: Int, sign: String) {
        self.indexA = indexA
        self.indexB = indexB
        self.sign = sign
    }
}
