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
        self.steps = []
        calculateTransitions()
    }
    
    func calculateTransitions() {
        let algorithmName = algorithm.name
        switch(algorithmName) {
        case "BubbleSort":
            initBubbleSortTransitions()
        case "MergeSort":
            initMergeSortTransitions()
        case "InsertionSort":
            initInsertionSortTransitions()
        case "QuickSort":
            initQuickSortTransitions()
        case .none:
            print("What")
        case .some(_):
            print("What")
        }
    }
    
    func initBubbleSortTransitions() {
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
    
    
    func initInsertionSortTransitions() {
        var curr = 1
        let n = array.count
        while(curr < n) {
            var c = curr-1
            let firstComparison = Comparison(indexA: c, indexB: c+1, valueA: array[c], valueB: array[c+1], sign: ">")
            steps.append(firstComparison)
            while(c >= 0 && array[c] > array[c+1]){
                let loopComparison = Comparison(indexA: c, indexB: c+1, valueA: array[c], valueB: array[c+1], sign: ">")
                if (c != curr-1){
                    //Add loop comparison if it's not the first one
                    steps.append(loopComparison)
                }
                //swap
                let swap = Transition(from: c+1, to: c, fromValue: array[c+1], toValue: array[c])
                steps.append(swap)
                let temp = array[c+1]
                array[c+1] = array[c]
                array[c] = temp
                c -= 1
            }
            curr += 1
        }
    }
    
    
    func merge(start: Int, middle: Int, end: Int) {
        
        var mergeSteps: [AlgorithmStep] = []
        /*

         TAMBIEN PUEDE QUE ESTE MAL, NO PROBADO
         */
        
        var arrA: [Int] = []
        var arrB: [Int] = []
        
        //Constructing array A from start to middle
        
        var i = start
        while(i <= middle) {
            arrA.append(array[i])
            i += 1
        }
        //Constructing array B from middle + 1 to end
        i = middle + 1
        while(i <= end){
            arrB.append(array[i])
            i += 1
        }
        //Constructing new array from both
        var currA = 0
        var currB = 0
        var curr = start
        
        while(currA < arrA.count && currB < arrB.count) {
            let comparison = Comparison(indexA: currA + start, indexB: currB + middle + 1, valueA: arrA[currA], valueB: arrB[currB], sign: "<")
            var insertion: Insertion
            if (arrA[currA] < arrB[currB]){
                array[curr] = arrA[currA]
                insertion = Insertion(fromIndex: currA + start, toIndex: curr, value: arrA[currA])
                currA += 1
            } else {
                array[curr] = arrB[currB]
                insertion = Insertion(fromIndex: currB + middle + 1, toIndex: curr, value: arrB[currB])
                currB += 1
            }
            mergeSteps.append(comparison)
            mergeSteps.append(insertion)
            curr += 1
        }
        
        while(currA < arrA.count){
            array[curr] = arrA[currA]
            let insertion = Insertion(fromIndex: currA+start, toIndex: curr, value: arrA[currA])
            mergeSteps.append(insertion)
            currA += 1
            curr += 1
        }
        
        while(currB < arrB.count){
            array[curr] = arrB[currB]
            let insertion = Insertion(fromIndex: currB+middle+1, toIndex: curr, value:  arrB[currB])
            mergeSteps.append(insertion)
            currB += 1
            curr += 1
        }
        let merge = Merge(start: start, middle: (start+end)/2, end: end, steps: mergeSteps)
        steps.append(merge)
    }
    
    func MergeSort(startIndex: Int, endIndex: Int){
        if (startIndex < endIndex){
            let middle = (startIndex + endIndex) / 2
            MergeSort(startIndex: startIndex, endIndex: middle)
            MergeSort(startIndex: middle+1, endIndex: endIndex)
            merge(start: startIndex, middle: middle, end: endIndex)
        }
    }
    
    func initMergeSortTransitions(){
        MergeSort(startIndex: 0, endIndex: array.count-1)
    }
    
    
    func QuickSort(startIndex: Int, endIndex: Int){
        
        if (startIndex > endIndex){
            return;
        }
        //Pivot Selection
        let pivot = array[startIndex]
        steps.append(PivotSelection(index: startIndex, value: pivot))
        var left = startIndex + 1
        var right = endIndex
        while(left <= right){
            //Comparison of both left and right pointers
            steps.append(Comparison(indexA: left, indexB: right, valueA: array[left], valueB: array[right], sign: " > pivot and pivot > "))
            if (array[left] > pivot && array[right] < pivot){
                
                //Swap of both pointers
                steps.append(Transition(from: left, to: right, fromValue: array[left], toValue: array[right]))
                let temp = array[left]
                array[left] = array[right]
                array[right] = temp
            }
            //Comparison of pivot and left
            steps.append(Comparison(indexA: left, indexB: startIndex, valueA: array[left], valueB: pivot, sign: "<="))
            if (array[left] <= pivot){
                left += 1;
            }
            //Comparison of pivot and right
            steps.append(Comparison(indexA: right, indexB: startIndex, valueA: array[right], valueB: pivot, sign: ">="))
            if (array[right] >= pivot){
                right -= 1;
            }
        }
        //Swap of right and pivot (if swapping with pivot, should DESELECT pivot in animation)
        steps.append(Transition(from: startIndex, to: right, fromValue: pivot, toValue: array[right]))
        array[startIndex] = array[right]
        array[right] = pivot
        
        QuickSort(startIndex: startIndex, endIndex: right-1)
        QuickSort(startIndex: right+1, endIndex: endIndex)
        
    }
    func initQuickSortTransitions(){
        QuickSort(startIndex: 0, endIndex: array.count-1)
    }
    
    func initSelectionSort(){
        let n = array.count;        
        for i in 0...n-1{
            var minimum = i
            for j in i + 1 ... n-1 {
                if (array[j] < array[minimum]){
                    minimum = j
                }
            }
            let temp = array[i]
            array[i] = array[minimum]
            array[minimum] = temp
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
