import Foundation

class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
    
}

enum ValidatorType {
    
    case mobile
    case otp
    case firstName
    case lastName
    case email
    case password
    case confirmPassword
    case username
    case requiredField(field: String)
    case age
    case gender
    case country
    case referral
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .mobile: return MobileValidator()
        case .otp: return OTPValidator()
        case .firstName: return FirstValidator()
        case .lastName: return LastValidator()
        case .email: return EmailValidator()
        case .password: return PasswordValidator()
        case .confirmPassword: return ConfirmPasswordValidator()
        case .username: return UserNameValidator()
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        case .age: return AgeValidator()
            
        case .gender:
            return GenderValidator()
        case .country:
            return CountryValidator()
        case .referral:
            return ReferralCodeValidator()
        }
    }
}

//"J3-123A" i.e
struct ProjectIdentifierValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        do {
            if try NSRegularExpression(pattern: "^[A-Z]{1}[0-9]{1}[-]{1}[0-9]{3}[A-Z]$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid Project Identifier Format")
            }
        } catch {
            throw ValidationError("Invalid Project Identifier Format")
        }
        return value
    }
}


class AgeValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError("Age is required")}
        guard let age = Int(value) else {throw ValidationError("Age must be a number!")}
        guard value.count < 3 else {throw ValidationError("Invalid age number!")}
        guard age >= 18 else {throw ValidationError("You have to be over 18 years old to user our app :)")}
        return value
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
            throw ValidationError("Required field " + fieldName)
        }
        return value
    }
}

struct UserNameValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count >= 3 else {
            throw ValidationError("Username must contain more than three characters" )
        }
        guard value.count < 18 else {
            throw ValidationError("Username shoudn't conain more than 18 characters" )
        }
        
       /*do {
            if try NSRegularExpression(pattern: "^[a-z]{1,18}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Invalid username, username should not contain whitespaces, numbers or special characters")
            }
        } catch {
            throw ValidationError("Invalid username, username should not contain whitespaces,  or special characters")
        }*/
        return value
    }
}

struct ConfirmPasswordValidator: ValidatorConvertible {
    
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("Confirm Password is Required")}
        guard value.count >= 6 else { throw ValidationError("Confirm Password must have at least 6 characters") }
        return value
    }
    
}
struct PasswordValidator: ValidatorConvertible {
    
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError("Password is Required")}
        guard value.count >= 4 else { throw ValidationError("Password must have at least 4 characters") }
        
        /* do {
         if try NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
         throw ValidationError("Password must be more than 6 characters, with at least one character and one numeric character")
         }
         } catch {
         throw ValidationError("Password must be more than 6 characters, with at least one character and one numeric character")
         }*/
        return value
    }
}

struct EmailValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        do {
            let emailRegex = try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive)
            let textRange = NSRange(location: 0, length: value.count)
            if emailRegex.firstMatch(in: value, options: [], range: textRange) == nil {
                throw ValidationError("Invalid e-mail Address")
            }
        } catch  {
            throw ValidationError("Invalid e-mail Address")
        }
        
        return value
    }
}


// Email

//TODO:
struct MobileValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty, value.count == 10 else {
            throw ValidationError("Please enter the valid mobile number" )
        }
        return value
    }
}

struct OTPValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty, value.count == 6 else {
            throw ValidationError("Please enter 6-digit valid OTP number" )
        }
        return value
    }
}

struct FirstValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {
            throw ValidationError("Please enter the first name" )
        }
        return value
    }
}

struct LastValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {
            throw ValidationError("Please enter the last name" )
        }
        return value
    }
}

struct GenderValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {
            throw ValidationError("Please enter the Gender" )
        }
        return value
    }
}

struct CountryValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {
            throw ValidationError("Please enter the Country" )
        }
        return value
    }
}

struct ReferralCodeValidator: ValidatorConvertible {
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {
            throw ValidationError("Please enter the Referral Code" )
        }
        return value
    }
}
