//
//  MortgageCell.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 24/05/2023.
//

import UIKit

class MortgageCell: UITableViewCell {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var remainingAmountLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var repaymentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var repaymentProgressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        repaymentProgressView.layer.cornerRadius = 5
        repaymentProgressView.clipsToBounds = true
    }

}
