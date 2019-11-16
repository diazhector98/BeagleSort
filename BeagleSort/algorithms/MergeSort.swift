//
//  MergeSort.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 02/11/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import Foundation

import UIKit

class MergeSort {
    public static var instance: Algorithm!;
    
    public static func create() -> Void {
        instance = Algorithm(name: "MergeSort", image: UIImage(named: "merge-icon")!);
        instance.averageCase = "O(nlog(n))";
        instance.worstCase = "O(nlog(n))";
        instance.spaceComplexity = "O(n)";
        instance.implementation =
        """
        void merge(arr , start, mid, end) {
            p = start ,q = mid+1;
            tempArr[end-start+1] , k=0;
            for(i = start ;i <= end ;i++) {
                if(p > mid)
                    tempArr[ k++ ] = arr[ q++] ;
                else if ( q > end)
                    tempArr[ k++ ] = arr[ p++ ];
                else if( arr[ p ] < arr[ q ])
                    tempArr[ k++ ] = arr[ p++ ];
                else
                    tempArr[ k++ ] = arr[ q++];
            }
            for (p=0 ; p< k ;p ++) {
                arr[ start++ ] = tempArr[ p ] ;
            }
        }
        
        void merge_sort (arr, start ,end ) {
            if( start < end ) {
                mid = (start + end ) / 2 ;
                merge_sort (arr, start , mid ) ;
                merge_sort (arr,mid+1 , end ) ;
                merge(arr,start , mid , end );
            }
        }
        """;
    }
}
