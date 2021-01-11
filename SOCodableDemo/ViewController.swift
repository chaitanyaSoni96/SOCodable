//
//  ViewController.swift
//  SOCodableDemo
//
//  Created by Chaitanya Soni on 11/01/21.
//  Copyright © 2021 Chaitanya Soni. All rights reserved.
//

import UIKit
import SOCodable

struct User: SOCodable {
	static var uniqueID: String = "User"
	static var expiryTime: TimeInterval = 0
	
	
	var name: String
	var id: String
}

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let user = User(name: "chaitanya", id: "1234")
		try? user.saveToDisk()
		
		print(User.getFromDisk())
		// Do any additional setup after loading the view.
	}


}

