//
//  EstadosController.swift
//  AMaldonadoRecorcholis
//
//  Created by MacBookMBA15 on 26/07/23.
//

import UIKit

class EstadosController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var tvEstados: UITableView!
    
    // MARK: Variables
    var idPais: Int? = nil
    var estados: [Estado] = []
    var idEstado: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tvEstados.dataSource = self
        if let id = idPais {
            GetEstados(id)
        }
    }
    
    @IBAction func btnAgregar() {
        self.performSegue(withIdentifier: "toFormEstado", sender: self)
    }
    
    // MARK: Funciones privadas
    private func GetEstados(_ idPais: Int) {
        EstadoViewModel.GetEstados(idPais) { responseSource, resultSource, errorSource in
            if let response = responseSource {
                if resultSource!.Correct {
                    let root = resultSource!.Object as! Root<Estado>
                    if let results = root.results {
                        self.estados = results
                    }
                    DispatchQueue.main.async {
                        self.tvEstados.reloadData()
                    }
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        let backVC = self.presentingViewController as! MainController
        backVC.idPais = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! EstadoController
        nextVC.idPais = self.idPais
        if idEstado != nil {
            // Agregar el id del estado a actualizar
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
        let celda = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if self.estados.count != 0 {
            celda.textLabel?.text = "\(indexPath.row + 1).- \(self.estados[indexPath.row].Nombre)"
        } else {
            celda.textLabel?.text = "No hay estados en el pais seleccionado!"
        }
        celda.textLabel?.font = UIFont(name: "Helvetica Neue", size: 18)
        celda.selectionStyle = .none
        
        return celda
    }
}
