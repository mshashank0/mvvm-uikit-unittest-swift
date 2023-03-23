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
            self?.presentDataOnView()
        })
        
        viewModel?.getPictureOfDay()
    }
    
    func presentDataOnView() {
        DispatchQueue.main.async { [unowned self] in
            // TODO: - Get image and set it on imageView
            titleLabel.text = viewModel?.pod.value?.title ?? ""
            descriptionLabel.text = viewModel?.pod.value?.explanation ?? ""
        }
    }
}
