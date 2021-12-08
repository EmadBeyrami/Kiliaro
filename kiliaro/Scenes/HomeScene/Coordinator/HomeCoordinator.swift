//
//  HomeCoordinator.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/5/21.
//

import UIKit
import QuickLook

class HomeCoordinator: Coordinator {
    
    var rootViewController: UIViewController?
    
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
        let homeViewController = HomeViewController.instantiate(coordinator: self)
        navigationController.pushViewController(homeViewController, animated: animated)
    }
    
    weak var previewDatasource: QLPreviewControllerDataSource?
    func toPreviewImage(item: QLPreviewItem) {
        let QLVC = QuickLookBuilder()
        QLVC.initializeWith(item: item, dataSource: previewDatasource)
        navigationController.pushViewController(QLVC, animated: true)
    }
    
    deinit {
        print("Removed \(self) from memory")
    }
}
