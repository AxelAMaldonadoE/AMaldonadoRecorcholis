//
//  PaisController.swift
//  AMaldonadoRecorcholis
//
//  Created by MacBookMBA15 on 26/07/23.
//

import UIKit

class PaisController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnActions: UIButton!
    
    // MARK: Variables
    var pais: Pais? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if pais != nil {
            btnActions.setTitle("Actualizar", for: .normal)
            btnActions.setImage(UIImage(systemName: "pencil"), for: .normal)
            btnActions.tintColor = .systemBlue
            txtNombre.text = pais!.Nombre
        } else {
            btnActions.setTitle("Agregar", for: .normal)
            btnActions.setImage(UIImage(systemName: "plus"), for: .normal)
            btnActions.tintColor = .systemGreen
        }
        lblError.isHidden = true
        txtNombre.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if pais != nil {
            let backVC = presentingViewController as! MainController
            backVC.pais = nil
        }
    }
    
    @IBAction func btnBack() {
        self.dismiss(animated: true)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard txtNombre.text != "" else {
            lblError.text = "No dejar en blanco el campo!"
            lblError.isHidden = false
            txtNombre.backgroundColor = .red.withAlphaComponent(0.10)
            return
        }
        
        lblError.text = ""
        lblError.isHidden = true
        txtNombre.backgroundColor = .systemGreen.withAlphaComponent(0.10)
        
        let opcion = sender.titleLabel?.text
        
        if opcion == "Agregar" {
            PaisViewModel.Add(txtNombre.text!) { resultSource, errorSource in
                if resultSource!.Correct {
                    let root = resultSource!.Object as! ServiceStatus
                    if root.correct {
                        DispatchQueue.main.async {
                            self.showMessage("Operacion Correcta", root.statusMessage!)
                        }
                    }
                }  else {
                    let root = resultSource!.Object as! ServiceStatus
                    DispatchQueue.main.async {
                        self.showMessage("Error", root.statusMessage!)
                    }
                }
                
                if let error = errorSource {
                    DispatchQueue.main.async {
                        self.showMessage("Error", error.localizedDescription)
                    }
                }
            }
        }
        
        if opcion == "Actualizar" {
            PaisViewModel.Update(txtNombre.text!, pais!.IdPais) { resultSource, errorSource in
                if resultSource!.Correct {
                    let root = resultSource!.Object as! ServiceStatus
                    if root.correct {
                        DispatchQueue.main.async {
                            self.showMessage("Operacion Correcta", root.statusMessage!)
                        }
                    }
                } else {
                    let root = resultSource!.Object as! ServiceStatus
                    DispatchQueue.main.async {
                        self.showMessage("Error", root.statusMessage!)
                    }
                }
                
                if let error = errorSource {
                    DispatchQueue.main.async {
                        self.showMessage("Error", error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func showMessage(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Aceptar", style: .default)
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
}

// MARK: Extension UITextField
extension PaisController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-zÁ-ÿ'´Ññ].*", options: [])
            if regex.firstMatch(in: string, range: NSMakeRange(0, string.count)) != nil {
                self.lblError.text = "Debes Ingresar unicamente caracteres alfabeticos!!"
                self.lblError.isHidden = false
                return false
            }
            self.lblError.text = ""
            self.lblError.isHidden = true
        } catch {
            return false
        }
        
        return true
    }
}
