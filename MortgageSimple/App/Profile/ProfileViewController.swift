//
//  ProfileViewController.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 23/05/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileViewController: UIViewController, LoginViewDelegate, SetupViewDelegate {
    

    @IBOutlet weak var profileInfoView: UIView!
    @IBOutlet weak var profileNotFoundView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loadingUserIndicator: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.setTitle("Fetching user...", for: .disabled)
        logoutButton.setTitle("Log out", for: .normal)

        if MortgageSettingsManager.hasUser() {
            loadSavedUser()
        } else {
            hideProfileInfoView()
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: User Fetch
    
    func loadSavedUser() {
        logoutButton.isEnabled = false
        loadingUserIndicator.startAnimating()
        
        let uid = MortgageSettingsManager.getUserID()!
        
        db
            .collection("users")
            .document(uid)
            .getDocument(as: UserModel.self) { result in
                switch result {
                case .success(let userModel):
                    self.updateDisplay(withUser: userModel)
                case .failure:
                    self.userDidLogout()
                }
                self.logoutButton.isEnabled = true
                self.loadingUserIndicator.stopAnimating()
            }
    }
    
    // MARK: Login View Delegate
    
    func userDidLogin(user: User) {
        profileInfoView.isHidden = false
        profileImageView.layer.cornerRadius = 50
        
        MortgageSettingsManager.setUserID(to: user.uid)
        
        if let url = user.photoURL {
            profileImageView.load(url: url)
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle")
        }
        
        db
            .collection("users")
            .document(user.uid)
            .getDocument(as: UserModel.self) { result in
                switch result {
                case .success(let userModel):
                    self.updateDisplay(withUser: userModel)
                case .failure:
                    self.setupNewUser(withUser: user)
                }
                self.logoutButton.isEnabled = true
                self.loadingUserIndicator.stopAnimating()
            }
    }
    
    // MARK: Setup View Delegate
    
    func setupNewUser(withUser user: User) {
        guard let setupController = storyboard?.instantiateViewController(identifier: StoryboardTag.setupViewController.rawValue) as? SetupViewController else { return }
        setupController.delegate = self
        setupController.user = user
        navigationController?.showDetailViewController(setupController, sender: nil)
    }
    
    func userDidSetup(withUser userModel: UserModel) {
        updateDisplay(withUser: userModel)
        
        guard let uid = MortgageSettingsManager.getUserID() else { return }
        
        // TODO: Cleanup with encodeIfPresent
        
        var data: [String: Any] = [
            "address": userModel.address,
            "age": userModel.age,
            "phone": userModel.phone
        ]
        if let email = userModel.email {
            data.updateValue(email, forKey: "email")
        }
        if let url = userModel.photoURL {
            data.updateValue(url, forKey: "photoURL")
        }
        if let name = userModel.name {
            data.updateValue(name, forKey: "name")
        }
        
        db
            .collection("users")
            .document(uid)
            .setData(data) { error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: Display Updates
    
    func hideProfileInfoView() {
        profileInfoView.isHidden = true
        profileImageView.layer.cornerRadius = 0
        profileImageView.image = UIImage(systemName: "person.crop.circle.badge.questionmark")
    }
    
    func showProfileInfoView() {
        profileInfoView.isHidden = false
        profileImageView.layer.cornerRadius = 50
    }
    
    func clearDisplay() {
        nameLabel.text = "--"
        addressLabel.text = "--"
        ageLabel.text = "--"
        phoneLabel.text = "--"
        emailLabel.text = "--"
    }
    
    func updateDisplay(withUser user: UserModel) {
        showProfileInfoView()
        
        nameLabel.text = user.name
        addressLabel.text = user.address
        ageLabel.text = "\(user.age) yrs"
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        if let url = user.photoURL {
            profileImageView.load(url: URL(string: url)!)
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle")
        }
    }
    
    // MARK: Log out
    
    @IBAction func userDidLogout() {
        MortgageSettingsManager.deleteUser()
        clearDisplay()
        hideProfileInfoView()
        
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
    }
    
    
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueTag.showLogin.rawValue {
            guard let loginViewController = segue.destination as? LoginViewController else { return }
            loginViewController.delegate = self
            logoutButton.isEnabled = false
            loadingUserIndicator.startAnimating()
        }
    }

}
