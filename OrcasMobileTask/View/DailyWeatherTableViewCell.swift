//
//  DailyWeatherTableViewCell.swift
//  OrcasMobileTask
//
//  Created by mina wefky on 07/03/2021.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var state: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(weatherdate: String, weatherDescription: String){
        date.text = weatherdate
        state.text = weatherDescription
    }
    
}
