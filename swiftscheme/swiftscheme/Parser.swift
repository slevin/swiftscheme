//
//  Parser.swift
//  swiftscheme
//
//  Created by Sean Levin on 6/3/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

public func parseWord(word: String) -> Element {
    // try to parse as a number if that isn't anything
    if word == "#f" {
        return .BoolEl(false)
    } else if word == "#t" {
        return .BoolEl(true)
    } else if let i = word.toInt() {
        return .IntEl(i)
    } else if let i = word.toDouble() {
        return .DoubleEl(i)
    } else {
        return .SymbolEl(word)
    }
}

class ParseAccumulator {
    var listStack:[[Element]] = [[Element]]()
    var currentList:[Element]?
    
    func decendList() {
        // if there is a current list push it on the stack
        if currentList != nil {
            self.listStack.append(currentList!)
        }
        // make a new list to build
        self.currentList = [Element]()
    }
    
    func ascendList() {
        if currentList != nil {
            // if theres a stack of lists
            if listStack.count > 0 {
                // pop the top, add current to that
                var popped:[Element] = listStack.removeLast()
                popped.append(Element.ListEl(currentList!))
                // and make the top the current
                currentList = popped
            }
        }
    }
    
    func completeWord(word: String) {
        if self.currentList != nil {
            // don't add nothing
            if count(word) != 0 {
                self.currentList!.append(parseWord(word))
            }
        }
    }
    
    func toElement() -> Element {
        if currentList != nil {
            return Element.ListEl(currentList!)
        } else {
            return Element.NilEl
        }
    }
}

public func parse(code: String) -> Element {
    var accumulator = ParseAccumulator()
    var currentWord = ""
    for c in code {
        if (c == "(") {
            accumulator.decendList()
        } else if (c == " ") {
            accumulator.completeWord(currentWord)
            currentWord = ""
        } else if (c == ")") {
            accumulator.completeWord(currentWord)
            currentWord = ""
            accumulator.ascendList()
        } else {
            currentWord.append(c)
        }
    }
    
    return accumulator.toElement()
}

