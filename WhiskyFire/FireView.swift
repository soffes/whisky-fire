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

public class FireView: ScreenSaverView {

	// MARK: - Properties

	private let playerView: AVPlayerView = {
		let view = PlayerView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.controlsStyle = .None
		return view
	}()


	// MARK: - Initializers

	public convenience init() {
		self.init(frame: CGRectZero, isPreview: false)
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
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}


	// MARK: - NSView

	public override func drawRect(rect: NSRect) {
		let backgroundColor: NSColor = .redColor()

		backgroundColor.setFill()
		NSBezierPath.fillRect(bounds)
	}


	// MARK: - Private

	private func initialize() {
		addSubview(playerView)
		addConstraints([
			NSLayoutConstraint(item: playerView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: playerView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: playerView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: playerView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
		])

		guard let URL = NSBundle(forClass: FireView.self).URLForResource("Nick", withExtension: "mp4") else { return }
		let player = AVPlayer(URL: URL)

		// No audio
		player.muted = true

		// Loop
		player.actionAtItemEnd = .None
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)

		playerView.player = player
		player.play()
	}

	@objc private func playerItemDidReachEnd(notification: NSNotification?) {
		guard let playerItem = notification?.object as? AVPlayerItem else { return }
		playerItem.seekToTime(kCMTimeZero)
	}
}
