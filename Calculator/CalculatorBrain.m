//
//  CalculatorBrain.m
//  Calculator
//
//  Created by developer on 12/13/12.
//  Copyright (c) 2012 Gal Steinitz. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack{
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (void)pushOperand:(double)operand
{
    NSLog(@"Pushing operand %g",operand);
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
    NSLog(@"Operand stack is %@",self.operandStack);
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    double operand = [operandObject doubleValue];
    NSLog(@"popOperand() - operandObject = %g",operand);
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    }
    
    [self pushOperand:result];
    
    return result;
}

- (double)calculateSine
{
    NSLog(@"calculateSine");
    return sin([self popOperand]);
}

- (double)calculateCosine
{
    NSLog(@"calculateSine");
    return cos([self popOperand]);
}

- (double)calculateSquareRoot
{
    return sqrt([self popOperand]);
}

- (double)calculatePi
{
    // reference: http://en.wikipedia.org/wiki/Pi
    return 103993.0/33102.0;
}

@end
