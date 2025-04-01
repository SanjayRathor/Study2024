//
//  SwiftUIStudyTests.swift
//  SwiftUIStudyTests
//
//  Created by Sanjay Rathor on 27/02/25.
//

import Testing
///https://leocoout.medium.com/welcome-swift-testing-goodbye-xctest-7501b7a5b304
///

private extension Tag {
  @Tag static var jobBidding: Self
}


/* @Suite("Job Offer Success Tests")
struct JobOfferViewModelTests {
  /*
   let sut = Calculator()

    @Test("Given correct user number and password, should return success")
     func myFirstTest() {
        sut.make()
        #expect(sut.myAddition(2, 2) == 4)
    }
    
    @Test(.tags(.jobBidding)) func myFTwoTest() {
      #expect(1 == 1)
    }
    
    @Test(.bug("https://atlassian.net/jira/software/ZM/123", "Fix something..."))
    func myThreeTest() {
      #expect(3 == 3)
    }
   */
    
    @Test(.disabled("This test is crashing, please fix"), .bug("https://atlassian.net/jira/software/ZM/123", "Fix failing unit test"))
    func callPassengere() {
        print("callPassengere")
    }
    
    @Test(.enabled(if: FeatureFlag.isCallPassengerEnabled))
    func callFeatureFlag() {
        print("callFeatureFlag")
    }
    
    @Test(.timeLimit(.minutes(3)))
    func callTimeLimitPassenger() {
        print("callTimeLimitPassenger")
    }
 
   @Test( "Given different payment type, should display correct alert",
      arguments: [PaymentType.creditCard, .payNow, .debitCard, .onBoard]
    )
    func displayAlertMessage(paymentType: PaymentType) {
        let sut = PaymentAdditionalItemViewModel(payment: .fixture(type: paymentType))
      //  #expect(sut.payment.description == paymentType.testDescription)
    }
    
    /*
   @Test(arguments: [
     (TaxiRideType.metered, Driver.fixture(name: "Joel")),
     (TaxiRideType.normal, Driver.fixture(name: "Chong"))
   ])
   
   @Test(arguments: [
     .zip(TaxiRideType.metered, Driver.fixture(name: "Joel")),
     .zip(TaxiRideType.normal, Driver.fixture(name: "Chong"))
   ])
     @Test("When trying to pay without internet, should display noInternet error")
     func payment() throws {
       #expect(throws: ErrorEnvelope.noInternet.self) {
         try sut.doPaymentUseCase()
       }
     }
     @Test("When trying to pay with internet, should not throw errors")
     func payment() throws {
       #expect(throws: Never.self) {
         try sut.doPaymentUseCase()
       }
     }
     
     @Test func fetchJobDetails() async {
       jobServiceSpy.serviceToBeReturned = .success(.fixture(jobNo: "0"))

       await confirmation(expectedCount: 1) { incrementCounter in
          jobServiceSpy.serviceCounterHandler = { incrementCounter() } // Trigger this counter every time the service is called
          await sut.fetchJobDetails()
       }

       #expect(jobServiceSpy.jobDetails.jobNo == "12345")
       #expect(sut.jobData?.jobNo == "0")
     }
     
     @Test uploadTrip() {
       guard let tripData = sut.uploadTripData else {
         Issue.record("uploadTripData not available")
       }
       #expect(tripData.jobNo == "12345")
     }

     // Prefer using this
     @Test uploadTrip() {
       let tripData = try #require(sut.uploadTripData)
       #expect(tripData.jobNo == "12345")
     }
     
     
    */
    
}

struct Payment {
    let type: PaymentType
        let description: String  // ✅ Added description property

        /// Fixture method for test cases
        static func fixture(type: PaymentType = .creditCard, description: String = "Default Payment") -> Payment {
            return Payment(type: type, description: description)
        }
}

struct FeatureFlag {
    static let isCallPassengerEnabled = true
}

enum PaymentType: String, CustomTestStringConvertible {
    
    case creditCard, debitCard, payNow, onBoard
    var testDescription: String {
        "Payment of type \(rawValue) used"
    }
}

class PaymentAdditionalItemViewModel {
    let payment: Payment

    init(payment: Payment) {
        self.payment = payment
    }
}

/*
 struct SwiftUIStudyTests {
 @Test func myTest() {
 print("askmdas")
 }
 
 /*
  Traits
  Traits are a very useful feature of Swift Testing which enables
  us to add detailed metadata and control the conditions under
  which tests are executed. By adding metadata to our tests, we
  can add things like a display name, bug ticket reference,
  Traits can also help organize out of tests into tags, which can be
  particularly useful for grouping tests by certain criteria such as
  functionality.
  */
 
 @Test func validExpectation() async throws {
 #expect(1 == 1)
 ///#require
 ///must be marked as throwing, and the try keyword must
 //he #require macro focuses on conditions that must be satisfied for the test to proceed.
 let one: Int? = 10
 let two: String? = nil
 let willSucceed = try #require(one)
 let willFail = try #require(two)
 }
 
 
 @Suite("Suite Example")
 struct Project_Test {
 @Test func myTest() {
 // Test code here
 }
 }
 
 
 //    //Issue in bug tracker
 //    @Test(.bug("FML1234", "A Bug"))
 //    //Custom Tag
 //    @Test(.tag(.critical))
 //    //Conditionally enable or Unconditionally disable
 //    @Test(.enabled(if: required.isTrue))
 //    @Test(.disabled("Test Broken"))
 //Maximum time for test
 //  @Test(.timeLimit(.minutes(2)))
 
 }
 */
struct TestValues {
    let first: Double
    let second: Double
    let answer: Double
}

@Suite("Calculator test")
struct Calculator_Test {
    
//    @Test func simpleAdditionTest() {
//        #expect(Calculator.addition(2, 2) == 4)
//        
//    }
    
    @Test("asd Tests", arguments: [
        TestValues(first: 2, second: 3, answer: 5),
        TestValues(first: 10, second: 11, answer: 21),
        TestValues(first: 3.5, second: 4.5, answer: 8)
    ])
    
    func easd(_ values: TestValues)  {
        #expect(Calculator.addition(values.first, values.second) == values.answer)
    }
                                
}

 Using Swift Testing:
 XCTFail was replaced byIssue.record()
 XCTUnwrap was replaced by #require
 // Avoid using this
 @Test uploadTrip() {
   guard let tripData = sut.uploadTripData else {
     Issue.record("uploadTripData not available")
   }
   #expect(tripData.jobNo == "12345")
 }

 // Prefer using this
 @Test uploadTrip() {
   let tripData = try #require(sut.uploadTripData)
   #expect(tripData.jobNo == "12345")
 }
*/
