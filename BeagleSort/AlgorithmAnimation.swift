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
    public var isAscending: Bool!
    
    init(algorithm: Algorithm, array: [Int], isAscending: Bool) {
        super.init()
        self.algorithm = algorithm
        self.array = array
        self.steps = []
        self.isAscending = isAscending
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
        case "SelectionSort":
            initSelectionSort()
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
                var sign: String!
                if (isAscending) {
                    sign = ">"
                } else {
                    sign = "<"
                }
                let comparison = Comparison(indexA: j, indexB: j + 1, valueA: array[j], valueB: array[j+1], sign: sign)
                steps.append(comparison)
                if (compare(actual: array[j], comparedTo: array[j+1])) {
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
            var firstSign: String!
            if (isAscending) {
                firstSign = ">"
            } else {
                firstSign = "<"
            }
            let firstComparison = Comparison(indexA: c, indexB: c+1, valueA: array[c], valueB: array[c+1], sign: firstSign)
            steps.append(firstComparison)
            while(c >= 0 && compare(actual: array[c], comparedTo: array[c+1])) {
                var secondSign: String!
                if (isAscending) {
                    secondSign = ">"
                } else {
                    secondSign = "<"
                }
                let loopComparison = Comparison(indexA: c, indexB: c+1, valueA: array[c], valueB: array[c+1], sign: secondSign)
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
            var sign: String!
            if (isAscending) {
                sign = "<"
            } else {
                sign = ">"
            }
            let comparison = Comparison(indexA: currA + start, indexB: currB + middle + 1, valueA: arrA[currA], valueB: arrB[currB], sign: sign)
            var insertion: Insertion
            if (isAscending) {
                if (arrA[currA] < arrB[currB]){
                    array[curr] = arrA[currA]
                    insertion = Insertion(fromIndex: currA + start, toIndex: curr, value: arrA[currA])
                    currA += 1
                } else {
                    array[curr] = arrB[currB]
                    insertion = Insertion(fromIndex: currB + middle + 1, toIndex: curr, value: arrB[currB])
                    currB += 1
                }
            } else {
                if (arrA[currA] > arrB[currB]){
                    array[curr] = arrA[currA]
                    insertion = Insertion(fromIndex: currA + start, toIndex: curr, value: arrA[currA])
                    currA += 1
                } else {
                    array[curr] = arrB[currB]
                    insertion = Insertion(fromIndex: currB + middle + 1, toIndex: curr, value: arrB[currB])
                    currB += 1
                }
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
    
    /*
     var shouldSwap = false
     if (isAscending) {
         if (array[left] > pivot && array[right] < pivot) {
             shouldSwap = true
         }
     } else {
         if (array[left] < pivot && array[right] > pivot) {
             shouldSwap = true
         }
     }
     */
    /*
     if (isAscending){
         if (array[left] <= pivot) {
             left += 1
         }
         if (array[right] >= pivot) {
             right -= 1
         }
     } else {
         if (array[left] >= pivot) {
             left += 1
         }
         if (array[right] <= pivot) {
             right -= 1
         }
     }
     */
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
            var sign: String!
            if (isAscending) {
                sign = " > pivot and pivot > "
            } else {
                sign = " < pivot and pivot < "
            }
            //Comparison of both left and right pointers
            steps.append(Comparison(indexA: left, indexB: right, valueA: array[left], valueB: array[right], sign: sign))
            var shouldSwap = false
            if (isAscending) {
                if (array[left] > pivot && array[right] < pivot) {
                    shouldSwap = true
                }
            } else {
                if (array[left] < pivot && array[right] > pivot) {
                    shouldSwap = true
                }
            }
            if (shouldSwap){
                
                //Swap of both pointers
                steps.append(Transition(from: left, to: right, fromValue: array[left], toValue: array[right]))
                let temp = array[left]
                array[left] = array[right]
                array[right] = temp
            }
            //Comparison of pivot and left
            var signLeft: String!
            var signRight: String!
            if (isAscending) {
                signLeft = "<="
                signRight = ">="
            } else {
                signLeft = ">="
                signRight = "<="
            }
            steps.append(Comparison(indexA: left, indexB: startIndex, valueA: array[left], valueB: pivot, sign: signLeft))
            if (isAscending) {
                if (array[left] <= pivot){
                    left += 1;
                }
            } else {
                if (array[left] >= pivot) {
                    left += 1
                }
            }
            
            //Comparison of pivot and right
            steps.append(Comparison(indexA: right, indexB: startIndex, valueA: array[right], valueB: pivot, sign: signRight))
            if (isAscending) {
                if (array[right] >= pivot){
                    right -= 1;
                }
            } else {
                if (array[right] <= pivot) {
                    right -= 1
                }
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
            var j = i + 1
            while (j < n){
                var sign: String!
                if (isAscending) {
                    sign = "<"
                } else {
                    sign = ">"
                }
                steps.append(Comparison(indexA: j, indexB: minimum, valueA: array[j], valueB: array[minimum], sign: sign))
                if (isAscending) {
                    if (array[j] < array[minimum]) {
                        minimum = j
                    }
                } else {
                    if (array[j] > array[minimum]) {
                        minimum = j
                    }
                }
                j += 1
            }
            steps.append(Transition(from: i, to: minimum, fromValue: array[i], toValue: array[minimum]))
            let temp = array[i]
            array[i] = array[minimum]
            array[minimum] = temp
        }
    }
    
    func compare(actual: Int, comparedTo: Int) -> Bool {
        if (isAscending) {
            if (actual > comparedTo) {
                return true
            } else {
                return false
            }
        } else {
            if (actual < comparedTo) {
                return true
            } else {
                return false
            }
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
