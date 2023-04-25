//
//  PostViewController.swift
//  almost-real
//
//  Created by Jason Lobo on 11/1/22.
//

import UIKit
import ParseSwift
import HealthKit
import PhotosUI
import ParseSwift

class PostViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var workoutNameField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var caloriesBurnedLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationSuffixLabel: UILabel!
    
    private var pickedImage: UIImage?
    
    let healthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Customize placeholder color
        // Get the named color asset
        guard let fytFontGray = UIColor(named: "fytFontGray") else {
            fatalError("Couldn't get named color asset")
        }
        // Set the placeholder text color for usernameField
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: fytFontGray
        ]
        captionTextField.attributedPlaceholder = NSAttributedString(string: "What do you want to say about it?", attributes: placeholderAttributes)
        workoutNameField.attributedPlaceholder = NSAttributedString(string: "Workout name", attributes: placeholderAttributes)
        
        // Dyanamic Username
        let user = User.current
        usernameLabel.text = user?.username
        
        
        // healthkit
        let typesToRead = Set([HKObjectType.workoutType(), HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!])
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if success {
                // Authorization was granted
            } else {
                // Handle error
            }
        }
        
        // Get Latest Workout
        getLatestWorkout()
    }
    
    func getLatestWorkout() {
        let workoutType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: workoutType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let workout = samples?.first as? HKWorkout {
                // Use the workout data
                let workoutName: String
                
                switch workout.workoutActivityType {
                case .americanFootball:
                    workoutName = "American Football"
                case .archery:
                    workoutName = "Archery"
                case .australianFootball:
                    workoutName = "Australian Football"
                case .badminton:
                    workoutName = "Badminton"
                case .barre:
                    workoutName = "Barre"
                case .baseball:
                    workoutName = "Baseball"
                case .basketball:
                    workoutName = "Basketball"
                case .bowling:
                    workoutName = "Bowling"
                case .boxing:
                    workoutName = "Boxing"
                case .climbing:
                    workoutName = "Climbing"
                case .cooldown:
                    workoutName = "Cooldown"
                case .coreTraining:
                    workoutName = "Core Training"
                case .cricket:
                    workoutName = "Cricket"
                case .crossCountrySkiing:
                    workoutName = "Cross Country Skiing"
                case .crossTraining:
                    workoutName = "Cross Training"
                case .curling:
                    workoutName = "Curling"
                case .cycling:
                    workoutName = "Cycling"
                case .dance:
                    workoutName = "Dance"
                case .discSports:
                    workoutName = "Disc Sports"
                case .downhillSkiing:
                    workoutName = "Downhill Skiing"
                case .elliptical:
                    workoutName = "Elliptical"
                case .equestrianSports:
                    workoutName = "Equestrian Sports"
                case .fencing:
                    workoutName = "Fencing"
                case .fishing:
                    workoutName = "Fishing"
                case .fitnessGaming:
                    workoutName = "Fitness Gaming"
                case .flexibility:
                    workoutName = "Flexibility"
                case .functionalStrengthTraining:
                    workoutName = "Functional Strength Training"
                case .golf:
                    workoutName = "Golf"
                case .gymnastics:
                    workoutName = "Gymnastics"
                case .handCycling:
                    workoutName = "Hand Cycling"
                case .handball:
                    workoutName = "Handball"
                case .highIntensityIntervalTraining:
                    workoutName = "High Intensity Interval Training"
                case .hiking:
                    workoutName = "Hiking"
                case .hockey:
                    workoutName = "Hockey"
                case .hunting:
                    workoutName = "Hunting"
                case .jumpRope:
                    workoutName = "Jump Rope"
                case .kickboxing:
                    workoutName = "Kickboxing"
                case .lacrosse:
                    workoutName = "Lacrosse"
                case .martialArts:
                    workoutName = "Martial Arts"
                case .mindAndBody:
                    workoutName = "Mind and Body"
                case .mixedCardio:
                    workoutName = "Mixed Cardio"
                case .paddleSports:
                    workoutName = "Paddle Sports"
                case .pickleball:
                    workoutName = "Pickleball"
                case .pilates:
                    workoutName = "Pilates"
                case .play:
                    workoutName = "Play"
                case .preparationAndRecovery:
                    workoutName = "Preparation And Recovery"
                case .racquetball:
                    workoutName = "Racquetball"
                case .rowing:
                    workoutName = "Rowing"
                case .rugby:
                    workoutName = "Rugby"
                case .running:
                    workoutName = "Running"
                case .sailing:
                    workoutName = "Sailing"
                case .skatingSports:
                    workoutName = "Skating Sports"
                case .snowSports:
                    workoutName = "Snow Sports"
                case .snowboarding:
                    workoutName = "Snowboarding"
                case .soccer:
                    workoutName = "Soccer"
                case .socialDance:
                    workoutName = "Social Dance"
                case .softball:
                    workoutName = "Softball"
                case .squash:
                    workoutName = "Squash"
                case .stairClimbing:
                    workoutName = "Stair Stepper"
                case .stairs:
                    workoutName = "Stairs"
                case .stepTraining:
                    workoutName = "Step Training"
                case .surfingSports:
                    workoutName = "Surfing Sports"
                case .swimming:
                    workoutName = "Swimming"
                case .tableTennis:
                    workoutName = "Table Tennis"
                case .taiChi:
                    workoutName = "Tai Chi"
                case .tennis:
                    workoutName = "Tennis"
                case .trackAndField:
                    workoutName = "Track And Field"
                case .traditionalStrengthTraining:
                    workoutName = "Traditional Strength Training"
                case .volleyball:
                    workoutName = "Volleyball"
                case .walking:
                    workoutName = "Walking"
                case .waterFitness:
                    workoutName = "Water Fitness"
                case .waterPolo:
                    workoutName = "Water Polo"
                case .waterSports:
                    workoutName = "Water Sports"
                case .wheelchairRunPace:
                    workoutName = "Wheelchair Run Race"
                case .wheelchairWalkPace:
                    workoutName = "Wheelchair Walk Race"
                case .wrestling:
                    workoutName = "Wrestling"
                case .yoga:
                    workoutName = "Yoga"
                default:
                    workoutName = "Other"
                }
                
                let caloriesBurned = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie())
                
                
                // Convert duration to hours/minutes/seconds
                let durationInSeconds = Int(workout.duration)
                var durationSuffix = ""
                let hours = durationInSeconds / 3600
                let minutes = (durationInSeconds % 3600) / 60
                let seconds = (durationInSeconds % 3600) % 60
                var durationText = ""
                if hours > 0 {
                    let fractionalHours = Double(durationInSeconds) / 3600.0
                    durationText = String(format: "%.1f", fractionalHours)
                    durationSuffix = fractionalHours == 1.0 ? "hr" : "hrs"
                } else if minutes > 0 {
                    durationText = "\(minutes)"
                    durationSuffix = " min" + (minutes > 1 ? "s" : "")
                } else if seconds > 0 {
                    durationText = "\(seconds)"
                    durationSuffix = "sec" + (seconds > 1 ? "s" : "")
                }
                
                // Convert distance to miles
                let distanceInMeters = workout.totalDistance?.doubleValue(for: .meter()) ?? 0
                let distanceInMiles = distanceInMeters * 0.000621371
                let distanceText = String(format: "%.1f", distanceInMiles)
                
                // Update labels
                DispatchQueue.main.async {
                    self.workoutNameField.text = workoutName
                    self.caloriesBurnedLabel.text = "\(Int(caloriesBurned ?? 0))" //kcal
                    self.durationLabel.text = durationText
                    self.durationSuffixLabel.text = durationSuffix
                    self.distanceLabel.text = distanceText //miles
                }
            } else {
                // Handle error
            }
        }
        healthStore.execute(query)
    }

    @IBAction func onPickedImageTapped(_ sender: UIBarButtonItem) {
        // TODO: Pt 1 - Present Image picker
        // Create a configuration object
        var config = PHPickerConfiguration()

        // Set the filter to only show images as options (i.e. no videos, etc.).
        config.filter = .images

        // Request the original file format. Fastest method as it avoids transcoding.
        config.preferredAssetRepresentationMode = .current

        // Only allow 1 image to be selected at a time.
        config.selectionLimit = 1

        // Instantiate a picker, passing in the configuration.
        let picker = PHPickerViewController(configuration: config)

        // Set the picker delegate so we can receive whatever image the user picks.
        picker.delegate = self

        // Present the picker
        present(picker, animated: true)

    }

    @IBAction func onShareTapped(_ sender: Any) {

        // Dismiss Keyboard
        view.endEditing(true)

        // TODO: Pt 1 - Create and save Post
        // Unwrap optional pickedImage
        guard let image = pickedImage,
              // Create and compress image data (jpeg) from UIImage
              let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }

        // Create a Parse File by providing a name and passing in the image data
        let imageFile = ParseFile(name: "image.jpg", data: imageData)

        // Create Post object
        var post = Post()

        // Set properties
        post.imageFile = imageFile
        post.caption = captionTextField.text
        post.workout = workoutNameField.text
        post.calories = caloriesBurnedLabel.text
        post.duration = durationLabel.text
        post.durationSuffix = durationSuffixLabel.text
        post.distance = distanceLabel.text
        

        // Set the user as the current user
        post.user = User.current

        // Save object in background (async)
        post.save { [weak self] result in
            // Get the current user
            if var currentUser = User.current {

                // Update the `lastPostedDate` property on the user with the current date.
                currentUser.lastPostedDate = Date()

                // Save updates to the user (async)
                currentUser.save { [weak self] result in
                    switch result {
                    case .success(let user):
                        print("✅ User Saved! \(user)")

                        // Switch to the main thread for any UI updates
                        DispatchQueue.main.async {
                            // Return to previous view controller
                            self?.navigationController?.popViewController(animated: true)
                        }

                    case .failure(let error):
                        self?.showAlert(description: error.localizedDescription)
                    }
                }
            }
        }

    }
    
    @IBAction func onTakePhotoTapped(_ sender: Any) {
        // TODO: Pt 2 - Present camera
        // Make sure the user's camera is available
        // NOTE: Camera only available on physical iOS device, not available on simulator.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌📷 Camera not available")
            return
        }

        // Instantiate the image picker
        let imagePicker = UIImagePickerController()

        // Shows the camera (vs the photo library)
        imagePicker.sourceType = .camera

        // Allows user to edit image within image picker flow (i.e. crop, etc.)
        // If you don't want to allow editing, you can leave out this line as the default value of `allowsEditing` is false
        imagePicker.allowsEditing = true

        // The image picker (camera in this case) will return captured photos via it's delegate method to it's assigned delegate.
        // Delegate assignee must conform and implement both `UIImagePickerControllerDelegate` and `UINavigationControllerDelegate`
        imagePicker.delegate = self

        // Present the image picker (camera)
        present(imagePicker, animated: true)

    }

    @IBAction func onViewTapped(_ sender: Any) {
        // Dismiss keyboard
        view.endEditing(true)
    }

    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

