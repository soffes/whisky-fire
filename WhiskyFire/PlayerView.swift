//
//  PlayerView.swift
//  WhiskyFire
//
//  Created by Sam Soffes on 12/7/15.
//  Copyright © 2015 Sam Soffes. All rights reserved.
//

import Foundation
import AVKit

/// Player view with disabled keyboard shortcuts. This is a screen saver after all.
class PlayerView: AVPlayerView {
	override func keyDown(theEvent: NSEvent) {
		// Do nothing
	}
}
