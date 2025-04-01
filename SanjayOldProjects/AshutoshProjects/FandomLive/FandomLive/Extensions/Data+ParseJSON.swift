//
//  Data+ParseJSON.swift
import Foundation

extension Data {
    func parseJSON() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String : Any]
        } catch _ {
            return nil
        }
    }
    func parseJSONAsArray() -> [Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [Any]
        } catch _ {
            return nil
        }
    }
}
