//
//  Insertion.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 02/11/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class Insertion: AlgorithmStep {
    public var fromIndex: Int!
    public var toIndex: Int!
    public var value: Int!

    init(fromIndex: Int, toIndex: Int, value: Int) {
        self.fromIndex = fromIndex
        self.toIndex = toIndex
        self.value = value
    }
}
