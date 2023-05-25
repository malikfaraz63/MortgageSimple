//
//  MortgagesViewController.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 24/05/2023.
//

import UIKit

class MortgagesViewController: UIViewController {

    @IBOutlet weak var mortgagesTableView: UITableView!
    @IBOutlet weak var mortgagesAlertLabel: UILabel!
    @IBOutlet weak var addMortgageButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMortgageButton.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if MortgageSettingsManager.hasUser() {
            mortgagesTableView.isHidden = false
            addMortgageButton.isEnabled = true
        } else {
            addMortgageButton.isEnabled = false
            mortgagesTableView.isHidden = true
        }
    }
}

extension MortgagesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MortgageCell", for: indexPath) as? MortgageCell else { fatalError() }
        
        cell.layoutMargins.top = 100
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    // MARK: Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.contentView.backgroundColor = .systemGray4
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.contentView.backgroundColor = .systemGray6
    }
}
