//: Playground - noun: a place where people can play

import UIKit

class Telefon {
    func hatKabel() -> Bool { return true }
    
    func wählen (nummer: String) {}
    
    func annehmen () {}
    
    func auflegen () {}
}

class Smartphone : Telefon {
    override func hatKabel() -> Bool {
        return false
    }
}

Telefon().hatKabel()

Smartphone().hatKabel()
