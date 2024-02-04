//
//  Election.swift
//  Ballot
//
//  Created by Anatole Debierre on 01/02/2024.
//

import Foundation
import SwiftUI

public typealias Opinion = (Double, Double)

public func mindToSpace(proxy: GeometryProxy, opinion: Opinion) -> CGPoint {
    let frame = proxy.frame(in: .local)
    let dim = frame.width - CANDIDATE_SIZE
    let half = dim / 2
    
    let x = frame.midX + opinion.0 * half
    let y = frame.midY - opinion.1 * half
    
    return CGPoint(x: x, y: y)
}

public func spaceToMind(proxy: GeometryProxy, location: CGPoint) -> Opinion {
    let frame = proxy.frame(in: .local)
    let dim = frame.width - CANDIDATE_SIZE
    let half = dim / 2
    
    let x: Double = (location.x - frame.midX) / half
    let y: Double = -(location.y - frame.midY) / half
    
    return (x, y)
}

public func distance(a: Entity, b: Entity) -> Double {
    sqrt(pow(a.opinion.0 - b.opinion.0, 2) + pow(a.opinion.1 - b.opinion.1, 2))
}


public struct Election {
    var candidates: [Candidate]
    var voters: [Voter] = Voter.populate(density: 0.1)
    
    func pluralityTally() -> [Dictionary<Candidate, Int>.Element] {
        // For each voter, add count to voter
        var counts = Dictionary(uniqueKeysWithValues: candidates.map { ($0, 0) })
        for v in voters {
            let choice = v.findClosest(candidates: candidates)
            if (choice != nil) { counts[choice!]! += 1 }
        }
        let sorted = counts.sorted(by: { $0.value < $1.value })
        return sorted
    }
    
    mutating func move(candidateId: String, newOpinion: Opinion) {
        candidates = candidates.map { c in
            if c.id == candidateId {
                let newC = Candidate(id: c.id, opinion: newOpinion, name: c.name, color: c.color)
                return newC
            } else { return c }
        }
    }
}

public protocol Entity {
    var id: String { get }
    var opinion: Opinion { get set }
}


public struct Candidate: Entity, Hashable {
    public var id: String = UUID().uuidString
    public var opinion: Opinion
    
    public let name: String
    public let color: Color
    
    
    // Make it hashable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func generate(count: Int = 1) -> [Candidate] {
        var candidates: [Candidate] = []
        for _ in 1...count {
            let (color, name) = generateColorPair(not: candidates.map { $0.color })
            let opinion = (Double.random(in: -1...1), Double.random(in: -1...1))
            let candidate = Candidate(opinion: opinion, name: name, color: color)
            candidates.append(candidate)
        }
        return candidates
    }
    
}

public struct Voter: Entity, Hashable {
    public var id: String = UUID().uuidString
    public var opinion: Opinion
    
    // Make it hashable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    public func findClosest(candidates: [Candidate]) -> Candidate? {
        let distances = candidates.map { ($0, distance(a: self, b: $0)) }
        let closest = distances.min(by: { $0.1 < $1.1 })
        
        return closest?.0
    }
    
    static func populate(density: Double) -> [Voter] {
        var voters: [Voter] = []
        // Add 1 voter every [density] on the x and y axis
        for x in stride(from: -1, to: 1 + density, by: density) {
            for y in stride(from: -1, to: 1 + density, by: density) {
                voters.append(Voter(opinion: (x, y)))
            }
        }
        
        return voters
    }
}

