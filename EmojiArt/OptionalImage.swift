//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Max Matiushchenko on 21.08.2020.
//  Copyright © 2020 Max Matiushchenko. All rights reserved.
//

import SwiftUI

struct OptionalImage: View {
	
	let uiImage: UIImage?
	
	var body: some View  {
		Group {
			if uiImage != nil {
				Image(uiImage: uiImage!)
			}
		}
	}
	
}
