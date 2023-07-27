//
//  MainController.swift
//  AMaldonadoRecorcholis
//
//  Created by MacBookMBA15 on 25/07/23.
//

import UIKit
import SwipeCellKit

class MainController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var tvGeneral: UITableView!
    @IBOutlet weak var sbBuscar: UISearchBar!
    
    // MARK: Variables
    var paises: [Pais] = []
//    var idPais: Int? = nil
    var pais: Pais? = nil
    var searchRoot: RootSearch? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tvGeneral.dataSource = self
        tvGeneral.delegate = self
        tvGeneral.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        sbBuscar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GetAllPaises()
        if sbBuscar.text != "" {
            sbBuscar.text = ""
        }
    }
    
    // MARK: Funciones para obtener datos
    private func GetAllPaises() {
        PaisViewModel.GetAll { resultSource, errorSource in
            if resultSource!.Correct {
                self.CleanInfo()
                let root = resultSource!.Object as! Root<Pais>
                self.paises = root.results!
                print("Numero de paises: \(self.paises.count)")
                DispatchQueue.main.async {
                    self.tvGeneral.reloadData()
                }
            } else {
                let root = resultSource!.Object as! ServiceStatus
                DispatchQueue.main.async {
                    self.showDialog("Alerta", root.statusMessage!)
                }
            }
        }
    }

    private func showDialog(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Aceptar", style: .default)
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func CleanInfo() {
        self.paises.removeAll()
        self.searchRoot = nil
    }
}

// MARK: Extension UITableView
extension MainController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = searchRoot {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchRoot != nil {
            switch section {
            case 0:
                return "Paises"
            case 1:
                return "Estados"
            default:
                break
            }
        } else {
            return ""
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let root = searchRoot {
            switch section {
            // Seccion Paises
            case 0:
                if let results = root.paises {
                    if results.count > 0 {
                        return results.count
                    } else {
                        return 1
                    }
                }
            // Seccion Estados
            case 1:
                if let results = root.estados {
                    if results.count > 0 {
                        return results.count
                    } else {
                        return 1
                    }
                }
            default:
                break
            }
        } else {
            return paises.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        celda.delegate = self
        celda.selectionStyle = .none
        
        if let root = searchRoot {
            switch indexPath.section {
            // Seccion Paises
            case 0:
                if let results = root.paises {
                    if results.count > 0 {
                        celda.lblTitle.text = "\(indexPath.row + 1).- \(results[indexPath.row].Nombre)"
                        celda.lblTitle.textColor = .black
                        celda.backgroundColor = .white
                    } else {
                        celda.lblTitle.text = "No hay coincidencias!"
                        celda.delegate = nil
                        celda.lblTitle.textColor = .systemYellow.withAlphaComponent(1)
                        celda.backgroundColor = .systemYellow.withAlphaComponent(0.20)
                    }
                }
                break
            // Seccion Estados
            case 1:
                if let results = root.estados {
                    if results.count > 0 {
                        celda.lblTitle.text = "\(indexPath.row + 1).- \(results[indexPath.row].Nombre) \nPais: \(results[indexPath.row].Pais!)"
                        celda.lblTitle.textColor = .black
                        celda.backgroundColor = .white
                    } else {
                        celda.lblTitle.text = "No hay coincidencias!"
                        celda.delegate = nil
                        celda.lblTitle.textColor = .systemYellow.withAlphaComponent(1)
                        celda.backgroundColor = .systemYellow.withAlphaComponent(0.20)
                    }
                }
                break
            default:
                break
            }
        } else {
            celda.lblTitle.text = "\(indexPath.row + 1).- \(paises[indexPath.row].Nombre)"
            celda.lblTitle.textColor = .black
            celda.backgroundColor = .white
        }
        
        return celda
    }
    
    @objc
    func deletePais(_ sender: UIButton) {
        print("Eliminar pais")
        let pais = paises[sender.tag]
        PaisViewModel.Delete(pais.IdPais) { resultSource, errorSource in
            if resultSource!.Correct {
                let root = resultSource!.Object as! ServiceStatus
                if root.correct {
                    DispatchQueue.main.async {
                        self.showDialog("Operacion Correcta", root.statusMessage!)
                        self.GetAllPaises()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchRoot == nil {
            print("Pais: \(self.paises[indexPath.row])")
            self.pais = self.paises[indexPath.row]
            self.performSegue(withIdentifier: "toShowEstados", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identificador = segue.identifier!
        switch identificador {
        case "toShowEstados":
            let nextVC = segue.destination as! EstadosController
            nextVC.pais = self.pais
            break
        case "toFormPais":
            let nextVC = segue.destination as! PaisController
            nextVC.pais = self.pais
            break
        default:
            break
        }
    }
}

// MARK: Extension SearchBar
extension MainController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let nombre = searchBar.text!
        PaisViewModel.SearchByNombre(nombre) { resultSource, errorSource in
            if resultSource!.Correct {
                let rootSearch = resultSource!.Object as! RootSearch
                self.CleanInfo()
                self.searchRoot = rootSearch
                DispatchQueue.main.async {
                    self.tvGeneral.reloadData()
                }
            } else {
                let root = resultSource!.Object as! ServiceStatus
                DispatchQueue.main.async {
                    self.showDialog("Error", root.statusMessage!)
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            GetAllPaises()
        }
    }
}

// MARK: Extension Swipe Cell Kit
extension MainController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        // Update Action
        if orientation == .left {
            let updateAction = SwipeAction(style: .default, title: "Actualizar") { action, indexPath in
                print("Actualizar")
                if let rootSearch = self.searchRoot {
                    switch indexPath.section {
                    
                        // Paises
                    case 0:
                        if rootSearch.paises!.count > 0 {
                            self.pais = rootSearch.paises![indexPath.row]
                            self.performSegue(withIdentifier: "toFormPais", sender: self)
                        }
                        break
                        
                        // Estados
                    case 1:
                        if rootSearch.estados!.count > 0 {
                            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "toFormEstado") as! EstadoController
                            nextVC.fromMainController = true
                            nextVC.estado = rootSearch.estados![indexPath.row]
                            nextVC.modalPresentationStyle = .fullScreen
                            self.present(nextVC, animated: true)
                        }
                        break
                        
                    default:
                        break
                    }
                } else {
                    self.pais = self.paises[indexPath.row]
                    self.performSegue(withIdentifier: "toFormPais", sender: self)
                }
            }
            
            updateAction.backgroundColor = .systemBlue
            updateAction.image = UIImage(systemName: "pencil")
            
            return [updateAction]
        } else {
            let deleteAction = SwipeAction(style: .default, title: "Eliminar") { action, indexPath in
                print("Eliminar pais")
                let pais = self.paises[indexPath.row]
                PaisViewModel.Delete(pais.IdPais) { resultSource, errorSource in
                    if resultSource!.Correct{
                        let root = resultSource!.Object as! ServiceStatus
                        if root.correct {
                            DispatchQueue.main.async {
                                self.showDialog("Operacion Correcta", root.statusMessage!)
                                self.GetAllPaises()
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
