import Combine

@MainActor
class EntryController: ObservableObject {
    private var count = 0
    @Published private(set) var entries: [Entry] = []
    private let vendor = AsyncEntryVendor()
}

extension EntryController {
    /*
     func next() {
     count += 1
     Task {
     let newEntry = await vendor.entry(for: count)
     entries.append(newEntry)
     }
     }*/
    
    func next() {
        count += 1
            Task {
             let newEntry = await vendor.entry(for: count)
                print("DONE -2")
              entries.append(newEntry)
                
       }
        print("DONE")
        
    }
}
