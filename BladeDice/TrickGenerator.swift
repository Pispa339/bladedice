//
//  TrickGenerator.swift
//  BladeDice
//
//  Created by Juho Pispa on 24.05.20.
//  Copyright © 2020 Juho Pispa. All rights reserved.
//

import Foundation

struct TrickGenerator {
    
    // MARK: - Singleton
    
    static let shared = TrickGenerator()
    
    // MARK: = Properties
    
    private let trickContext = TrickContext.shared
    
    // MARK: - Factory Methods
    
    func makeRandomTrick() -> Trick? {
        guard let trickType = trickContext.enabledTrickTypes.randomElement() else {
            return nil
        }

        let spin: Trick.Spin? = trickContext.enabledTrickSpinsWithTrickType(trickType).randomElement()
        let side: Trick.Side? = trickContext.enabledTrickSidesWithTrickType(trickType).randomElement()
        let base: Trick.TrickBase? = trickContext.enabledTrickBasesWithTrickType(trickType).randomElement()
        
        guard let spin = spin, let side = side, let base = base else {
            return nil
        }
        
        return Trick(trickType: .soulPlate, trickBase: base, side: side, spin: spin)
    }
    
}
