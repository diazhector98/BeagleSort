//
//  AlgorithmAnimation.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 11/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit


class AlgorithmAnimation: NSObject {
    
    public var algorithm: Algorithm!
    public var array: [Int]!
    public var steps: [AlgorithmStep]!
    
    init(algorithm: Algorithm, array: [Int]) {
        super.init()
        self.algorithm = algorithm
        self.array = array
        calculateTransitions()
    }
    
    func calculateTransitions() {
        let algorithmName = algorithm.name
        switch(algorithmName) {
        case "BubbleSort":
            initBubbleSortTransitions()
        case .none:
            print("What")
        case .some(_):
            print("What")
        }
    }
    
    func initBubbleSortTransitions() {
        steps = []
        let n = array.count
        var i = n - 1
        while (i >= 1){
            for j in 0...i-1{
                let comparison = Comparison(indexA: j, indexB: j + 1, valueA: array[j], valueB: array[j+1], sign: ">")
                steps.append(comparison)
                if array[j] > array[j+1] {
                    let transition = Transition(from: j, to: j+1, fromValue: array[j], toValue: array[j+1])
                    steps.append(transition)
                    let temp = array[j]
                    array[j] = array[j+1]
                    array[j+1] = temp
                }
            }
            i = i - 1
        }
    }
    
    func printTransitions() {
        for step in steps {
            if let transition = step as? Transition {
                print("Swapping indices \(transition.fromIndex) and \(transition.toIndex)")
            }
        }
    }
    
}
