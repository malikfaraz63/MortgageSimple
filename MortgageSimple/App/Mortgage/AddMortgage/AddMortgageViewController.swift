//
//  AddMortgageViewController.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 28/06/2023.
//

import UIKit

class AddMortgageViewController: UITableViewController, UITextFieldDelegate {
    
    var delegate: AddMortgageViewDelegate?
    
    @IBOutlet weak var saveMortgageButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var lenderTextField: UITextField!
    @IBOutlet weak var loanTextField: UITextField!
    @IBOutlet weak var dateSelectionField: UIDatePicker!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var termTextField: UITextField!
    @IBOutlet weak var interestTextField: UITextField!
    @IBOutlet weak var rentTextField: UITextField!
    
    @IBOutlet weak var interestImage: UIImageView!
    @IBOutlet weak var rentImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveMortgageButton.isEnabled = false
        isModalInPresentation = true
        
        interestImage.layer.cornerRadius = 5
        interestImage.clipsToBounds = true
        rentImage.layer.cornerRadius = 5
        rentImage.clipsToBounds = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveMortgageButton.isEnabled = mortgageWasValid()
        textField.resignFirstResponder()
        return true
    }
    
    func mortgageWasValid() -> Bool {
        guard
            titleTextField.text != nil,
            lenderTextField.text != nil,
            let loanText = loanTextField.text,
            let rateText = interestTextField.text,
                let rentText = rentTextField.text
        else {
            return false
        }
        
        let digits = /[0-9]+/
        let interestRate = /[0-9]+(.[0-9]+)?/
        do {
            return try
                digits.wholeMatch(in: loanText) != nil &&
                interestRate.wholeMatch(in: rateText) != nil &&
                digits.wholeMatch(in: rentText) != nil
        } catch {
            return false
        }
    }
    
    @IBAction func saveMortgage() {
        guard let delegate = delegate else {
            return
        }
        
        guard let lender = lenderTextField.text else { return }
        guard let title = titleTextField.text else { return }
        guard let address = addressTextField.text else { return }
        guard let loanText = loanTextField.text, let loan = Int(loanText) else { return }
        guard let termText = termTextField.text, let term = Int(termText) else { return }
        guard let rateText = interestTextField.text, let rate = Float(rateText) else { return }
        guard let rentText = rentTextField.text, let rent = Int(rentText) else { return }
        let start = dateSelectionField.date
        
        let mortgage = MortgageModel(address: address, lender: lender, loan: loan, mortgageDescription: title, rate: rate / 100, rent: rent, start: start, term: term)
        
        delegate.didAddMortgage(withModel: mortgage)
        dismiss(animated: true)
    }
    
    @IBAction func cancelMortgage() {
        dismiss(animated: true)
    }
}
