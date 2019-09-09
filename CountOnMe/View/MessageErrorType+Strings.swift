//
//  MessageErrorType+Strings.swift
//  CountOnMe
//
//  Created by Claire on 09/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension MessageErrorType {
    
    var message: String {
        switch self {
        case .lastCharacterIsAComma:
            return  "Une virgule est déja mise"
        case .impossibleDivisionByZero:
            return "Division par 0 impossible"
        case .lastCharacterIsAnOperator:
            return "Un operateur est déja mis !"
        case .expressionIsNotCorrect:
            return "Entrez une expression correcte !"
        case .expressionDoesNotHaveEnoughElement:
            return "Démarrez un nouveau calcul !"
        }
    }
    
    var title: String {
        switch self {
        case .lastCharacterIsAComma,
             .lastCharacterIsAnOperator,
             .expressionIsNotCorrect,
             .expressionDoesNotHaveEnoughElement:
            return "Erreur"
        case .impossibleDivisionByZero:
            return "Zéro!"
        }
    }
}