// TODO: Pt 1 - Add PHPickerViewController delegate and handle picked image.
extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Dismiss the picker
        picker.dismiss(animated: true)

        // Make sure we have a non-nil item provider
        guard let provider = results.first?.itemProvider,
           // Make sure the provider can load a UIImage
           provider.canLoadObject(ofClass: UIImage.self) else { return }

        // Load a UIImage from the provider
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in

           // Make sure we can cast the returned object to a UIImage
           guard let image = object as? UIImage else {

              // ❌ Unable to cast to UIImage
              self?.showAlert()
              return
           }

           // Check for and handle any errors
           if let error = error {
               self?.showAlert(description: String(describing: error))
              return
           } else {

              // UI updates (like setting image on image view) should be done on main thread
              DispatchQueue.main.async {

                 // Set image on preview image view
                 self?.previewImageView.image = image

                 // Set image to use when saving post
                 self?.pickedImage = image
              }
           }
        }
    }
    

}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // Dismiss the image picker
        picker.dismiss(animated: true)

        // Get the edited image from the info dictionary (if `allowsEditing = true` for image picker config).
        // Alternatively, to get the original image, use the `.originalImage` InfoKey instead.
        guard let image = info[.editedImage] as? UIImage else {
            print("❌📷 Unable to get image")
            return
        }

        // Set image on preview image view
        previewImageView.image = image

        // Set image to use when saving post
        pickedImage = image
    }
}
