//
//  AlgorithmListViewController.swift
//  BeagleSort
//
//  Created by César Barraza on 10/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class AlgorithmListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private var algorithms = [Algorithm]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        // add algorithms
        self.algorithms.append(BubbleSort.instance)
        self.algorithms.append(MergeSort.instance)
        self.algorithms.append(InsertionSort.instance)
        self.algorithms.append(QuickSort.instance)
        self.algorithms.append(SelectionSort.instance)
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.algorithms.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "algorithmCell")! as! AlgorithmTableViewCell;
        let algorithm = self.algorithms[indexPath.row];
        
        cell.imgAlgorithm.image = algorithm.image;
        cell.lblAlgorithmName.text = algorithm.name;
        
        return cell;
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView = segue.destination as! AlgorithmViewController
        nextView.algorithm = algorithms[tableView.indexPathForSelectedRow!.row]
    }
}
