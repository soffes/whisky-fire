//
//  FireView.swift
//  WhiskyFire
//
//  Created by Sam Soffes on 12/2/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
import ScreenSaver

open class FireView: ScreenSaverView {

	// MARK: - Properties

	fileprivate let playerView: AVPlayerView = {
		let view = PlayerView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.controlsStyle = .none
		return view
	}()


	// MARK: - Initializers

	public convenience init() {
		self.init(frame: CGRect.zero, isPreview: false)
	}

	public override init!(frame: NSRect, isPreview: Bool) {
		super.init(frame: frame, isPreview: isPreview)
		initialize()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		initialize()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}


	// MARK: - NSView

	open override func draw(_ rect: NSRect) {
		let backgroundColor: NSColor = .red

		backgroundColor.setFill()
		NSBezierPath.fill(bounds)
	}


	// MARK: - Private

	fileprivate func initialize() {
		addSubview(playerView)
		addConstraints([
			NSLayoutConstraint(item: playerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: playerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: playerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: playerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
		])

		guard let URL = Bundle(for: FireView.self).url(forResource: "Nick", withExtension: "mp4") else { return }
		let player = AVPlayer(url: URL)

		// No audio
		player.isMuted = true

		// Loop
		player.actionAtItemEnd = .none
		NotificationCenter.default.addObserver(self, selector: #selector(FireView.playerItemDidReachEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

		playerView.player = player
		player.play()
	}

	@objc fileprivate func playerItemDidReachEnd(_ notification: Notification?) {
		guard let playerItem = notification?.object as? AVPlayerItem else { return }
		playerItem.seek(to: kCMTimeZero)
	}
}
