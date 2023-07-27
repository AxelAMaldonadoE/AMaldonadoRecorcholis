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
    var estado: Estado? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tvEstados.dataSource = self
        tvEstados.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
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
    
    private func showDialog(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Aceptar", style: .default)
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        let backVC = self.presentingViewController as! MainController
        backVC.idPais = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! EstadoController
        nextVC.idPais = self.idPais
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
        let celda = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        if self.estados.count != 0 {
            celda.lblTitle.text = "\(indexPath.row + 1).- \(self.estados[indexPath.row].Nombre)"
            celda.btnDelete.tag = indexPath.row
            celda.btnUpdate.tag = indexPath.row
            celda.btnDelete.addTarget(self, action: #selector(deleteEstado), for: .touchUpInside)
            celda.btnUpdate.addTarget(self, action: #selector(updateEstado), for: .touchUpInside)
        } else {
            celda.lblTitle.text = "No hay estados en el pais seleccionado!"
            celda.btnDelete.removeFromSuperview()
            celda.btnUpdate.removeFromSuperview()
        }
        celda.selectionStyle = .none
        
        return celda
    }
    
    @objc
    func deleteEstado(_ sender: UIButton) {
        print("Eliminar estado")
        let estado = estados[sender.tag]
        EstadoViewModel.Delete(estado.IdEstado) { responseSource, resultSource, errorSource in
            if let result = resultSource {
                let root = result.Object as! Root<Estado>
                if root.correct {
                    DispatchQueue.main.async {
                        self.showDialog("Operacion Correcta", root.statusMessage!)
                        self.GetEstados(self.idPais!)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showDialog("Error", root.statusMessage!)
                    }
                }
            }
            
            if let error = errorSource {
                DispatchQueue.main.async {
                    self.showDialog("Error", error.localizedDescription)
                }
            }
        }
    }
    
    @objc
    func updateEstado(_ sender: UIButton) {
        print("Actualizar estado")
        self.estado = estados[sender.tag]
        self.performSegue(withIdentifier: "toFormEstado", sender: self)
    }
}
