//
//  SettingsCoordinator.swift
//  BookPlayer
//
//  Created by Gianni Carlo on 22/9/21.
//  Copyright © 2021 Tortuga Power. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator {
  override func start() {
    let vc = SettingsViewController.instantiate(from: .Settings)
    vc.coordinator = self
    let nav = AppNavigationController.instantiate(from: .Settings)
    nav.viewControllers = [vc]
    nav.presentationController?.delegate = self
    self.presentingViewController?.present(nav, animated: true, completion: nil)
  }

  override func dismiss() {
    self.presentingViewController?.dismiss(animated: true, completion: { [weak self] in
      self?.parentCoordinator?.childDidFinish(self)
    })
  }
}
