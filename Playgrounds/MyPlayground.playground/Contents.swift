//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"




class SimpleClass{
    var simpleVar : String = "Hallo ich bin eine Klasse"

    
    func printSimpleVar(){
        print (simpleVar)
    }
    
    var description: String{
        return simpleVar
    }
}

struct SimpleStruct {
    
    var simpleStructVar = "Hallo ich bin eine Struktur"
    
    func printSimpleStructVar(){
        print(simpleStructVar)
    }
}


////////////

var simpleClass = SimpleClass()

var simpleStruct = SimpleStruct()

// Creating copy of simpleClass and changing the var with CallByReference
var copySimpleClass = simpleClass
copySimpleClass.simpleVar = "Hallo ich bin eine Kopie der Klasse! BÄM!"

var copySimpleStruct = SimpleStruct (simpleStructVar: "Hallo")
// Creating copy of simpleStruct and changing the var with CallByValue
copySimpleStruct = simpleStruct

copySimpleStruct.simpleStructVar = "Hallo ich bin eine Kopie der Struktur! BÄM!"

// CallByReference
// Original Klasse
print (simpleClass.simpleVar)
// Copy of Class
print (copySimpleClass.simpleVar)

//Call by Value
print (simpleStruct.simpleStructVar)
//copy
print(copySimpleStruct.simpleStructVar)











