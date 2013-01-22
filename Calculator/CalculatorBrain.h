//
//  CalculatorBrain.h
//  Calculator
//
//  Created by developer on 12/13/12.
//  Copyright (c) 2012 Gal Steinitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushDoubleOperand:(double)operand;
- (void)pushVariableOperand:(NSString *)operand;

- (double)performOperation:(NSString *)operation;
- (void)clear;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
//+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
