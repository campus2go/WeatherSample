//
//  WeatherIconProvider.swift
//  WeatherSample
//
//  Created by Hermann on 17.10.15.
//  Copyright © 2015 Hermann Klecker. All rights reserved.
//

import Foundation

import UIKit

protocol WeatherIconProvider{
	
	func iconForCondition (condition : WeatherCondition) -> UIImage?

}
