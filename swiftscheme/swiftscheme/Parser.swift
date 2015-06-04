//
//  Parser.swift
//  swiftscheme
//
//  Created by Sean Levin on 6/3/15.
//  Copyright (c) 2015 Sean Levin. All rights reserved.
//

import Foundation

public func parseWord(word: String) -> Element {
    // try to parse as a number if that isn't anything
    if word == "#f" {
        return .BoolEl(false)
    } else if word == "#t" {
        return .BoolEl(true)
    } else if let i = word.toInt() {
        return .IntEl(i)
    } else {
        return .SymbolEl(word)
    }
}

public func parse(code: String) -> Element {
    var listStack:[[Element]] = [[Element]]()
    var currentList:[Element]?
    var currentWord = ""
    for c in code {
        if (c == "(") {
            // if there is a current list push it on the stack
            if currentList != nil {
                listStack.append(currentList!)
            }
            // make a new list to build
            currentList = [Element]()
            
        } else if (c == " ") {
            // duplication with below, whats in common?
            if currentList != nil {
                if count(currentWord) != 0 {
                    currentList!.append(parseWord(currentWord))
                }
            }
            currentWord = ""
        } else if (c == ")") {
            if currentList != nil {
                // add the current word if something is being worked on
                if count(currentWord) != 0 {
                    currentList!.append(parseWord(currentWord))
                    currentWord = ""
                }
                // if theres a stack of lists
                if listStack.count > 0 {
                    // pop the top, add current to that
                    var popped:[Element] = listStack.removeLast()
                    popped.append(Element.ListEl(currentList!))
                    // and make the top the current
                    currentList = popped
                } else {
                    // otherwise we are done with last list
                    return Element.ListEl(currentList!)
                }
            } else {
                return Element.NilEl
            }
        } else {
            currentWord.append(c)
        }
    }
    // if we got here its malformed
    // unclosed list or no list at all
    return Element.NilEl
}

