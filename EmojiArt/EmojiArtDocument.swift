//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Max Matiushchenko on 14.08.2020.
//  Copyright © 2020 Max Matiushchenko. All rights reserved.
//

import SwiftUI

// ViewModel

class EmojiArtDocument: ObservableObject {
	
	static let pallette: String = "⭐️🌨🍎🌍🥨⚾️"

	// Model
	@Published private var emojiArt: EmojiArt {
		didSet {
			UserDefaults.standard.set(emojiArt.json , forKey: EmojiArtDocument.untitled)
		}
	}
	
	static private let untitled = "EmojiArtDocument.Untitled"
	
	init() {
		emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
		fetchBackgroundImage()
	}
	
	@Published private(set) var backgroundImage: UIImage?
	
	var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
	
	
	// MARK: - Intent(s)
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
	
	func setBackgroundURL(_ url: URL?) {
		emojiArt.backgroundURL = url?.imageURL
		fetchBackgroundImage()
	}
	
	func fetchBackgroundImage() {
		backgroundImage = nil
		if let url = emojiArt.backgroundURL {
			DispatchQueue.global(qos: .userInitiated).async {
				if let imageData = try? Data(contentsOf: url) {
					DispatchQueue.main.async {
						if url == self.emojiArt.backgroundURL {
							self.backgroundImage = UIImage(data: imageData)
						}
					}
				}
			}
		}
	}
	
}

extension EmojiArt.Emoji {
	var fontSize: CGFloat { CGFloat(self.size) }
	var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}