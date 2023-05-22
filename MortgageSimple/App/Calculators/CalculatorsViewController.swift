//
//  CalculatorsViewController.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 21/05/2023.
//

import UIKit

class CalculatorsViewController: UIViewController {

    @IBOutlet weak var showMortgageView: UIView!
    @IBOutlet weak var showBorrowingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showMortgageView.layer.cornerRadius = 10
        showBorrowingView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
