//
//  AddMortgageController.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 26/05/2023.
//

import UIKit

class AddMortgageViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: AddMortgageViewDelegate?
    
    @IBOutlet weak var saveMortgageButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var lenderTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveMortgageButton.isEnabled = false
        isModalInPresentation = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveMortgageButton.isEnabled = titleTextField.text != nil && lenderTextField.text != nil
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func saveMortgage() {
        guard let delegate = delegate else {
            return
        }
        
        guard let lender = lenderTextField.text else { return }
        guard let title = titleTextField.text else { return }
        let mortgage = MortgageModel(address: "44 ABCD Road", lender: lender, loan: 445000, mortgageDescription: title, rate: 0.044, rent: 0, start: Date(timeIntervalSinceNow: -86400 * 365 * 4), term: 10)
        
        delegate.didAddMortgage(withModel: mortgage)
        dismiss(animated: true)
    }
}
