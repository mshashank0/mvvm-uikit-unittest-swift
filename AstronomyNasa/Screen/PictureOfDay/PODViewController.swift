//
//  PODViewController.swift
//  AstronomyNasa
//
//  Created by Shashank Mishra on 23/03/23.
//

import UIKit

class PODViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UITextView!
    @IBOutlet var imageView: UIImageView!

    var viewModel: PODViewModel?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observer for getting pod object update
        viewModel?.pod.bind({ [weak self] _ in
            self?.viewModel?.getImageData()
            self?.showTextualData()
        })
        
        // Obsevers for binded image data object
        viewModel?.imageData.bind({ [weak self] _ in
            self?.showPicture()
        })
        
        viewModel?.getPictureOfDay()
    }
    
    func showTextualData() {
        DispatchQueue.main.async { [unowned self] in
            titleLabel.text = viewModel?.pod.value?.title ?? ""
            descriptionLabel.text = viewModel?.pod.value?.explanation ?? ""
        }
    }
    
    func showPicture() {
        guard let imageData = viewModel?.imageData.value else { return }
        DispatchQueue.main.async { [unowned self] in
            imageView.image = UIImage(data: imageData)
        }
    }
}
