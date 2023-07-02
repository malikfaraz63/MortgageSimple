//
//  MortgagesViewController.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 24/05/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class MortgagesViewController: UIViewController {

    @IBOutlet weak var mortgagesTableView: UITableView!
    @IBOutlet weak var mortgagesAlertLabel: UILabel!
    @IBOutlet weak var addMortgageButton: UIButton!
    
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    
    var previousUserID: String?
    var mortgagesData: [MortgageModel]?
    
    typealias MortgagesLoadCompletion = (_ models: [MortgageModel]) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMortgageButton.layer.cornerRadius = 20
        
        viewDidAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addMortgageButton.isEnabled = false
        mortgagesTableView.isHidden = true
        
        
        if MortgageSettingsManager.hasUser() {
            if let previousUserID = previousUserID {
                if MortgageSettingsManager.getUserID() == previousUserID {
                    mortgagesTableView.isHidden = false
                    addMortgageButton.isEnabled = true
                } else {
                    setupViewForUser()
                }
            } else {
                setupViewForUser()
            }
        }
    }
    
    func setupViewForUser() {
        self.previousUserID = MortgageSettingsManager.getUserID()
        
        loadAllUserMortgages { models in
            self.mortgagesData = models
            self.mortgagesTableView.reloadData()
            self.mortgagesTableView.isHidden = false
            self.addMortgageButton.isEnabled = true
        }
    }
    
    func loadAllUserMortgages(completion: @escaping MortgagesLoadCompletion) {
        guard let uid = previousUserID else { return }
        
        db
            .collection("users")
            .document(uid)
            .collection("mortgages")
            .getDocuments { querySnapshot, error in
                var mortgages: [MortgageModel] = []
                if let snapshot = querySnapshot {
                    do {
                        try mortgages.append(contentsOf: snapshot.documents.map { try $0.data(as: MortgageModel.self) })
                    } catch {
                        
                    }
                    
                    completion(mortgages)
                } else if let _ = error {
                    
                }
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SegueTag.addMortgage.rawValue) {
            guard let destination = segue.destination as? AddMortgageViewController else { return }
            
            destination.delegate = self
        }
    }
}

extension MortgagesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Mortgages Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let mortgagesData = mortgagesData else {
            return 0
        }
        
        return mortgagesData.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MortgageCell", for: indexPath) as? MortgageCell else { fatalError() }
        
        guard let model = mortgagesData?[indexPath.row] else {
            return cell
        }
        
        cell.layoutMargins.top = 100
        
        cell.descriptionLabel.text = MortgageManager.getDescriptionLabel(forModel: model)
        cell.providerLabel.text = MortgageManager.getLenderLabel(forModel: model)
        cell.rateLabel.text = MortgageManager.getRateLabel(forModel: model)
        cell.remainingAmountLabel.text = MortgageManager.getRemainingLabel(forModel: model)
        cell.repaymentLabel.text = MortgageManager.getRepaymentLabel(forModel: model)
        cell.repaymentProgressView.progress = MortgageManager.getProgress(forModel: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    // MARK: Mortgages Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.contentView.backgroundColor = .systemGray4
        
        guard let mortgageData = mortgagesData?[indexPath.row] else { return }
        let userViewController = UIHostingController(rootView: MortgageDetailView(mortgageData: mortgageData))
        show(userViewController, sender: self)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.contentView.backgroundColor = .systemGray6
    }
}

extension MortgagesViewController: AddMortgageViewDelegate {
    // MARK: Add Mortgage Delegate
    
    func didAddMortgage(withModel model: MortgageModel) {
        guard let uid = previousUserID else { return }
        
        // TODO: Cleanup with encodeIfPresent
        
        // no optionals here
        do {
            try db
                .collection("users")
                .document(uid)
                .collection("mortgages")
                .document()
                .setData(from: model) { error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            
            setupViewForUser()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
}
