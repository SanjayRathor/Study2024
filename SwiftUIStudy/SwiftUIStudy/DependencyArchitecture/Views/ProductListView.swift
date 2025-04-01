//
//  ProductListView.swift
//  SanjayDesignPatterns
//
//  Created by Sanjay Rathor on 31/03/25.
//  Copyright © 2025 Sanjay Singh Rathor. All rights reserved.
//

import SwiftUI

struct ProductListView: View {
    @StateObject var viewModel: ProductViewModel

    init() {
        let remoteDataSource = ProductRemoteDataSourceImpl()
        let localDataSource = ProductLocalDataSourceImpl()
        let repository = ProductRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
        let useCase = ProductUseCaseImp(repository: repository)

        _viewModel = StateObject(wrappedValue: ProductViewModel(productUseCase: useCase))
    }

    var body: some View {
        VStack {
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            List(viewModel.products, id: \.id) { product in
                Text(product.name)
            }
        }
        .onAppear {
            viewModel.loadProducts()
        }
    }
}


#Preview {
    ProductListView()
}
