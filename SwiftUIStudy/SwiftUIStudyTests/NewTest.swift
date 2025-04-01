//
//  NewTest.swift
//  SwiftUIStudyTests
//
//  Created by Sanjay Rathor on 03/03/25.
//

import Testing

class MyTestSuite {
let viewModel = ExercisesViewModel()
  init() {
    // do setup
    print("doing setup")
  }

  deinit {
    // do teardown
    print("doing teardown")
  }

  @Test func testWillPass() {
    print("running passing test")
    #expect(true, "This test will always pass")
  }

  @Test func testWillFail() {
    print("running failing test")
    #expect(1 == 2, "This test will always fail")
  }
    
    @Test("Test fetching exercises")
    func testFetchExercises() async throws {
      let exercises = try await viewModel.fetchExercises()
      #expect(exercises.count > 0, "Exercises should be fetched")
    }
    
    
    @Test("Validate that an error is thrown when exercises are missing") func throwErrorOnMissingExercises() async {
      await #expect(
        throws: FetchExercisesError.noExercisesFound, "An error should be thrown when no exercises are found",
        performing: { try await viewModel.fetchExercises() })
    }
}

enum FetchExercisesError: Error {
    case noExercisesFound
}

class ExercisesViewModel {
    func fetchExercises() async throws -> [String] {
        // Simulating API call with async delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec delay
        return ["Push-up", "Pull-up"]
    }
}

