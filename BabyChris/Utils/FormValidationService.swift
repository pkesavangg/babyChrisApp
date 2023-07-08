//
//  FormValidationService.swift
//  BabyChris
//
//  Created by Kesavan Panchabakesan on 01/07/23.
//

import Foundation


enum ErrorType {
    case emptySpace, invalidEmail, passwordNotMatching, minLength(Int), maxLength(Int)
    var errorMessage: String {
        switch self {
        case .emptySpace:
            return "Must not leave blank"
        case .invalidEmail:
            return "Enter a valid email Id"
        case .passwordNotMatching:
            return "Password must match"
        case .minLength(let length):
            return "The input must be at least \(length) characters long."
        case .maxLength(let length):
            return "The input exceeds the maximum length of \(length)."
        }
    }
}

struct ValidationResult {
    let error: ErrorType?
    var isValid: Bool {
        return error == nil
    }
}

import Foundation
import SwiftUI
protocol ValidationRule {
    func isValid(_ value: String) -> ValidationResult
}

class FormValidator {
    func validate(_ value: String, validators: [ValidationRule]) -> ValidationResult {
        for validator in validators {
            let result = validator.isValid(value)
            if !result.isValid {
                return result
            }
        }
        return ValidationResult(error: nil)
    }
}


struct MaxLengthValidator: ValidationRule {
    let maxLength: Int
    
    func isValid(_ value: String) -> ValidationResult {
        if ((value.count > maxLength)){
            return ValidationResult(error: .maxLength(maxLength))
        }
        return ValidationResult(error: nil)
    }
}

struct MinLengthValidator: ValidationRule {
    let minLength: Int
    
    func isValid(_ value: String) -> ValidationResult {
        if ((value.count < minLength)){
            return ValidationResult(error: .minLength(minLength))
        }
        return ValidationResult(error: nil)
    }
}

struct MatchPasswordValidator: ValidationRule {
    let password: String
    
    func isValid(_ value: String) -> ValidationResult{
        if (value != password){
            return ValidationResult(error: .passwordNotMatching)
        }
        return ValidationResult(error: nil)
    }
}



struct EmptySpaceValidator: ValidationRule {
    func isValid(_ value: String) -> ValidationResult {
        if (value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            return ValidationResult(error: .emptySpace)
        }
        return ValidationResult(error: nil)
    }
}


struct EmailValidator: ValidationRule {
    func isValid(_ value: String) -> ValidationResult {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if (!emailPredicate.evaluate(with: value)){
            return ValidationResult(error: .invalidEmail)
        }
        return ValidationResult(error: nil)
    }
}


struct FormFieldModel {
    var value: String = ""
    var isValid: Bool = false
    var isUnfocused: Bool = false
    var isTouched: Bool = false
    var errorMessage: String = ""
}
