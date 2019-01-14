//
//  TableLocationCell.swift
//  OnTheMap-Abrar
//
//  Created by Abrar on 1/5/19.
//  Copyright © 2019 Abrar. All rights reserved.
//

import UIKit

class TableLocationCell: UITableViewCell {
    
    static let identifier = "TableLocationCell"

    @IBOutlet weak var Namelbl: UILabel!
    @IBOutlet weak var URLlbl: UILabel!
    
     var location: StudentLocation?! {
     didSet {
     updateUI()
     }
     }
     
     func updateUI() {
     
      if let frist =  location?.firstName , let last = location?.lastName
        {
         Namelbl.text = "\(frist) \(last)"
         }
        URLlbl.text = location?.mediaURL
     }
 
    

}
