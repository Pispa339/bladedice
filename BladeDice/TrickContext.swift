//
//  TrickContext.swift
//  BladeDice
//
//  Created by Juho Pispa on 08.04.22.
//  Copyright © 2022 Juho Pispa. All rights reserved.
//

import Foundation

class TrickContext {
    
    // MARK: - Nested Types
    
    class TrickCatalog {
        
        lazy var trickAttributeTypes: [Trick.TrickAttribute.TrickAttributeType] = Trick.TrickAttribute.TrickAttributeType.allCases
        
        lazy var trickTypes: [Trick.TrickType] = {
            Trick.TrickType.allCases
        }()
        lazy var trickBases: [Trick.TrickBase] = {
            Trick.TrickBase.allCases
        }()
        lazy var trickSides: [Trick.Side] = {
            Trick.Side.allCases
        }()
        lazy var trickSpins: [Trick.Spin] = {
            Trick.Spin.allCases
        }()
                
        lazy var trickTypeAttributes: [Trick.TrickAttribute] = {
            trickTypes.compactMap { .trickType(trickType: $0) }
        }()
        lazy var trickBaseAttributes: [Trick.TrickAttribute] = {
            trickBases.compactMap { .trickBase(trickBase: $0) }
        }()
        lazy var trickSideAttributes: [Trick.TrickAttribute] = {
            trickSides.compactMap { .side(side: $0) }
        }()
        lazy var trickSpinAttributes: [Trick.TrickAttribute] = {
            trickSpins.compactMap { .spin(spin: $0) }
        }()
        
        lazy var trickAttributes: [Trick.TrickAttribute] = {
            [trickTypeAttributes, trickBaseAttributes, trickSideAttributes, trickSpinAttributes].flatMap { $0 }
        }()
        
        lazy var trickAttributesByType: [Trick.TrickAttribute.TrickAttributeType: [Trick.TrickAttribute]] = {
            var dictionary: [Trick.TrickAttribute.TrickAttributeType: [Trick.TrickAttribute]] = [:]
            trickAttributes.forEach { trickAttribute in
                if dictionary[trickAttribute.type] == nil {
                    dictionary[trickAttribute.type] = [trickAttribute]
                } else {
                    dictionary[trickAttribute.type]?.append(trickAttribute)
                }
            }
            return dictionary
        }()
        
    }
    
    // MARK - Singleton
    
    static let shared = TrickContext()
    let trickCatalog = TrickCatalog()
    
    // MARK: - Properties
    
    private(set) var trickAttributesByEnabledState: [Trick.TrickAttribute: Bool]
    
    var isSoulPlateTricksEnabled: Bool {
        trickAttributesByEnabledState[.trickType(trickType: .soulPlate)] ?? true
    }
    
    var isHBlockTricksEnabled: Bool {
        trickAttributesByEnabledState[.trickType(trickType: .hBlock)] ?? true
    }
    
    func isTrickTypeEnabled(_ trickType: Trick.TrickType) -> Bool {
        trickAttributesByEnabledState[.trickType(trickType: trickType)] ?? true
    }
    
    var enabledTrickTypes: [Trick.TrickType] {
        trickAttributesByEnabledState.compactMap { (trickAttribute, isEnabled) in
            guard case let .trickType(trickType) = trickAttribute, isEnabled else {
                return nil
            }
            return trickType
        }
    }
    
    var enabledTrickBases: [Trick.TrickBase] {
        trickAttributesByEnabledState.compactMap { (trickAttribute, isEnabled) in
            guard case let .trickBase(trickBase) = trickAttribute, isEnabled else {
                return nil
            }
            return trickBase
        }
    }
    
    var enabledTrickSides: [Trick.Side] {
        trickAttributesByEnabledState.compactMap { (trickAttribute, isEnabled) in
            guard case let .side(side) = trickAttribute, isEnabled else {
                return nil
            }
            return side
        }
    }
    
    var enabledTrickSpins: [Trick.Spin] {
        trickAttributesByEnabledState.compactMap { (trickAttribute, isEnabled) in
            guard case let .spin(spin) = trickAttribute, isEnabled else {
                return nil
            }
            return spin
        }
    }
    
    func enabledTrickAttributes(withType: Trick.TrickAttribute.TrickAttributeType) -> [Trick.TrickAttribute] {
        trickAttributesByEnabledState.compactMap { (trickAttribute, isEnabled) in
            guard trickAttribute.type == withType, isEnabled else {
                return nil
            }
            
            return trickAttribute
        }
    }
    
    var enabledSoulPlateTrickSpins: [Trick.Spin] {
        enabledTrickSpins.filter({ $0.isSoulPlateTrick })
    }
    
