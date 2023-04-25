//
//  PostCell.swift
//  almost-real
//
//  Created by Jason Lobo on 11/3/22.
//

import UIKit
import Alamofire
import AlamofireImage

class PostCell: UITableViewCell {
    
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationSuffixLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    private var imageDataRequest: DataRequest?
    
    func configure(with post: Post) {
        // TODO: Pt 1 - Configure Post Cell
        
        // Username
        if let user = post.user {
            usernameLabel.text = user.username
        }
        
        // Image
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {
            
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.postImageView.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
        
        // Caption
        captionLabel.text = post.caption
        workoutNameLabel.text = post.workout
        caloriesLabel.text = post.calories
        durationLabel.text = post.duration
        durationSuffixLabel.text = post.durationSuffix
        distanceLabel.text = post.distance
        
//        // Date
//        if let date = post.createdAt {
//                dateLabel.text = DateFormatter.postFormatter.string(from: date)}
        
        if let date = post.createdAt {
            let now = Date()
            let components = Calendar.current.dateComponents([.second, .minute, .hour], from: date, to: now)
            if let hour = components.hour, hour > 0 {
                dateLabel.text = hour == 1 ? "1 hour ago" : "\(hour) hours ago"
            } else if let minute = components.minute, minute > 0 {
                dateLabel.text = minute == 1 ? "1 minute ago" : "\(minute) minutes ago"
            } else if let second = components.second {
                dateLabel.text = second == 1 ? "1 second ago" : "\(second) seconds ago"
            }
        }

        
        func prepareForReuse() {
            super.prepareForReuse()
            // TODO: Pt 1 - Cancel image data request
            
            // Reset image view image.
            postImageView.image = nil
            
            // Cancel image request.
            imageDataRequest?.cancel()
        }
    }
}
