//
//  TableViewController.swift
//  OnTheMap-Abrar
//
//  Created by Abrar on 1/3/19.
//  Copyright © 2019 Abrar. All rights reserved.
//

import UIKit

class TableViewController: ContainerViewController, UITableViewDelegate  , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override var locationsData: LocationsData? {
        didSet {
            guard let locationsData = locationsData else { return }
            locations = locationsData.studentLocations
        }
    }
    var locations: [StudentLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  return UITableViewCell()

        let cell = tableView.dequeueReusableCell(withIdentifier: "TableLocationCell", for: indexPath) as! TableLocationCell
        let location = locations[indexPath.row]
        
        cell.location = location
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: locations[indexPath.row].mediaURL ?? " "),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
 
}


