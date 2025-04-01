
//: Playground - noun: a place where people can play
import UIKit

enum ValidationError: Error {
    
    case ErrorPassword (leghthIssue:String)
    case ErrorEmpty
    case ErrorNone
}

func validateUserInputs(message:String) throws ->NSString? {
    
    if message == " " {
        throw (ValidationError.ErrorEmpty)
    } else if (message.characters.count < 5) {
        throw (ValidationError.ErrorPassword(leghthIssue: "password length is short"))
    }
    else if (message.characters.count > 16) {
        throw (ValidationError.ErrorPassword(leghthIssue: "password length is too big"))
    }
    
    
    return ("Sanjay")
}

do {
   let  resultValue =  try validateUserInputs(message: "dasdasdasdasd ")
    print(resultValue ?? "Some thing went wrong")
}
catch ValidationError.ErrorEmpty
{
    print("ErrorEmpty")
}
catch ValidationError.ErrorPassword(let message) {
    print("Your password is obvious: \(message)")
}
catch ValidationError.ErrorNone
{
     print("ErrorNone")
}

