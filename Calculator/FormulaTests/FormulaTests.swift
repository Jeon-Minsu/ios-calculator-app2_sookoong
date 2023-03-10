//
//  FormulaTests.swift
//  FormulaTests
//
//  Created by 전민수 on 2022/05/23.
//

import XCTest

class FormulaTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }


    func test_result_피연산수가_덧셈을_정상적으로_계산하는지_테스트() throws {
        // given
        let input = "1+2+3"
        let expectation: Double = 6
        
        // when
        var parser = ExpressionParser.parse(from: input)
        let result = try parser.result()

        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_result_피연산수가_뺄셈을_정상적으로_계산하는지_테스트() throws {
        // given
        let input = "1−2−3"
        let expectation: Double = -4
        
        // when
        var parser = ExpressionParser.parse(from: input)
        let result = try parser.result()

        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_result_피연산수가_곱셈을_정상적으로_계산하는지_테스트() throws {
        // given
        let input = "1×2×3"
        let expectation: Double = 6
        
        // when
        var parser = ExpressionParser.parse(from: input)
        let result = try parser.result()

        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_result_피연산수가_나눗셈을_정상적으로_계산하는지_테스트() throws {
        // given
        let input = "10÷2÷5"
        let expectation: Double = 1

        // when
        var parser = ExpressionParser.parse(from: input)
        let result = try parser.result()

        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_result_복수의_연산자와_피연산수가_혼합되어_있는_문자열값을_정상적으로_계산하는지_테스트() throws {
        // given
        let input = "10+2−3×4÷6"
        let expectation: Double = 6
        
        // when
        var parser = ExpressionParser.parse(from: input)
        let result = try parser.result()

        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_result_0으로_나눌때_오류처리가_정상적으로_이루어져_NaN의_값을_반환하는지_테스트() throws {
        // given
        let input = "100÷0"
        
        // when
        var parser = ExpressionParser.parse(from: input)

        // then
        XCTAssertThrowsError(try parser.result(), "divided by zero") { error in
            XCTAssertEqual(error as? CalculatorError, CalculatorError.dividedByZero)
        }
    }
    
    func test_result_사칙연산자가_아닌_문자열이_입력될때_오류처리가_정상적으로_이루어지는지_테스트() throws {
        // given
        let input = "100%0#21@"
        
        // when
        var parser = ExpressionParser.parse(from: input)

        // then
        XCTAssertThrowsError(try parser.result(), "invalid operator") { error in
            XCTAssertEqual(error as? CalculatorError, CalculatorError.invalidOperator)
        }
    }
    
    func test_result_피연산수도_연산자도_없는_빈_문자열일때_에러핸들링이_정상적으로_작동하는지_테스트() throws {
        // given
        let input = ""
        
        // when
        var parser = ExpressionParser.parse(from: input)

        // then
        XCTAssertThrowsError(try parser.result(), "empty queues") { error in
            XCTAssertEqual(error as? CalculatorError, CalculatorError.emptyQueues)
        }
    }
    
    
    func test_result_사칙연산자만으로_구성된_문자열이_입력될때_오류처리가_정상적으로_이루어지는지_테스트() throws {
        // given
        let input = "+−×÷"
        
        // when
        var parser = ExpressionParser.parse(from: input)

        // then
        XCTAssertThrowsError(try parser.result(), "not enough operands") { error in
            XCTAssertEqual(error as? CalculatorError, CalculatorError.notEnoughOperands)
        }
    }
    
    func test_result_피연산수만으로_구성된_문자열이_입력될때_오류처리가_정상적으로_이루어지는지_테스트() throws {
        // given
        let input = "101231240010281"
        
        // when
        var parser = ExpressionParser.parse(from: input)

        // then
        XCTAssertThrowsError(try parser.result(), "not enough operators") { error in
            XCTAssertEqual(error as? CalculatorError, CalculatorError.notEnoughOperators)
        }
    }
    
    func test_result_연산자와_피연산수가_올바른_순서를_따르지_않을때_오류처리가_정상적으로_이루어지는지_테스트() throws {
        // given
        let input = "+−×1÷123"
        
        // when
        var parser = ExpressionParser.parse(from: input)

        // then
        XCTAssertThrowsError(try parser.result(), "not enough operands") { error in
            XCTAssertEqual(error as? CalculatorError, CalculatorError.notEnoughOperands)
        }
    }
    
    func test_result_피연산수와_연산자가_아닌_값이_혼합된_문자열값에_대하여_에러처리가_정상적으로_이루어지는지_테스트() throws {    
        // given
        let input = "1223#1231555^!2!12231"
        
        // when
        var parser = ExpressionParser.parse(from: input)

        // then
        XCTAssertThrowsError(try parser.result(), "invalid operator") { error in
            XCTAssertEqual(error as? CalculatorError, CalculatorError.invalidOperator)
        }
    }
    
    func test_result_소수점_아래_자리수가_큰_피연산수를_입력받았을때_정상적으로_값이_출력되는지_테스트() throws {
        // given
        let input = "0.000001×0.000002"
        let expectation = 0.000001 * 0.000002
       
        // when
        var parser = ExpressionParser.parse(from: input)
        let result = try parser.result()

        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_result_실수인_수가_있는_피연산수를_입력받았을때_정상적으로_값이_출력되는지_테스트() throws {
        // given
        let input = "4.3+1÷5×10.2"
        let expectation = ((4.3 + 1) / 5) * 10.2
       
        // when
        var parser = ExpressionParser.parse(from: input)
        let result = try parser.result()

        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_result_음수로_시작하는_피연산수를_입력받았을때_정상적으로_값이_출력되는지_테스트() throws {
        // given
        let input = "-4.3+1÷5×10.2"
        let expectation = ((-4.3 + 1) / 5) * 10.2
       
        // when
        var parser = ExpressionParser.parse(from: input)
        let result = try parser.result()

        // then
        XCTAssertEqual(result, expectation)
    }
}
