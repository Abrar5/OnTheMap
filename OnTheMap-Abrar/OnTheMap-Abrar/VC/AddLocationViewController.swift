//
//  AddLocationViewController.swift
//


import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var LinkTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func findLocationTapped(_ sender: UIButton) {
        guard let location = locationTextField.text,
            let Link = LinkTextField.text,
            location != "", Link != "" else {
                self.showAlert(title: "Error", message: "All fields are required. Please fill both fields and try again")
                return
        }
        
        guard let url = URL(string: Link), UIApplication.shared.canOpenURL(url) else {
            self.showAlert(title: "Error", message: "Please use a valid link.")
            return
        }
    
        let studentLocation = StudentLocation(mapString: location, mediaURL: Link)
        geocodeCoordinates(studentLocation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue", let vc = segue.destination as? ConfirmLocationViewController {
            vc.location = (sender as! StudentLocation)
        }
    }
    
    @objc private func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancel(_:)))
        
        locationTextField.delegate = self as UITextFieldDelegate
        LinkTextField.delegate = self as UITextFieldDelegate
    }
    
    private func geocodeCoordinates(_ studentLocation: StudentLocation) {
        
        ActivityIndicator.startActivityIndicator(view: self.findButton)

        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, err) in
            ActivityIndicator.stopActivityIndicator()
            guard let firstLocation = placeMarks?.first?.location else { return }
            var location = studentLocation
            location.latitude = firstLocation.coordinate.latitude
            location.longitude = firstLocation.coordinate.longitude
            self.performSegue(withIdentifier: "mapSegue", sender: location)
        }
    }
    
}
