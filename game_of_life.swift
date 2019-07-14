#!/usr/bin/swift
//
//  game_of_life.swift
//  Kata3
//
//  Created by Radek Doležal on 13/07/2019.
//  Copyright © 2019 Radek Doležal. All rights reserved.
//

import Foundation

// MARK: - Extensions

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Way of life

func newGeneration(from generation: String) -> String {
    let lines = generation.components(separatedBy: "\n")
    let newGenerationLines = lines.enumerated().map { (index, currentLine) -> String in
        let previousLine = lines[safe: index-1]
        let nextLine = lines[safe: index+1]
        let newGenerationLine = currentLine.enumerated().map { (index, character) -> String.Element in
            let neighboursFromPreviousLine = [Array(previousLine ?? "")[safe: index - 1], Array(previousLine ?? "")[safe: index], Array(previousLine ?? "")[safe: index + 1]]
            let neighboursFromCurrentLine = [Array(currentLine)[safe: index - 1], Array(currentLine)[safe: index + 1]]
            let neighboursFromNextLine = [Array(nextLine ?? "")[safe: index - 1], Array(nextLine ?? "")[safe: index], Array(nextLine ?? "")[safe: index + 1]]
            let neighbours = (neighboursFromPreviousLine + neighboursFromCurrentLine + neighboursFromNextLine).compactMap { $0 }
            let liveNeighbours = neighbours.filter { $0 == "*" }
            
            switch (character, liveNeighbours.count) {
            case ("*", ..<2), ("*", 4...):
                return "."
            case ("*", 2...3), (".", 3):
                return "*"
            default:
                return "."
            }
        }
        return String(newGenerationLine)
    }
    let newGeneration = newGenerationLines.joined(separator: "\n")
    return newGeneration
}

func printGenerations(from firstGeneration: String, generationCount: Int) {
    print("Zygote\n\(firstGeneration)")
    var generation = firstGeneration
    (1...generationCount).forEach { generationNumber in
        generation = newGeneration(from: generation)
        print("Generation \(generationNumber):\n\(generation)")
    }
}


// MARK: - Execution

var inputFilePath: String?
var generationCount = 10

CommandLine.arguments.forEach { argument in
    if argument.starts(with: "--input=") {
        guard let argumentStartIndex = argument.firstIndex(of: "=") else {
            return
        }
        let inputStartIndex = argument.index(argumentStartIndex, offsetBy: 1)
        inputFilePath = String(argument[inputStartIndex...])
    } else if argument.starts(with: "--generationCount=") {
        guard let argumentStartIndex = argument.firstIndex(of: "=") else {
            return
        }
        let generationCountStartIndex = argument.index(argumentStartIndex, offsetBy: 1)
        generationCount = Int(String(argument[generationCountStartIndex...])) ?? 10
    }
}

guard let inputFilePath = inputFilePath else {
    fatalError("Error: Wrong input!")
}

let inputFileUrl = URL(fileURLWithPath: inputFilePath)

do {
    let input = try String(contentsOf: inputFileUrl)
    printGenerations(from: input, generationCount: generationCount)
} catch {
    fatalError(error.localizedDescription)
}
