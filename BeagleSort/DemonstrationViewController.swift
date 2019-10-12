//
//  DemonstrationViewController.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 11/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class DemonstrationViewController: UIViewController {

    
    @IBOutlet weak var grayView: UIView!
    
    var array: [Int]!
    var algorithm: Algorithm!
    
    
    var algorithmAnimation: AlgorithmAnimation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //generar el arreglo de las views para cada numero
        let numViews = generateNumViews(arr: array)
        
        //crear la stack view con el arreglo de esas views (tal vez refactorar o ajustar coding standards aqui lol)
        let stackView = UIStackView(arrangedSubviews: numViews)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //Agregar stackview a la vista gris
        grayView.addSubview(stackView)
        
        //Agregar constrainst de la stack
        let viewsDictionary = ["stackView":stackView]
        let stackView_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[stackView]-20-|",  //horizontal constraint 20 points from left and right side
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary)
        
        let stackView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-30-[stackView]-30-|", //vertical constraint 30 points from top and bottom
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary)
        
        grayView.addConstraints(stackView_H)
        grayView.addConstraints(stackView_V)
        
        
        //Por cada view de números, agregar la label del número
        var i = 0
        for numView in numViews {
            //Crear label y ajustar propiedades
            let numLabel = UILabel()
            numLabel.text = "\(array[i])"
            numLabel.textColor = .black
            numLabel.textAlignment = .center
            //translatesAutoresizingMaskIntoConstraints es importante hacer
            numLabel.translatesAutoresizingMaskIntoConstraints = false
            //Agregar label al view antes de poner constraints..
            numView.addSubview(numLabel)
            //Agregar constraints
            numLabel.centerYAnchor.constraint(equalTo: numView.centerYAnchor).isActive = true
            numLabel.centerXAnchor.constraint(equalTo: numView.centerXAnchor).isActive = true
            
            numView.heightAnchor.constraint(equalTo: numView.widthAnchor).isActive = true
            i += 1
        }
        
    }
    
    func generateNumViews(arr: [Int]) -> [UIView] {
        var views: [UIView] = []
        for _ in arr {
            //Crear la vista contenedor del numero y agregar propiedades
            let numView = UIView()
            numView.backgroundColor = .blue
            //Agregar la vista al arreglo
            views.append(numView)
        }
        return views
    }
    
    func animateTransition(transition: Transition) {
        //Animate here
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
