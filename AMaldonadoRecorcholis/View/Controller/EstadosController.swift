//
//  EstadosController.swift
//  AMaldonadoRecorcholis
//
//  Created by MacBookMBA15 on 26/07/23.
//

import UIKit
import SwipeCellKit

class EstadosController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var tvEstados: UITableView!
    @IBOutlet weak var lblPais: UILabel!
    
    // MARK: Variables
    var pais: Pais? = nil
    var estados: [Estado] = []
    var idEstado: Int? = nil
    var estado: Estado? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tvEstados.dataSource = self
        tvEstados.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        if let pais = pais {
            lblPais.text = pais.Nombre
            GetEstados(pais.IdPais)
        }
    }
    
    @IBAction func btnAgregar() {
        self.performSegue(withIdentifier: "toFormEstado", sender: self)
    }
    
    // MARK: Funciones privadas
    func GetEstados(_ idPais: Int) {
        EstadoViewModel.GetEstados(idPais) { resultSource, errorSource in
            self.estados.removeAll()
            if resultSource!.Correct {
                let root = resultSource!.Object as! Root<Estado>
                if root.results!.count > 0 {
                    self.estados = root.results!
                }
            }
            
            DispatchQueue.main.async {
                self.tvEstados.reloadData()
            }
        }
    }
    
    private func showDialog(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Aceptar", style: .default)
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        let backVC = self.presentingViewController as! MainController
        backVC.pais = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! EstadoController
        nextVC.idPais = self.pais!.IdPais
        if self.estado != nil {
            // Agregar el id del estado a actualizar
            nextVC.estado = self.estado
        }
    }
}

// MARK: Extension tableView
extension EstadosController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.estados.count > 0 {
            return self.estados.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        celda.delegate = self
        if self.estados.count != 0 {
            celda.lblTitle.text = "\(indexPath.row + 1).- \(self.estados[indexPath.row].Nombre)"
            celda.lblTitle.textColor = .black
            celda.backgroundColor = .white
        } else {
            celda.lblTitle.text = "No hay estados en el pais seleccionado!"
            celda.lblTitle.textColor = .systemYellow.withAlphaComponent(1)
            celda.backgroundColor = .systemYellow.withAlphaComponent(0.20)
            celda.delegate = nil
        }
        celda.selectionStyle = .none
        
        
        return celda
    }
}

// MARK: Extension SwipeCellKit
extension EstadosController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            let updateAction = SwipeAction(style: .default, title: "Actualizar") { action, indexPath in
                print("Actualizar estado")
                self.estado = self.estados[indexPath.row]
                self.performSegue(withIdentifier: "toFormEstado", sender: self)
            }
            
            updateAction.backgroundColor = .systemBlue
            updateAction.image = UIImage(systemName: "pencil")
            
            return [updateAction]
        } else {
            let deleteAction = SwipeAction(style: .default, title: "Eliminar") { action, indexPath in
                print("Eliminar estado")
                let estado = self.estados[indexPath.row]
                EstadoViewModel.Delete(estado.IdEstado) { resultSource, errorSource in
                    if resultSource!.Correct {
                        let root = resultSource!.Object as! ServiceStatus
                        if root.correct {
                            self.GetEstados(self.pais!.IdPais)
                            DispatchQueue.main.async {
                                self.showDialog("Operacion Correcta", root.statusMessage!)
                            }
                        }
                    } else {
                        let root = resultSource!.Object as! ServiceStatus
                        DispatchQueue.main.async {
                            self.showDialog("Error", root.statusMessage!)
                        }
                    }
                    
                    if let error = errorSource {
                        DispatchQueue.main.async {
                            self.showDialog("Error", error.localizedDescription)
                        }
                    }
                }
            }
            
            deleteAction.backgroundColor = .systemRed
            deleteAction.image = UIImage(systemName: "trash")
            
            return [deleteAction]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        
        options.expansionStyle = .selection
        options.transitionStyle = .border
        
        return options
    }
}
