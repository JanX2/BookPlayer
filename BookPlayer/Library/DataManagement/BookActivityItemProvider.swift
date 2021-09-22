//
//  BookActivityItemProvider.swift
//  BookPlayer
//
//  Created by Gianni Carlo on 9/28/18.
//  Copyright © 2018 Tortuga Power. All rights reserved.
//

import BookPlayerKit
import UIKit

final class BookActivityItemProvider: UIActivityItemProvider {
  var book: SimpleLibraryItem
  init(_ book: SimpleLibraryItem) {
    self.book = book
    super.init(placeholderItem: book)
  }

  public override func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
    let fileURL = DataManager.getDocumentsFolderURL().appendingPathComponent(self.book.relativePath)

//    let tempDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
//    let tempUrl = tempDir.appendingPathComponent(fileURL.lastPathComponent)
//
//    try? FileManager.default.copyItem(at: fileURL, to: tempUrl)

    return fileURL
  }

  public override func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
    return URL(fileURLWithPath: "placeholder")
  }
}
