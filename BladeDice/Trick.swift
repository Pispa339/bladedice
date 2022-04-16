//
//  Trick.swift
//  BladeDice
//
//  Created by Juho Pispa on 24.05.20.
//  Copyright © 2020 Juho Pispa. All rights reserved.
//

import Foundation

struct Trick {
    
    // MARK: - Nested Types
    
    enum TrickAttribute: Hashable {
        
        case trickType(trickType: TrickType)
        case trickBase(trickBase: TrickBase)
        case side(side: Side)
        case spin(spin: Spin)
        
        enum TrickAttributeType: Hashable, CaseIterable {
            case trickType
            case trickBase
            case side
            case spin
            
            var name: String {
                switch self {
                case .trickType:
                    return "Types"
                case .trickBase:
                    return "Bases"
                case .side:
                    return "Sides"
                case .spin:
                    return "Spins"
                }
            }
        }
        
        var name: String {
            switch self {
            case .trickType(let trickType):
                return trickType.rawValue.capitalized
            case .trickBase(let trickBase):
                return trickBase.rawValue.capitalized
            case .side(let side):
                return side.rawValue.capitalized
            case .spin(let spin):
                return spin.rawValue.capitalized
            }
        }
        
        var type: TrickAttributeType {
            switch self {
            case .trickType:
                return .trickType
            case .trickBase:
                return .trickBase
            case .side:
                return .side
            case .spin:
                return .spin
            }
        }
        
        var isSoulPlateAttribute: Bool {
            switch self {
            case .trickType(let trickType):
                return trickType == .soulPlate
            case .trickBase(let trickBase):
                return trickBase.isSoulPlateTrick
            case .side(let side):
                return side.isSoulPlateTrick
            case .spin(let spin):
                return spin.isSoulPlateTrick
            }
        }
        
    }
    
    enum TrickType: String, CaseIterable {
        case soulPlate = "Soul plate"
        case hBlock = "H-block"
    }
    
    enum TrickBase: String, CaseIterable {
        case soul
        case acid
        case mizou
        case pornstar
        
        case royale
        case nugen
        case unity
        case backslide
        case torque
        
        var isSoulPlateTrick: Bool {
            switch self {
            case .soul, .acid, .mizou, .pornstar:
                return true
            case .royale, .nugen, .unity, .backslide, .torque:
                return false
            }
        }
    }
    
    enum Side: String, CaseIterable {
        case soulside = "Normal soul (non-topside)"
        case topside
        
        case frontside
        case backside
        
        var isSoulPlateTrick: Bool {
            switch self {
            case .soulside, .topside:
                return true
            case .frontside, .backside:
                return false
            }
        }
    }
    
    enum Spin: String, CaseIterable {
        case alleyOop = "Alley oop"
        case truespin
        case inspin
        case outspin
        case threeSixty = "360"
        case hurricane
        case fullcab
        case fullTrue = "Fullcab truespin"
        
        case twoSeventy = "270"
        case fakieTwoSeventy = "Fakie 270"
        
        var isSoulPlateTrick: Bool {
            switch self {
            case .alleyOop, .truespin, .inspin, .outspin, .threeSixty, .hurricane, .fullcab, .fullTrue:
                return true
            case .twoSeventy, .fakieTwoSeventy:
                return false
            }
        }
    }
    
    // MARK: - Properties
    
    let trickType: TrickType
    let trickBase: TrickBase
    let side: Side
    let spin: Spin

}
