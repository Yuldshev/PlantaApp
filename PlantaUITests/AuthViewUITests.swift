import XCTest

final class AuthViewUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuthViewInitialState() throws {
        // Check if background image exists
        XCTAssertTrue(app.images["appBg1"].exists)
        
        // Check if logo exists
        XCTAssertTrue(app.images["logo"].exists)
        
        // Check if title text exists
        XCTAssertTrue(app.staticTexts["Your Premier Destination for Lush Greenery: Elevate your space with our exceptional plant selection"].exists)
        
        // Check if email text field exists
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        
        // Check if login button exists and is disabled initially
        let loginButton = app.buttons["Login / Register"]
        XCTAssertTrue(loginButton.exists)
        XCTAssertFalse(loginButton.isEnabled)
        
        // Check if skip button exists
        XCTAssertTrue(app.buttons["Not now"].exists)
    }
    
    func testEmailInputValidation() throws {
        let emailTextField = app.textFields["Email"]
        
        // Test invalid email
        emailTextField.tap()
        emailTextField.typeText("invalid-email")
        
        // Button should remain disabled
        let loginButton = app.buttons["Login / Register"]
        XCTAssertFalse(loginButton.isEnabled)
        
        // Clear text
        emailTextField.tap()
        emailTextField.buttons["Clear text"].tap()
        
        // Test valid email
        emailTextField.typeText("test@example.com")
        
        // Wait for validation
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "isEnabled == true"),
            object: loginButton
        )
        wait(for: [expectation], timeout: 2.0)
        
        // Button should be enabled
        XCTAssertTrue(loginButton.isEnabled)
    }
    
    func testLoginFlow() throws {
        let emailTextField = app.textFields["Email"]
        
        // Enter valid email
        emailTextField.tap()
        emailTextField.typeText("test@example.com")
        
        // Wait for button to be enabled
        let loginButton = app.buttons["Login / Register"]
        let buttonEnabled = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "isEnabled == true"),
            object: loginButton
        )
        wait(for: [buttonEnabled], timeout: 2.0)
        
        // Tap login button
        loginButton.tap()
        
        // Wait for navigation
        let mainView = app.navigationBars["Main"]
        let navigationExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == true"),
            object: mainView
        )
        wait(for: [navigationExpectation], timeout: 5.0)
        
        // Verify navigation to main view
        XCTAssertTrue(mainView.exists)
    }
    
    func testSkipButton() throws {
        // Tap skip button
        app.buttons["Not now"].tap()
        
        // Wait for navigation
        let mainView = app.navigationBars["Main"]
        let navigationExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == true"),
            object: mainView
        )
        wait(for: [navigationExpectation], timeout: 5.0)
        
        // Verify navigation to main view
        XCTAssertTrue(mainView.exists)
    }
    
    func testErrorHandling() throws {
        let emailTextField = app.textFields["Email"]
        
        // Enter invalid email
        emailTextField.tap()
        emailTextField.typeText("invalid-email")
        
        // Try to login
        app.buttons["Login / Register"].tap()
        
        // Wait for error message
        let errorMessage = app.staticTexts.matching(identifier: "error").firstMatch
        let errorExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == true"),
            object: errorMessage
        )
        wait(for: [errorExpectation], timeout: 2.0)
        
        // Check if error message appears
        XCTAssertTrue(errorMessage.exists)
    }
    
    func testFocusState() throws {
        let emailTextField = app.textFields["Email"]
        
        // Initially background image should be visible
        XCTAssertTrue(app.images["appBg1"].exists)
        
        // Tap email field
        emailTextField.tap()
        
        // Wait for background image to hide
        let bgImage = app.images["appBg1"]
        let hideExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == false"),
            object: bgImage
        )
        wait(for: [hideExpectation], timeout: 2.0)
        
        // Background image should be hidden
        XCTAssertFalse(bgImage.exists)
        
        // Dismiss keyboard
        app.keyboards.buttons["return"].tap()
        
        // Wait for background image to show
        let showExpectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == true"),
            object: bgImage
        )
        wait(for: [showExpectation], timeout: 2.0)
        
        // Background image should be visible again
        XCTAssertTrue(bgImage.exists)
    }
} 