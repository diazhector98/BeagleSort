//
//  QuickSort.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 13/11/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import Foundation

import UIKit

class QuickSort {
    public static var instance: Algorithm!;
    
    public static func create() -> Void {
        instance = Algorithm(name: "QuickSort", image: UIImage(named: "quick-icon")!);
        instance.averageCase = "O(nlg(n))";
        instance.worstCase = "O(n^2)";
        instance.spaceComplexity = "O(nlgn)";
        instance.implementation =
        """
        int partition (arr, start , end) {
            i = start + 1;
            piv = arr[start] ;
                for(j =start + 1; j <= end ; j++ )  {
                if ( arr[ j ] < piv) {
                    swap (arr[ i ],arr[ j ]);
                    i += 1;
                }
            }
            swap ( arr[ start ] ,arr[ i-1 ] ) ;
            return i-1;
        }
        
        void quick_sort (arr, start, end ) {
            if( start < end ) {
                int piv_pos = partition (arr,start , end ) ;
                quick_sort (arr,start , piv_pos - 1);
                quick_sort ( arr,piv_pos +1 , end) ;
            }
        }
        """;
    }
}
