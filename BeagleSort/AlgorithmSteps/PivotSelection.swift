//
//  PivotSelection.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 13/11/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class PivotSelection: AlgorithmStep {
    public var index: Int!
    public var value: Int!
    
    init(index: Int, value: Int) {
        self.index = index
        self.value = value
    }
}
