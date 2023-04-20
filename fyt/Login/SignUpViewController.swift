//
//  SignUpViewController.swift
//  almost-real
//
//  Created by Jason Lobo on 11/1/22.
//

import UIKit

// TODO: Pt 1 - Import Parse Swift
import ParseSwift

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
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
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: placeholderAttributes)
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: placeholderAttributes)

    }

    @IBAction func onSignUpTapped(_ sender: Any) {

        // Make sure all fields are non-nil and non-empty.
        guard let username = usernameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {

            showMissingFieldsAlert()
            return
        }

        // TODO: Pt 1 - Parse user sign up
        var newUser = User()
        newUser.username = username
        newUser.email = email
        newUser.password = password

        newUser.signup { [weak self] result in

            switch result {
            case .success(let user):

                print("✅ Successfully signed up user \(user)")

                // Post a notification that the user has successfully signed up.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

            case .failure(let error):
                // Failed sign up
                self?.showAlert(description: error.localizedDescription)
            }
        }

    }

    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Sign Up", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to sign you up.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
