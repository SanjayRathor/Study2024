struct AsyncEntryVendor  {
  func entry(for count: Int) async -> Entry {
    do {
      let imageName = try await imageName(for: count)
      return Entry(imageName: imageName)
    } catch {
      return errorEntry()
    }
  }
}

extension AsyncEntryVendor {
    
    private func imageName(for int: Int) async throws -> String {
        
        if int.isMultiple(of: 5) {
          throw MultipleOfFiveError(number: int)
        }
        let number = int % 51
        if #available(iOS 16.0, *) {
            try? await Task.sleep(for:
                    .seconds(Int.random(in: 2...6)))
        } else {
            // Fallback on earlier versions
        }
        return "\(number).circle"
    }


//    private func imageName(for int: Int) async -> String {
//        let number = int % 51
//        if #available(iOS 16.0, *) {
//            try? await Task.sleep(for:
//                    .seconds(Int.random(in: 2...6)))
//        } else {
//            // Fallback on earlier versions
//        }
//        return "\(number).circle"
//    }
    
//  func imageName(for int: Int) async throws -> String {
//    if int.isMultiple(of: 5) {
//      throw MultipleOfFiveError(number: int)
//    }
//    let number = int % 51
//    return await number.description + suffix()
//  }
}

fileprivate func suffix() async -> String {
    if #available(iOS 16.0, *) {
        try? await Task.sleep(for:
                .seconds(Int.random(in: 2...6)))
    } else {
        // Fallback on earlier versions
    }
  return ".circle"
}

