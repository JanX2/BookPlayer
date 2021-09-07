//
//  ChaptersViewModel.swift
//  BookPlayer
//
//  Created by Gianni Carlo on 30/8/21.
//  Copyright © 2021 Tortuga Power. All rights reserved.
//

import BookPlayerKit
import Combine
import Foundation

class ChaptersViewModel {
  func getBookChapters() -> [Chapter]? {
    return PlayerManager.shared.currentBook?.chapters?.array as? [Chapter]
  }

  func getCurrentChapter() -> Chapter? {
    return PlayerManager.shared.currentBook?.currentChapter
  }

  // Don't set the chapter, set the new time which will set the chapter in didSet
  // Add a fraction of a second to make sure we start after the end of the previous chapter
  func handleChapterSelected(_ chapter: Chapter) {
    PlayerManager.shared.jumpTo(chapter.start + 0.01)
  }
}
