//
//  TweetsRefreshDelegate.swift
//  TwitterDemo
//
//  Created by Nishant nishanko on 4/16/17.
//  Copyright © 2017 Nishant nishanko. All rights reserved.
//

import UIKit

@objc protocol TweetsRefreshDelegate {
    @objc optional func refreshTweets()
}
