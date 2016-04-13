//: Playground - noun: a place where people can play

import UIKit

struct SimpleStruct {
    var a, b, c : Int
}

class SimpleClass {
    var a, b, c : Int
    
    init(a: Int, b:Int, c:Int) {
        self.a = a
        self.b = b
        self.c = c
    }
    
     var description : String {
       return ("\(self)(a: \(a), b: \(b), c: \(c))")
    }
}

var struct1 = SimpleStruct(a: 1, b: 2, c: 3)
var struct2 = SimpleStruct(a: 4, b: 5, c: 6)

struct1 = struct2
struct1.a = 7
struct1.b = 8
struct1.c = 9
print (struct1)
print (struct2)

var class1 = SimpleClass(a: 1, b: 2, c: 3)
var class2 = SimpleClass(a: 4, b: 5, c: 6)
class1 = class2
class1.a = 7
class1.b = 8
class1.c = 9
print(class1.description)
print(class2.description)
