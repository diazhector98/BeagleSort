//
//  DemonstrationViewController.swift
//  BeagleSort
//
//  Created by Hector Díaz Aceves on 11/10/19.
//  Copyright © 2019 WichoInc. All rights reserved.
//

import UIKit

class DemonstrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Outlets
    @IBOutlet weak var grayView: UIView!
    
    //Pasados con segue
    var array: [Int]!
    var algorithm: Algorithm!
    
    
    //Obtenidos en viewDidLoad
    var stackView: UIStackView!
    var numViews: [UIView]!
    var algorithmAnimation: AlgorithmAnimation!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //generar el arreglo de las views para cada numero
        numViews = generateNumViews(arr: array)
        algorithmAnimation = AlgorithmAnimation(algorithm: algorithm, array: array)
        
        //crear la stack view con el arreglo de esas views (tal vez refactorar o ajustar coding standards aqui lol)
        stackView = UIStackView(arrangedSubviews: numViews)
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
        
        //tableview setup
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    //Se deben hacer las animaciones con este método (que corre después de viewDidLoad), cuando ya están establecidos los frames
    //de los números
    override func viewDidAppear(_ animated: Bool) {
        animateTransitions()
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
    
    func animateTransitions(){
        animateTransitionsHelper(animIndex: 0)
    }
    
    //Este método pone los cuadritos verdes y rojos sobre la stackview
    //To be removed...
    func animateTransitionsHelper(animIndex: Int) {
        
        
        if animIndex >= algorithmAnimation.steps.count {
            return
        }
        
        //Animate here
        let algorithmStep: AlgorithmStep = algorithmAnimation.steps[animIndex]
        
        if let t = algorithmStep as? Transition {
            //Obtener los indices de los elementos a mover
            let indexA: Int = t.fromIndex
            let indexB: Int = t.toIndex
            
            //Obtener los frames de esos elementos
            let frameA: CGRect = numViews[indexA].frame
            let frameB: CGRect = numViews[indexB].frame
            
            //Crear views con esos frames
            let viewA = UIView(frame: frameA)
            let viewB = UIView(frame: frameB)
            
            //Hacer su background diferente para que se vean por lo pronto
            viewA.backgroundColor = .red
            viewB.backgroundColor = .green
            
            // Agregar labels a las nuevas views
            let labelA = UILabel()
            let labelB = UILabel()
            labelA.text = "\(t.fromValue!)"
            labelB.text = "\(t.toValue!)"
            labelA.textColor = .black
            labelB.textColor = .black
            labelA.textAlignment = .center
            labelB.textAlignment = .center
            //translatesAutoresizingMaskIntoConstraints es importante hacer
            labelA.translatesAutoresizingMaskIntoConstraints = false
            labelB.translatesAutoresizingMaskIntoConstraints = false
            //Agregar label al view antes de poner constraints..
            viewA.addSubview(labelA)
            viewB.addSubview(labelB)
            //Agregar constraints
            labelA.centerYAnchor.constraint(equalTo: viewA.centerYAnchor).isActive = true
            labelB.centerYAnchor.constraint(equalTo: viewB.centerYAnchor).isActive = true
            labelA.centerXAnchor.constraint(equalTo: viewA.centerXAnchor).isActive = true
            labelB.centerXAnchor.constraint(equalTo: viewB.centerXAnchor).isActive = true
            
            viewA.heightAnchor.constraint(equalTo: viewA.widthAnchor).isActive = true
            viewB.heightAnchor.constraint(equalTo: viewB.widthAnchor).isActive = true
            
            
            //Agregar views a stackview (esto es importante ya que las coordenadas estan con respecto a
            //la stackview y no a la super view
            stackView.addSubview(viewA)
            stackView.addSubview(viewB)
            
            
            UIView.animate(withDuration: 1, animations: {
                
                //Mover los cuadros verticalmente
                viewA.frame.origin.y += viewA.frame.size.height + 10
                viewB.frame.origin.y -= viewA.frame.size.height + 10
                
            }) { (true) in
                
                UIView.animate(withDuration: 1, animations: {
                    //Mover los cuadros horizontalmente
                    let xPosA = viewA.frame.origin.x
                    let xPosB = viewB.frame.origin.x
                    
                    viewA.frame.origin.x = xPosB
                    viewB.frame.origin.x = xPosA
                    
                    
                }, completion: { (true) in
                    //Mover los cuadros verticalment de nuevo...
                    
                    UIView.animate(withDuration: 1, animations: {
                        viewA.frame.origin.y -= viewA.frame.size.height + 10
                        viewB.frame.origin.y += viewA.frame.size.height + 10
                    }, completion: { (true) in
                        //Hacer la siguiente transicion
                        self.animateTransitionsHelper(animIndex: animIndex + 1)
                    })
                    
                })
                
            }
        } else if let c = algorithmStep as? Comparison {
            self.animateTransitionsHelper(animIndex: animIndex + 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        cell.textLabel?.text = "if 12 < 13 ..."
        return cell
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
