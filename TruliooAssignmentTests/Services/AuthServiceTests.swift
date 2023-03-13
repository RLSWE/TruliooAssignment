//
//  AuthServiceTests.swift
//  TruliooAssignmentTests
//
//  Created by Roni Leshes on 12/03/2023.
//

import XCTest
@testable import TruliooAssignment

final class AuthWorkerSpy: AuthWorker{
    var loginCalled = false
    var loginArgs: (username: String, password: String)?
    
    var registerCalled = false
    var registerArgs: (username: String, password: String)?
    
    func login(username: String, password: String) throws {
        loginCalled = true
        loginArgs = (username, password)
    }
    
    func register(username: String, password: String) throws {
        registerCalled = true
        registerArgs = (username, password)
    }
}

final class AuthWorkerDummy: AuthWorker{
    func login(username: String, password: String) throws {
        let error = KeychainAuthError.usernameNotFound(username: username)
        throw error
    }
    
    func register(username: String, password: String) throws {
        let error = KeychainAuthError.usernameAlreadyExists(username: username)
        throw error
    }
}

final class AuthServiceTests: XCTestCase {
    let username = "ArthurDent"
    let password = "42"
    
    // Login
    func testLoginCalls(){
        let authWorkerSpy = AuthWorkerSpy()
        let sut = AuthService(worker: authWorkerSpy)
        
        let _ = sut.login(username: username, password: password)
        XCTAssertTrue(authWorkerSpy.loginCalled)
        XCTAssert((username,password) == authWorkerSpy.loginArgs!)
    }
    
    func testLoginSuccessfullyReturnsNil(){
        let authWorkerSpy = AuthWorkerSpy()
        let sut = AuthService(worker: authWorkerSpy)
        
        let result = sut.login(username: username, password: password)
        XCTAssertNil(result)
    }
    
    func testLoginErrorReturnsTheErrorMessage(){
        let authWorkerDummy = AuthWorkerDummy()
        let sut = AuthService(worker: authWorkerDummy)
        
        let result = sut.login(username: username, password: password)
        XCTAssertEqual(result, KeychainAuthError.usernameNotFound(username: username).localizedDescription)
    }
    
    // Register
    func testRegisterCalls(){
        let authWorkerSpy = AuthWorkerSpy()
        let sut = AuthService(worker: authWorkerSpy)

        let _ = sut.register(username: username, password: password)
        XCTAssertTrue(authWorkerSpy.registerCalled)
        XCTAssert((username,password) == authWorkerSpy.registerArgs!)
    }
    
    func testRegisterSuccessfullyReturnsNil(){
        let authWorkerSpy = AuthWorkerSpy()
        let sut = AuthService(worker: authWorkerSpy)

        let result = sut.register(username: username, password: password)
        XCTAssertNil(result)
        XCTAssertTrue(authWorkerSpy.registerCalled)
        XCTAssert((username,password) == authWorkerSpy.registerArgs!)
    }

    func testRegisterErrorReturnsTheErrorMessage(){
        let authWorkerDummy = AuthWorkerDummy()
        let sut = AuthService(worker: authWorkerDummy)
        
        let result = sut.register(username: username, password: password)
        XCTAssertEqual(result, KeychainAuthError.usernameAlreadyExists(username: username).localizedDescription)
    }
}
