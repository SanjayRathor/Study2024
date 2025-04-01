//
//  ViewModelTests.swift
//  SwiftUIStudyTests
//
//  Created by Sanjay Rathor on 04/03/25.
//

import Testing
import SwiftUIStudy
import Foundation

extension LoadError: @retroactive CustomTestStringConvertible {
    public var testDescription: String {
        switch self {
        case .notEnoughData:
            "At least three names should be loaded."
        case .tooMuchData:
            "No more than 1000 names are supported."
        }
    }
}


struct DataHandling {
    /*
     @Test("Loading view model names")
     func loadNames() async throws {
     let viewModel = TestViewModel(names: [])
     try await viewModel.loadNames()
     #expect(!viewModel.names.isEmpty, "Names should be full of values.")
     try #require(!viewModel.names.isEmpty, "Names should be full of values.")
     }
     */
    
    /*
     @Test("Loading view model names")
     func loadNames() async {
     let viewModel = TestViewModel(names: [])
     do {
     try await viewModel.loadNames()
     #expect(viewModel.names.isEmpty == false, "Names should be full of values.")
     } catch {
     Issue.record(error, "Between 3 and 1000 names are supported.")
     }
     }
     
     @Test("Loading view model names")
     func loadNames() async {
     let viewModel = TestViewModel(names: [])
     await #expect(throws: LoadError.self, "At least three names should be loaded.",
     performing: viewModel.loadNames)
     }
     
     
     @Test("Loading view model names")
     func loadNames() async {
     let viewModel = TestViewModel(names: [])
     await #expect(throws: LoadError.notEnoughData, "At least three names should be loaded.",
     performing:
     viewModel.loadNames)
     }
     */
    ///Swift Testing provides one extra useful option, which is the withKnownIssue() function. This
    ///expects an error to be thrown and will in fact fail your test if the error isn't thrown.
    
    
    /*  @Test("Loading view model names")
     func loadNames() async {
     let viewModel = TestViewModel(names: [])
     await withKnownIssue("Names can sometimes come back with too few values") {
     try await viewModel.loadNames()
     #expect(viewModel.names.isEmpty, "Names should be full of values.")
     }
     }
     
     @Test("Loading view model readings")
     func loadReadings() async {
     let viewModel = TestViewModel(names: [])
     
     await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
     viewModel.loadNames { readings in
     #expect(readings.count >= 10, "At least 10 readings must be returned.")
     continuation.resume()
     }
     }
     }
     */
    
    @Test("Loading view model names", .timeLimit(.minutes(1)))
    func loadNames() async throws {
        let viewModel = TestViewModel(names: [])
        try await viewModel.loadNames()
        #expect(!viewModel.names.isEmpty, "Names should be full of values.")
    }
    
    @Test func example() throws {
        let x = 10
        let y = 11
        try #require(x == y)  // the test halts only if this fails
        #expect(1 == 2, "xxxxxxxxxxxxxx")
    }

   /* @Test func brewTeaError() throws {
        let teaLeaves = TeaLeaves(name: "EarlGrey", optimalBrewTime: 3)

        do {
            try teaLeaves.brew(forMinutes: 100)
        } catch is BrewingError {
            // This is the code path we are expecting
        } catch {
            Issue.record("Unexpected Error")
        }
    }
    
    @Test func brewTeaError() throws {
        let teaLeaves = TeaLeaves(name: "EarlGrey", optimalBrewTime: 4)
        #expect(throws: BrewingError.oversteeped) {
            try teaLeaves.brew(forMinutes: 200) // We don't want this to fail the test!
        }
    }
    */
}


struct FeedViewModelTests {
/*  @Test func testFetchPosts() async throws {
    let viewModel = FeedViewModel(network: MockNetworkClient())
      await viewModel.fetchPosts()

        guard case .loaded(let posts) = viewModel.feedState else {
          Issue.record("Feed state is not set to .loaded")
          return
        }

     try #require(posts.count == 3)
  }
 @Test("File creation should go through all three steps before completing")
 func fileCreationCompletionHandler() async throws {
   await confirmation { confirm in
     let expectedSteps: [FileCreationStep] = [.fileRegistered, .uploadStarted, .uploadCompleted]
     var receivedSteps: [FileCreationStep] = []

     let manager = RemoteFileManager(onStepCompleted: { step in
       receivedSteps.append(step)
     })

     manager.createFile {
       #expect(receivedSteps == expectedSteps)
       confirm()
     }
   }
 }
*/
    
    @Test func fetchPostsShouldUpdateWithErrors() async throws {
      let client = MockNetworkClient()
      let expectedError = NSError(domain: "Test", code: 1, userInfo: nil)
      client.fetchPostsResult = .failure(expectedError)

      let viewModel = FeedViewModel(network: client)
      await viewModel.fetchPosts()

      guard case .error(let error) = viewModel.feedState else {
        Issue.record("Feed state is not set to .error")
        return
      }

      #expect(error as NSError == expectedError)
    }
}
