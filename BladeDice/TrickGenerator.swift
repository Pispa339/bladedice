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
        
        let isSoulPlateTrick = trickType == .soulPlate
        
        let spin: Trick.Spin?
        let side: Trick.Side?
        let base: Trick.TrickBase?
        
        if isSoulPlateTrick {
            spin = trickContext.enabledSoulPlateTrickSpins.randomElement()
            side = trickContext.enabledSoulPlateSides.randomElement()
            base = trickContext.enabledSoulPlateBases.randomElement()
        } else {
            spin = trickContext.enabledHBlockTrickSpins.randomElement()
            side = trickContext.enabledHBlockSides.randomElement()
            base = trickContext.enabledHBlockBases.randomElement()
        }
        
        guard let spin = spin, let side = side, let base = base else {
            return nil
        }
        
        return Trick(trickType: .soulPlate, trickBase: base, side: side, spin: spin)
    }
    
}
