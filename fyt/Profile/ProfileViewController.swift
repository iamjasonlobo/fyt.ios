//
//  ProfileViewController.swift
//  fyt
//
//  Created by Jason Lobo on 4/21/23.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Adding fyt. logo to the navbar
        let logoView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 45))
        // Create an image view with the image you want to display
        let logoImageView = UIImageView(image: UIImage(named: "fyt_logo"))
        logoImageView.contentMode = .scaleAspectFit
        // Set the frame of the image view to fit inside the custom view
        logoImageView.frame = CGRect(x: 0, y: 0, width: logoView.frame.width, height: logoView.frame.height)
        // Add the image view to the custom view
        logoView.addSubview(logoImageView)
        // Set the custom view as the title view of the navigation bar
        navigationItem.titleView = logoView
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
