//
//  MainController.swift
//  AMaldonadoRecorcholis
//
//  Created by MacBookMBA15 on 25/07/23.
//

import UIKit

class MainController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var tvGeneral: UITableView!
    @IBOutlet weak var sbBuscar: UISearchBar!
    
    // MARK: Variables
    var paises: [Pais] = []
    var idPais: Int? = nil
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
    }
    
    // MARK: Funciones para obtener datos
    private func GetAllPaises() {
        PaisViewModel.GetAll { responseSource, resultSource, errorSource in
            if let _ = responseSource {
                if resultSource!.Correct {
                    self.CleanInfo()
                    let root = resultSource!.Object as! Root<Pais>
                    self.paises = root.results!
                    print("Numero de paises: \(self.paises.count)")
                    DispatchQueue.main.async {
                        self.tvGeneral.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showDialog("Alerta", "No se encontro la información")
                    }
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
        if let root = searchRoot {
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
        let celda = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        celda.selectionStyle = .none
        
        if let root = searchRoot {
            switch indexPath.section {
            // Seccion Paises
            case 0:
                if let results = root.paises {
                    if results.count > 0 {
                        celda.lblTitle.text = "\(indexPath.row + 1).- \(results[indexPath.row].Nombre)"
                    } else {
                        celda.lblTitle.text = "No hay coincidencias!"
                    }
                    celda.btnDelete.removeFromSuperview()
                    celda.btnUpdate.removeFromSuperview()
                }
                break
            // Seccion Estados
            case 1:
                if let results = root.estados {
                    if results.count > 0 {
                        celda.lblTitle.text = "\(indexPath.row + 1).- \(results[indexPath.row].Nombre) \nPais: \(results[indexPath.row].Pais!)"
                    } else {
                        celda.lblTitle.text = "No hay coincidencias!"
                    }
                    celda.btnDelete.removeFromSuperview()
                    celda.btnUpdate.removeFromSuperview()
                }
                break
            default:
                break
            }
        } else {
            celda.lblTitle.text = "\(indexPath.row + 1).- \(paises[indexPath.row].Nombre)"
            celda.btnDelete.tag = indexPath.row
            celda.btnUpdate.tag = indexPath.row
            celda.btnUpdate.addTarget(self, action: #selector(updatePais), for: .touchUpInside)
        }
        
        return celda
    }
    
    @objc
    func updatePais(_ sender: UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchRoot == nil {
            print("Pais: \(self.paises[indexPath.row])")
            self.idPais = self.paises[indexPath.row].IdPais
            self.performSegue(withIdentifier: "toShowEstados", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identificador = segue.identifier!
        switch identificador {
        case "toShowEstados":
            let nextVC = segue.destination as! EstadosController
            nextVC.idPais = self.idPais
            break
        case "toFormPais":
            _ = segue.destination as! PaisController
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
        PaisViewModel.SearchByNombre(nombre) { responseSource, resultSource, errorSource in
            if let result = resultSource {
                let rootSearch = result.Object as! RootSearch
                if rootSearch.correct {
                    self.CleanInfo()
                    self.searchRoot = rootSearch
                    DispatchQueue.main.async {
                        self.tvGeneral.reloadData()
                    }
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