    var enabledSoulPlateSides: [Trick.Side] {
        enabledTrickSides.filter({ $0.isSoulPlateTrick })
    }
    
    var enabledSoulPlateBases: [Trick.TrickBase] {
        enabledTrickBases.filter({ $0.isSoulPlateTrick })
    }
    
    var enabledHBlockTrickSpins: [Trick.Spin] {
        enabledTrickSpins.filter({ !$0.isSoulPlateTrick })
    }
    
    var enabledHBlockSides: [Trick.Side] {
        enabledTrickSides.filter({ !$0.isSoulPlateTrick })
    }
    
    var enabledHBlockBases: [Trick.TrickBase] {
        enabledTrickBases.filter({ !$0.isSoulPlateTrick })
    }
    
    // MARK: - Methods
    
    func canDisableTrickAttribute(_ trickAttribute: Trick.TrickAttribute) -> Bool {
        guard trickAttribute.type != .trickType else {
            return true
        }
        
        let enabledAttributesWithMatchingType = enabledTrickAttributes(withType: trickAttribute.type)
            .filter { $0.isSoulPlateAttribute == trickAttribute.isSoulPlateAttribute }
        return enabledAttributesWithMatchingType.count > 1
    }
        
    func updateEnabledState(forTrickAttribute trickAttribute: Trick.TrickAttribute, isEnabled: Bool) {
        switch trickAttribute {
        case .trickType(let trickType):
            updateEnabledStateForAllTrickAttributesForTrickType(trickType, isEnabled: isEnabled)
            let otherTrickType: Trick.TrickType = trickType == .soulPlate ? .hBlock : .soulPlate
            if !isTrickTypeEnabled(otherTrickType) && !isEnabled {
                updateEnabledStateForAllTrickAttributesForTrickType(otherTrickType, isEnabled: true)
            }
        case .trickBase, .side, .spin:
            guard !(!canDisableTrickAttribute(trickAttribute) && !isEnabled) else {
                return
            }
            trickAttributesByEnabledState[trickAttribute] = isEnabled
        }
    }
    
    private func updateEnabledStateForAllTrickAttributesForTrickType(_ trickType: Trick.TrickType, isEnabled: Bool) {
        let isSoulPlateTrickType = trickType == .soulPlate
        for (trickAttribute, isAttributeEnabled) in trickAttributesByEnabledState {
            switch trickAttribute {
            case .trickType(let trickType):
                switch trickType {
                case .soulPlate:
                    trickAttributesByEnabledState[.trickType(trickType: .soulPlate)] = isSoulPlateTrickType ? isEnabled : isAttributeEnabled
                case .hBlock:
                    trickAttributesByEnabledState[.trickType(trickType: .hBlock)] = isSoulPlateTrickType ? isAttributeEnabled : isEnabled
                }
            case .trickBase, .side, .spin:
                let isSoulPlateTypesEnabled = isSoulPlateTrickType ? isEnabled : isAttributeEnabled
                let isHBlockTypesEnabled = !isSoulPlateTrickType ? isEnabled : isAttributeEnabled
                trickAttributesByEnabledState[trickAttribute] = trickAttribute.isSoulPlateAttribute ? isSoulPlateTypesEnabled : isHBlockTypesEnabled
            }
        }
    }
    
    // MARK: - Init/Deinit
    
    private init() {
        var trickTypeAttributesByEnabledState: [Trick.TrickAttribute: Bool] = [:]
        var trickBaseAttributesByEnabledState: [Trick.TrickAttribute: Bool] = [:]
        var trickSideAttributesByEnabledState: [Trick.TrickAttribute: Bool] = [:]
        var trickSpinAttributesByEnabledState: [Trick.TrickAttribute: Bool] = [:]
        
        trickCatalog.trickTypeAttributes.forEach { trickTypeAttributesByEnabledState[$0] = true }
        trickCatalog.trickBaseAttributes.forEach { trickBaseAttributesByEnabledState[$0] = true }
        trickCatalog.trickSideAttributes.forEach { trickSideAttributesByEnabledState[$0] = true }
        trickCatalog.trickSpinAttributes.forEach { trickSpinAttributesByEnabledState[$0] = true }
        
        var trickAttributesByEnabledState: [Trick.TrickAttribute: Bool] = [:]
        [
            trickTypeAttributesByEnabledState,
            trickBaseAttributesByEnabledState,
            trickSideAttributesByEnabledState,
            trickSpinAttributesByEnabledState
        ].forEach { attributesByEnabledState in
            for (attribute, isEnabled) in attributesByEnabledState {
                trickAttributesByEnabledState[attribute] = isEnabled
            }
        }
        
        self.trickAttributesByEnabledState = trickAttributesByEnabledState
    }
    
}
