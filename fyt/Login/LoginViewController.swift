//
//  LoginViewController.swift
//  almost-real
//
//  Created by Jason Lobo on 10/29/22.
//

import UIKit

// TODO: Pt 1 - Import Parse Swift


class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI customizations to stackview
            // Making edges of stackview rounded
        stackView.layer.cornerRadius = 30
        stackView.layer.masksToBounds = true
            // Addring Stroke to give depth
                // Create a new layer for the stroke
        let strokeLayer = CALayer()
        strokeLayer.borderColor = UIColor(named: "fytStrokeBlack")?.cgColor
        strokeLayer.borderWidth = 1
        strokeLayer.frame = stackView.bounds
                // Add the stroke layer to the stack view's layer
        stackView.layer.addSublayer(strokeLayer)
        
        // Customize placeholder color
        // Get the named color asset
        guard let fytFontGray = UIColor(named: "fytFontGray") else {
            fatalError("Couldn't get named color asset")
        }
        // Set the placeholder text color for usernameField
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: fytFontGray
        ]
        usernameField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: placeholderAttributes)
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: placeholderAttributes)
    }
    
    @IBAction func onLoginTapped(_ sender: Any) {

        // Make sure all fields are non-nil and non-empty.
        guard let username = usernameField.text,
              let password = passwordField.text,
              !username.isEmpty,
              !password.isEmpty else {

            showMissingFieldsAlert()
            return
        }

        // TODO: Pt 1 - Log in the parse user
        // Log in the parse user
        User.login(username: username, password: password) { [weak self] result in

            switch result {
            case .success(let user):
                print("✅ Successfully logged in as user: \(user)")

                // Post a notification that the user has successfully logged in.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }

    }

    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Log in", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to log you in.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

