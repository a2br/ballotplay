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

public func mindToSpace(proxy: GeometryProxy, distance: Double) -> Double {
    let frame = proxy.frame(in: .local)
    let dim = frame.width - CANDIDATE_SIZE
    // half in real life, represents 1 in mind
    let half = dim / 2
    
    let d = distance * half
    
    return d
}

public func spaceToMind(proxy: GeometryProxy, location: CGPoint) -> Opinion {
    let frame = proxy.frame(in: .local)
    let dim = frame.width - CANDIDATE_SIZE
    let half = dim / 2
    
    let x: Double = (location.x - frame.midX) / half
    let y: Double = -(location.y - frame.midY) / half
    
    return (x, y)
}

public func distanceBetween(a: Entity, b: Entity) -> Double {
    sqrt(pow(a.opinion.0 - b.opinion.0, 2) + pow(a.opinion.1 - b.opinion.1, 2))
}

enum VotingSystem {
    case plurality
    case runoff
    case approval
}


public class Election: ObservableObject, Equatable {
    public static func == (lhs: Election, rhs: Election) -> Bool {
        lhs.candidates == rhs.candidates &&
        lhs.voters == rhs.voters &&
        lhs.votingSystem == rhs.votingSystem
    }
    
    @Published var candidates: [Candidate]
    @Published var voters: [Voter]
    @Published var votingSystem: VotingSystem
    
    // Counter for IRV
    // Tolerance for Approval
    @Published var round: Int
    @Published var tolerance: Double
        
    
    var candidateCount: Int {
        get {
            candidates.count
        }
        set {
            // How many to add ?
            let diff = newValue - candidates.count
            let abs = abs(diff)
            
            // Remove or add them
            if diff < 0 {
                for _ in 1...abs {
                    self.removeCandidate()
                }
            } else if diff > 0 {
                for _ in 1...abs {
                    self.addCandidate()
                }
            }
        }
    }
    
    var activeCandidates: [Candidate] {
        candidates.filter { !$0.ghost }
    }
    
    init(votingSystem: VotingSystem = .plurality, candidates: [Candidate] = Candidate.generate(count: 3), voters: [Voter] = Voter.populate(density: 1 / 8), round: Int = 0, tolerance: Double = 0.8) {
        
        self.candidates = candidates
        self.votingSystem = votingSystem
        self.voters = voters
                
        self.round = round
        self.tolerance = tolerance
    }
    

    func pluralityTally() -> [Dictionary<Candidate, Int>.Element] {
        // For each voter, add count to voter
        let activeCandidates = activeCandidates
        
        var counts = Dictionary(
            uniqueKeysWithValues: activeCandidates
                .map { ($0, 0) }
        )
        
        for v in voters {
            let choice = v.findClosest(candidates: activeCandidates)
            if (choice != nil) { counts[choice!]! += 1 }
        }
        let sorted = counts
            .sorted { $0.key.name < $1.key.name }
            .sorted(by: { $0.value > $1.value })
        return sorted
    }
    
    func approvalTally() -> [Dictionary<Candidate, Int>.Element] {
        // Active or inactive candidates don't matter, there are no rounds
        var counts = Dictionary(
            uniqueKeysWithValues: candidates
                .map { ($0, 0) }
        )
        
        for v in voters {
            for c in candidates {
                let d = v.distance(to: c)
                if d < tolerance {
                    counts[c]! += 1
                }
            }
        }
        
        let sorted = counts
            .sorted { $0.key.name < $1.key.name }
            .sorted(by: { $0.value > $1.value })
        
        return sorted
    }
    
    func approvalBallot(voter: Voter) -> [Candidate] {
        candidates.filter {
            voter.distance(to: $0) < tolerance
        }
    }
    
    func irvBallot(voter: Voter) -> [Candidate] {
        self.candidates.sorted { voter.distance(to: $0) < voter.distance(to: $1) }
    }
    
    func withoutWeakest() -> Election {
        let tally = pluralityTally()
        let weakest = tally.last!.key
        let newCandidates = candidates.map { c in
            if c == weakest {
                return Candidate(id: c.id, opinion: c.opinion, name: c.name, color: c.color, ghost: true, locked: c.locked)
            } else {
                return c
            }
        }
        
        return Election(votingSystem: votingSystem, candidates: newCandidates, voters: voters)
    }
    
    func irvRounds() -> [Election] {
        var election: Election = self.copy()
        election.votingSystem = .plurality
        
        var elections = [election]
                
        // Minimum number of votes for the last round
        let half = voters.count / 2
    
        while election.activeCandidates.count > 2 {
            // Check if 1st has > half -> it's the last round, break out
            let tally = election.pluralityTally()
            let head = tally.first!
            
            let strictMajority = head.value >= half
            
            if strictMajority {
                break
            }
            
            // Else, remove weakest
            election = election.withoutWeakest()
            elections.append(election)
        }
        
        return elections
        
    }
    
    func addCandidate() {
        let (color, name) = generateColorPair(not: candidates.map { $0.color })!
        candidates += [Candidate(opinion: randomOpinion(), name: name, color: color)]
    }
    
    func removeCandidate() {
        candidates.removeLast()
    }
    
    func push(_ e: Election) -> Void {
        votingSystem = e.votingSystem
        
        candidates = e.candidates
        voters = e.voters
        
        round = e.round
        tolerance = e.tolerance
    }
    
    func copy() -> Election {
        Election(
            votingSystem: votingSystem,
            candidates: candidates,
            voters: voters,
            round: round,
            tolerance: tolerance
        )
    }
}

public protocol Entity {
    var id: UUID { get }
    var opinion: Opinion { get set }
    
    func distance(to: Entity) -> Double
}

public func randomOpinion() -> Opinion {
    (Double.random(in: -1...1), Double.random(in: -1...1))
}


public struct Candidate: Entity, Hashable {
    public var id: UUID = UUID()
    public var opinion: Opinion
    
    public let name: String
    public let color: Color
    public var ghost: Bool = false
    
    public var locked: Bool = false
    
    
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
            let (color, name) = generateColorPair(not: candidates.map { $0.color })!
            let opinion = randomOpinion()
            let candidate = Candidate(opinion: opinion, name: name, color: color, locked: false)
            candidates.append(candidate)
        }
        return candidates
    }
    
    public func distance(to: Entity) -> Double {
        distanceBetween(a: self, b: to)
    }
    
}

public struct Voter: Entity, Hashable {
    public var id = UUID()
    public var opinion: Opinion
    
    // Make it hashable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    public func findClosest(candidates: [Candidate]) -> Candidate? {
        let distances = candidates.sorted { $0.name < $1.name }.map { ($0, self.distance(to: $0)) }
        let closest = distances.min(by: { $0.1 < $1.1 })
        
        return closest?.0
    }
    
    public func distance(to: Entity) -> Double {
        distanceBetween(a: self, b: to)
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

