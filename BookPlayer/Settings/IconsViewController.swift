//
//  IconsViewController.swift
//  BookPlayer
//
//  Created by Gianni Carlo on 2/19/19.
//  Copyright © 2019 Tortuga Power. All rights reserved.
//

import BookPlayerKit
import Themeable
import UIKit
import WidgetKit

class IconsViewController: UIViewController, TelemetryProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: PlusBannerView!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!

    let userDefaults = UserDefaults(suiteName: Constants.ApplicationGroupIdentifier)
    var icons: [Icon]!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.icons = self.getIcons()

        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 1))

        if !UserDefaults.standard.bool(forKey: Constants.UserDefaults.donationMade.rawValue) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.donationMade), name: .donationMade, object: nil)
        } else {
            self.donationMade()
        }

        setUpTheming()
        self.sendSignal(.appIconsScreen, with: nil)
    }

    @objc func donationMade() {
        self.bannerView.isHidden = true
        self.bannerHeightConstraint.constant = 0
        self.tableView.reloadData()
    }

    func getIcons() -> [Icon] {
        guard
            let iconsFile = Bundle.main.url(forResource: "Icons", withExtension: "json"),
            let data = try? Data(contentsOf: iconsFile, options: .mappedIfSafe),
            let icons = try? JSONDecoder().decode([Icon].self, from: data)
        else { return [] }

        return icons
    }

    func changeIcon(to iconName: String) {
        guard UIApplication.shared.supportsAlternateIcons else {
            return
        }

        self.userDefaults?.set(iconName, forKey: Constants.UserDefaults.appIcon.rawValue)

        let icon = iconName == "Default" ? nil : iconName

        UIApplication.shared.setAlternateIconName(icon, completionHandler: { error in
            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadAllTimelines()
            }
            guard error != nil else { return }

            self.showAlert("error_title".localized, message: "icon_error_description".localized)
        })
    }
}

extension IconsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.icons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCellView", for: indexPath) as! IconCellView
        // swiftlint:enable force_cast

        let item = self.icons[indexPath.row]

        cell.titleLabel.text = item.title
        cell.authorLabel.text = item.author
        cell.iconImage = UIImage(named: item.imageName)
        cell.isLocked = item.isLocked && !UserDefaults.standard.bool(forKey: Constants.UserDefaults.donationMade.rawValue)

        let currentAppIcon = self.userDefaults?.string(forKey: Constants.UserDefaults.appIcon.rawValue) ?? "Default"

        cell.accessoryType = item.id == currentAppIcon
            ? .checkmark
            : .none

        return cell
    }
}

extension IconsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? IconCellView else { return }

        defer {
            tableView.reloadData()
        }

        guard !cell.isLocked else {
            return
        }

        let item = self.icons[indexPath.row]

        self.changeIcon(to: item.id)

        self.sendSignal(.appIconAction, with: ["icon": item.title])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
}

extension IconsViewController: Themeable {
    func applyTheme(_ theme: Theme) {
        self.view.backgroundColor = theme.systemGroupedBackgroundColor

        self.tableView.backgroundColor = theme.systemGroupedBackgroundColor
        self.tableView.separatorColor = theme.separatorColor
    }
}
