//
//  AccountService.swift
//  Study2024
//
//  Created by Sanjay Rathor on 03/04/24.
//

import Foundation
///https://levelup.gitconnected.com/mobile-architectural-best-practices-in-action-user-story-1-e20c9efa7549
///
final class AccountService {
 /*
    static let shared: AccountService = AccountService()
    private init () {}
 
    func fetchData(requestParam: UserRequestParam) async -> (Data?, AccountServiceError?) {
        // The internal logic for fetching the data for the url
        // using network classes like urlsession, datatask
        return (Data(), nil)
    }
  
  */
}

/*
 extension AccountService: FetchUserOrder {
    func fetchOrder(userId: String) async -> Result<[UserOrders], UserOrdersError> {
        let (orders, error) = await AccountService.shared.fetchData(requestParam: UserRequestParam(userId))
                // Here the logic of converting data to type
                // Handling error
        return Result.success([])
    }
}

extension AccountService: FetchUserAddressess {
    func fetchAddresses(userId: String) async -> Result<[UserAddresses], UserAddressesError> {
        let (address, error) = await AccountService.shared.fetchData(requestParam: UserRequestParam(userId))
                // Here the logic of converting data to type
                // Handling error
        return Result.success([])
    }
}
*/

/*
 class UserOrderListViewModel {

     private let orderService: FetchUserOrder

     func fetchOrders(userId: String) async -> [OrderViewData] {
         let ordersResult = await orderService.fetchOrder(userId: "userId")
         // Here the logic of converting data to type
         // Handling error
         return []
     }
 }

 class UserAddressListViewModel {
     
     private let addressService: FetchUserAddressess
     init(addressService: FetchUserAddressess) {
         self.addressService = addressService
     }
     
     func fetchAddress(userId: String) async -> [AddressViewData] {
         let addressesResult = await addressService.fetchAddresses(userId: "userId")
         // Here the logic of converting data to type
         // Handling error
         return []
     }
 }
 
 protocol FetchUserOrder {
     func fetchOrder(userId: String) async -> Result<[UserOrders], UserOrdersError>
 }

 protocol FetchUserAddressess {
     func fetchAddresses(userId: String) async -> Result<[UserAddresses], UserAddressesError>
 }
 
 */
