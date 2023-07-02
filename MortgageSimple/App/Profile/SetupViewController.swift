//
//  SetupViewController.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 23/05/2023.
//

import UIKit
import FirebaseAuth

class SetupViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: SetupViewDelegate?
    var user: User?
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAccountButton.isEnabled = false
        
        modalPresentationStyle = .custom
        guard let sheet = sheetPresentationController else { return }
        sheet.detents = [.medium()]
    }
    
    @IBAction func createAccount() {
        guard let user = user else { fatalError() }
        
        let address = addressTextField.text!
        let age = Int(ageTextField.text!)!
        let phone = phoneTextField.text!
        
        delegate?.userDidSetup(withUser: UserModel(address: address, age: age, name: user.displayName, email: user.email, phone: phone, photoURL: user.photoURL?.absoluteString))
        
        dismiss(animated: true)
    }
    
    @IBAction func textFieldEditingChanged() {
        tryEnablingAccountButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let _ = textFieldShouldReturn(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func tryEnablingAccountButton() {
        if getIsAddressValid() &&
            getIsAgeValid() &&
            getIsPhoneValid() {
            createAccountButton.isEnabled = true
        } else {
            createAccountButton.isEnabled = false
        }
    }
    
    func getIsAddressValid() -> Bool {
        guard let _ = addressTextField.text else {
            return false
        }
        
        return true
    }
    
    func getIsAgeValid() -> Bool {
        guard let ageString = ageTextField.text else {
            return false
        }
                
        if let age = Int(ageString) {
            return age >= 18
        } else {
            return false
        }
    }
    
    func getIsPhoneValid() -> Bool {
        guard let phoneNumber = phoneTextField.text else {
            return false
        }
        
        return isValidNumber(phoneNumber)
    }
    
    // MARK: Helper
    
    private func isValidNumber(_ phoneNumber: String) -> Bool {
        let expression = try! NSRegularExpression(pattern: #"(0|(\+?44))? ?7\d{3} ?\d{6}"#)
        
        let range = NSRange(location: 0, length: phoneNumber.count)
        
        return expression.firstMatch(in: phoneNumber, range: range) != nil
    }
}
