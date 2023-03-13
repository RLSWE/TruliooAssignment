//
//  LoginViewControllerTests.swift
//  TruliooAssignmentTests
//
//  Created by Roni Leshes on 12/03/2023.
//

import XCTest
@testable import TruliooAssignment

final class AuthProviderSpy: AuthProvider{
    var loginCalled = false
    var loginArgs: (username: String, password: String)?
    
    var registerCalled = false
    var registerArgs: (username: String, password: String)?
    
    func login(username: String, password: String) -> String? {
        loginCalled = true
        loginArgs = (username, password)
        return nil
    }
    
    func register(username: String, password: String) -> String? {
        registerCalled = true
        registerArgs = (username, password)
        return nil
    }
}

class LoginViewControllerTestsBase: XCTestCase {
    var sut: LoginViewController!
    override func setUp() {
        guard let loginViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "login") as? LoginViewController else {
            fatalError("Unable to Instantiate View Controller")
        }
        loginViewController.loadView() // In order to load all subviews (Including IBOutlets). Otherwise those are nil at that point.
        sut = loginViewController
    }
}

final class LoginViewControllerInputTests: LoginViewControllerTestsBase{
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
        sut.loginButtonPressed(self)
        
        XCTAssertFalse(spy.loginCalled)
    }
    
    func testPasswordFieldEmptyDoesNotCallAuthProvider(){
        sut.usernameTextField.text = username
        sut.passwordTextField.text = ""
        sut.loginButtonPressed(self)
        
        XCTAssertFalse(spy.loginCalled)
    }

    func testBothFieldsAreFilledCallsAuthProviderWithCorrectArgs(){
        sut.usernameTextField.text = username
        sut.passwordTextField.text = password
        
        sut.loginButtonPressed(self)
        
        XCTAssertTrue(spy.loginCalled)
        XCTAssertTrue(spy.loginArgs! == (username, password))
    }
}
