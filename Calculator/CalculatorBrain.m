//
//  CalculatorBrain.m
//  Calculator
//
//  Created by developer on 12/13/12.
//  Copyright (c) 2012 Gal Steinitz. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSArray *)validOperators
{
    return [NSArray arrayWithObjects:@"Sqrt", @"-", @"*", @"/", @"+", @"π", @"Sin", @"Cos", nil];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSLog(@"%@",program);
    return [program componentsJoinedByString:@" "];
}

- (void)pushDoubleOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariableOperand:(NSString *)operand
{
    [self.programStack addObject:operand];
}

- (void)pushOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
}

//- (double)performOperation:(NSString *)operation
//{
//    [self.programStack addObject:operation];
//    return [[self class] runProgram:self.program];
//}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSNumber *zero = [[NSNumber alloc] initWithDouble:0];
    
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    
    id objectToAdd;
    
    for(id entry in program)
    {
        if ([entry isKindOfClass:[NSString class]] && ![self.validOperators containsObject:entry])
        {
            id value = [variableValues valueForKey:entry];
            objectToAdd = (value ? value : zero);
        } else {
            objectToAdd = entry;
        }
        [stack addObject:objectToAdd];
    }
    return [self runProgram:stack];
}

+(double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
                     [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
                      [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"Sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"Cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"Sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"π"]) {
            // reference: http://en.wikipedia.org/wiki/Pi
            result = 103993.0/33102.0;
        }
    }
    
    return result;
}

- (void)clear
{
    [self.programStack removeAllObjects];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableArray *variablesInProgram = [[NSMutableArray alloc] init];
    
    for(id entry in program) {
        if ([entry isKindOfClass:[NSString class]] && ![CalculatorBrain.validOperators containsObject:entry]) {
            [variablesInProgram addObject:entry];
        }
    }
    return [[NSSet alloc] initWithArray:variablesInProgram];
}

@end
