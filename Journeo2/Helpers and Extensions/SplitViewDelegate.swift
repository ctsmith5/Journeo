//
//  SplitViewDelegate.swift
//  Journeo2
//
//  Created by Colin Smith on 1/26/20.
//  Copyright © 2020 Colin Smith. All rights reserved.
//

import UIKit


class SplitViewDelegate: NSObject, UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let navigationController = primaryViewController as? UINavigationController,
              let controller = navigationController.topViewController as? ArchiveTableViewController else {
            return true
        }
        return controller.collapseDetailViewController
    }
}
