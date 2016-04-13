//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

protocol Protocol1{
    
    
    
}


class Class1 : Protocol1 {
    
    // Variable
    var class1Var = "Ich bin Class1"
    
    // Obj of Class2
    var class2Object: Class2?
    // Constructor
    init(string1 : String){
        self.class1Var = string1
        self.class2Object = Class2(string: "Hallo, ich komme aus Class 2", protocol1: self)
    }
    
}

class Class2 {
    
    // Property
    var class2Var = "Ich bin Class2"
    var protocol1: Protocol1
    
    //Constructor
    init(string: String, protocol1: Protocol1){
        self.class2Var = string
        self.protocol1 = protocol1
    }

    var class1Object: Class1 = Class1(string1: "Hallo, ich komme aus Class 2")
    
}
