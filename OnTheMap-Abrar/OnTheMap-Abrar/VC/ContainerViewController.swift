//
//  ContainerViewController.swift
//

import UIKit

class ContainerViewController: UIViewController {
    
    var locationsData: LocationsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadTheStudentsLocations()
    }
    
    func setupUI() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocation(_:)))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshLocations(_:)))
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout(_:)))
        
        navigationItem.rightBarButtonItems = [addButton, refresh]
        navigationItem.leftBarButtonItem = logout
    }
    
    @objc private func addLocation(_ sender: Any) {
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func refreshLocations(_ sender: Any) {
        loadTheStudentsLocations()
    }
    
    @objc private func logout(_ sender: Any) {
        API.deleteSession_logout { (error) -> Void in }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadTheStudentsLocations() {
        API.Parser.getStudentsLocations { (data) in
            guard let data = data else {
                self.showAlert(title: "Error", message: "There is No internet connection!")
                return
            }
            guard data.studentLocations.count > 0 else {
                self.showAlert(title: "Error", message: "There are No pins!")
                return
            }
            self.locationsData = data
        }
    }
    
}
