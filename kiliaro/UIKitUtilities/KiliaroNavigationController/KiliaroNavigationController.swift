//
//  KiliaroNavigationController.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/8/21.
//

import UIKit

class KiliaroNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        navigationBar.barTintColor = UIColor.kiliaroOrange
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.kiliaroOrange
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
            self.navigationBar.standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        }
    }
}
