//
//  StoryboardExtension.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 3/5/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit

extension UIStoryboard {
    public static func instantiateViewController(storyboardIdentifier: String,
                                                 bundle: Bundle? = nil,
                                                 viewControllerIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        return viewController
    }
}
