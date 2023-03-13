//
//  RegisterViewControllerTests.swift
//  TruliooAssignmentTests
//
//  Created by Roni Leshes on 12/03/2023.
//

import XCTest
@testable import TruliooAssignment

class RegisterViewControllerTestsBase: XCTestCase {
    var sut: RegisterViewController!
    override func setUp() {
        guard let registerViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "register") as? RegisterViewController else {
            fatalError("Unable to Instantiate View Controller")
        }
        registerViewController.loadView() // In order to load all subviews (Including IBOutlets). Otherwise those are nil at that point.
        sut = registerViewController
    }
}

final class RegisterViewControllerInputTests: RegisterViewControllerTestsBase{
    var spy: AuthProviderSpy!
    let username = "ArthurDent"
    let password = "42"
    
    override func setUp() {
        super.setUp()
        spy = AuthProviderSpy()
        sut.authProvider = spy
    }
    
    func testUsernameFieldEmptyDoesNotCallAuthProvider(){
        sut.usernameTextField.text = ""
        sut.registerButtonPressed(self)
        
        XCTAssertFalse(spy.registerCalled)
    }
    
    func testPasswordFieldEmptyDoesNotCallAuthProvider(){
        sut.usernameTextField.text = username
        sut.passwordTextField.text = ""
        sut.registerButtonPressed(self)
        
        XCTAssertFalse(spy.registerCalled)
    }
    
    func testPasswordVerificationFieldEmptyDoesNotCallAuthProvider(){
        sut.usernameTextField.text = username
        sut.passwordTextField.text = password
        sut.verifyPasswordTextField.text = ""
        sut.registerButtonPressed(self)
        
        XCTAssertFalse(spy.registerCalled)
    }
    
    func testNonMatchingPasswordsDoesNotCallAuthProvider(){
        sut.usernameTextField.text = username
        sut.passwordTextField.text = password
        sut.verifyPasswordTextField.text = "12341234"
        
        sut.registerButtonPressed(self)
        
        XCTAssertFalse(spy.registerCalled)
    }

    func testBothFieldsAreFilledCallsAuthProviderWithCorrectArgs(){
        sut.usernameTextField.text = username
        sut.passwordTextField.text = password
        sut.verifyPasswordTextField.text = password
        
        sut.registerButtonPressed(self)
        
        XCTAssertTrue(spy.registerCalled)
        XCTAssertTrue(spy.registerArgs! == (username, password))
    }
}
