//
//  CreateClientViewModel.swift
//  SolCalc
//
//  Created by Jomo Smith on 10/5/22.
//

import Foundation
import Combine



final class CreateClientViewModel: ObservableObject {
    
  // Input values from View
  @Published var clientName = ""
  @Published var monthlyBill = ""
  
  // Output subscribers
  @Published var formIsValid = false
  
  private var publishers = Set<AnyCancellable>()
  
  init() {
    isSignupFormValidPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.formIsValid, on: self)
      .store(in: &publishers)
  }
}

// MARK: - Setup validations
private extension CreateClientViewModel {
    
  var isClientNameValidPublisher: AnyPublisher<Bool, Never> {
    $clientName
      .map { name in
          return name.count >= 5
      }
      .eraseToAnyPublisher()
  }
  

  
  var isMonthlyBillValidPublisher: AnyPublisher<Bool, Never> {
    $monthlyBill
      .map { bill in
          return bill.count >= 4
      }
      .eraseToAnyPublisher()
  }
  
    var isSignupFormValidPublisher: AnyPublisher<Bool, Never> {
      Publishers.CombineLatest(
        isClientNameValidPublisher,
        isMonthlyBillValidPublisher)
        .map { isNameValid, isEmailValid in
            return isNameValid && isEmailValid
        }
        .eraseToAnyPublisher()
    }
  }
