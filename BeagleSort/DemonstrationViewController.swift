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
    var arrayViewsDictionary: [Int: UIView]!
    var algorithmAnimation: AlgorithmAnimation!
    
    
    
    //TableView
    @IBOutlet weak var tableView: UITableView!
    var comparisons: [Comparison]!
    
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
        comparisons = []
        
    }
    
    //Se deben hacer las animaciones con este método (que corre después de viewDidLoad), cuando ya están establecidos los frames
    //de los números
    override func viewDidAppear(_ animated: Bool) {
        animateTransitions()
    }
    
    func generateNumViews(arr: [Int]) -> [UIView] {
        arrayViewsDictionary = [:]
        var views: [UIView] = []
        var index = 0
        for _ in arr {
            //Crear la vista contenedor del numero y agregar propiedades
            let numView = UIView()
            numView.layer.cornerRadius = 10
            numView.layer.shadowColor = UIColor.black.cgColor
            numView.layer.shadowOpacity = 0.2
            numView.layer.shadowOffset = CGSize(width: -1, height: 1)
            numView.layer.shadowRadius = 1

            numView.backgroundColor = .white
            //Agregar la vista al arreglo
            views.append(numView)
            //Agregar la vista al diccionario de vistas(index, view)
            arrayViewsDictionary[index] = numView
            index += 1
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
            
            //Hacer hidden las view que se van a mover
            let originalViewA = arrayViewsDictionary[indexA]
            let originalViewB = arrayViewsDictionary[indexB]
            
            disappearView(vista: originalViewA!)
            disappearView(vista: originalViewB!)
            
            
            //Obtener los frames de esos elementos
            let frameA: CGRect = numViews[indexA].frame
            let frameB: CGRect = numViews[indexB].frame
            
            //Crear views con esos frames
            let viewA = UIView(frame: frameA)
            let viewB = UIView(frame: frameB)
            viewA.backgroundColor = .blue
            viewB.backgroundColor = .blue
            
            viewA.layer.cornerRadius = 10
            viewA.layer.shadowColor = UIColor.black.cgColor
            viewA.layer.shadowOpacity = 0.2
            viewA.layer.shadowOffset = CGSize(width: -1, height: 1)
            viewA.layer.shadowRadius = 1
            
            viewA.backgroundColor = .white
            
            viewB.layer.cornerRadius = 10
            viewB.layer.shadowColor = UIColor.black.cgColor
            viewB.layer.shadowOpacity = 0.2
            viewB.layer.shadowOffset = CGSize(width: -1, height: 1)
            viewB.layer.shadowRadius = 1
            
            viewB.backgroundColor = .white
            
            
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
            
            //Updatear el diccionario de views (deben ser al reves por el swap que se hace despues)
            arrayViewsDictionary[indexA] = viewB
            arrayViewsDictionary[indexB] = viewA
            
            
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
                        //Campiar los números en el arreglo original y hacer la siguiente transicion
                        let temp = self.array[indexA]
                        self.array[indexA] = self.array[indexB]
                        self.array[indexB] = temp
                        
                        self.animateTransitionsHelper(animIndex: animIndex + 1)
                    })
                    
                })
                
            }
        } else if let c = algorithmStep as? Comparison {
            comparisons.append(c)
            tableView.reloadData()
            let indexA = c.indexA
            let indexB = c.indexB
            
            let viewA = arrayViewsDictionary[indexA!]
            let viewB = arrayViewsDictionary[indexB!]
            
            viewA?.backgroundColor = UIColor(red:0.31, green:0.78, blue:0.65, alpha:1.0)
            viewB?.backgroundColor = UIColor(red:0.31, green:0.78, blue:0.65, alpha:1.0)
            
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                viewA?.backgroundColor = .blue
                viewB?.backgroundColor = .blue
                self.animateTransitionsHelper(animIndex: animIndex + 1)
            }
        } else if let merge = algorithmStep as? Merge {
            var originalViews: [UIView] = []
            var i = merge.start!
            
            /*
            
             Desaparecer las views del merge
 
            */
            while(i <= merge.end){
                originalViews.append(arrayViewsDictionary[i]!)
                i += 1
            }
            for originalView in originalViews {
                disappearView(vista: originalView)
            }
            /*
 
            Crear views de los números del merge
 
            */
            
            //Obtener frames
            var numberFrames: [CGRect] = []
            i = merge.start!
            while(i <= merge.end!){
                numberFrames.append(numViews[i].frame)
                i += 1
            }
            
            //Crear views con esos frames
            var arrayIndex = merge.start!
            var numberViews: [UIView] = []
            for frame in numberFrames {
                let vista = UIView(frame: frame)
                vista.backgroundColor = .blue
                
                vista.layer.cornerRadius = 10
                vista.layer.shadowColor = UIColor.black.cgColor
                vista.layer.shadowOpacity = 0.2
                vista.layer.shadowOffset = CGSize(width: -1, height: 1)
                vista.layer.shadowRadius = 1
                
                vista.backgroundColor = .white
                
                //Crear labels
                let label = UILabel()
                label.text = "\(array[arrayIndex])"
                label.textColor = .black
                label.textAlignment = .center
                label.translatesAutoresizingMaskIntoConstraints = false
                
                vista.addSubview(label)
                
                label.centerXAnchor.constraint(equalTo: vista.centerXAnchor).isActive = true
                label.centerYAnchor.constraint(equalTo: vista.centerYAnchor).isActive = true
                
                vista.heightAnchor.constraint(equalTo: vista.widthAnchor).isActive = true
                
                stackView.addSubview(vista)
                numberViews.append(vista)
                arrayIndex += 1
            }
            
            //Animar las views
            UIView.animate(withDuration: 1, animations: {
                for vista in numberViews {
                    vista.frame.origin.y += vista.frame.size.height + 18
                }
            }) { (true) in
                self.handleMergeSteps(merge: merge, numberViews: numberViews, mergeStepIndex: 0, animIndex: animIndex)
            }
        } else if let pivotSelection = algorithmStep as? PivotSelection {
            let pivotView = arrayViewsDictionary[pivotSelection.index]
            UIView.animate(withDuration: 1, animations: {
                pivotView?.backgroundColor = .red
            }) { (true) in
                self.animateTransitionsHelper(animIndex: animIndex + 1)
            }
        }
    }
    
    func handleMergeSteps(merge: Merge, numberViews: [UIView], mergeStepIndex: Int, animIndex: Int){
        if (mergeStepIndex >= merge.steps.count){
            self.animateTransitionsHelper(animIndex: animIndex + 1)
            return
        }
        
        let algoStep = merge.steps[mergeStepIndex]
        
        if let comparison = algoStep as? Comparison {
            
            let indexA = comparison.indexA
            let indexB = comparison.indexB
            
            UIView.animate(withDuration: 1, animations: {
                let vistaA = numberViews[indexA! - merge.start]
                let vistaB = numberViews[indexB! - merge.start]
                
                vistaA.backgroundColor = .red
                vistaB.backgroundColor = .red
            }) { (true) in
                
                UIView.animate(withDuration: 1, animations: {
                    let vistaA = numberViews[indexA! - merge.start]
                    let vistaB = numberViews[indexB! - merge.start]
                    
                    vistaA.backgroundColor = .white
                    vistaB.backgroundColor = .white
                }, completion: { (true) in
                    self.handleMergeSteps(merge: merge, numberViews: numberViews, mergeStepIndex: mergeStepIndex + 1, animIndex: animIndex)
                    
                })
            }
            
        } else if let insertion = algoStep as? Insertion {
            let fromIndex = insertion.fromIndex
            let toIndex = insertion.toIndex
            
            UIView.animate(withDuration: 1, animations: {
                
                let vista = numberViews[fromIndex!-merge.start]
                vista.frame = self.numViews[toIndex!].frame
                self.array[toIndex!] = insertion.value
                self.arrayViewsDictionary[toIndex!] = vista
                
            }) { (true) in
                self.handleMergeSteps(merge: merge, numberViews: numberViews, mergeStepIndex: mergeStepIndex + 1, animIndex: animIndex)
            }
        }
    }
    
    func disappearView(vista: UIView) {
        vista.backgroundColor = .clear
        for sv in vista.subviews {
            sv.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comparisons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let comparison = comparisons[indexPath.row]
        cell.textLabel?.text = "if \(comparison.valueA!) \(comparison.sign!) \(comparison.valueB!) \n {\n}"
        
        //Si es la comparacion que se esta haciendo actualmente, cambiar estilo un poco
        if (indexPath.row == comparisons.count-1) {
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.backgroundColor = UIColor(red:0.31, green:0.78, blue:0.65, alpha:1.0)
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
            cell.backgroundColor = .white
        }
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
