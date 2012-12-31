//
//  CalculatorBrain.h
//  Calculator
//
//  Created by developer on 12/13/12.
//  Copyright (c) 2012 Gal Steinitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (double)calculateSine;
- (double)calculateCosine;
- (double)calculateSquareRoot;
- (double)calculatePi;
- (void)clear;

@end
