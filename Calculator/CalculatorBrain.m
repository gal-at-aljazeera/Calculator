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

static NSSet *zeroOperandOperators;
static NSSet *oneOperandOperators;
static NSSet *twoOperandOperators;

+ (BOOL)isZeroOperandOperator:(NSString *)entry
{
    if (!zeroOperandOperators) zeroOperandOperators = [[NSSet alloc] initWithObjects:@"π", nil];
    return [zeroOperandOperators containsObject:entry];
}

+ (BOOL)isOneOperandOperator:(NSString *)entry
{
    if (!oneOperandOperators) oneOperandOperators = [[NSSet alloc] initWithObjects:@"Sqrt", @"Sin", @"Cos", nil];
    return [oneOperandOperators containsObject:entry];
}


+ (BOOL)isTwoOperandOperator:(NSString *)entry
{
    if (!twoOperandOperators) twoOperandOperators = [[NSSet alloc] initWithObjects:@"-", @"*", @"/", @"+", nil];
    return [twoOperandOperators containsObject:entry];
}

+ (BOOL)isOperator:(NSString *)entry
{
    return [self isZeroOperandOperator:entry] || [self isOneOperandOperator:entry] || [self isTwoOperandOperator:entry];
}

+ (BOOL)isVariable:(NSString *)entry
{
    return [entry isKindOfClass:[NSString class]] && ![self isOperator:entry];
}

+ (double)precedenceOf:(NSString *)operator
{
    if ([self isTwoOperandOperator:operator])
        return ([operator isEqualToString:@"*"] || [operator isEqualToString:@"/"]) ? 2 : 1;
    else
        return ([self isOneOperandOperator:operator]) ? 3 : 0;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSMutableArray *stack = [program mutableCopy];
    NSMutableArray *output = [[NSMutableArray alloc] init];
    
    while ([stack count]>0) {
        [output addObject:[self popOperandAndDescribe:stack withPrecedenceOfCaller:0]];
    }
    return [output componentsJoinedByString:@", "];
    
}
+ (NSString *)popOperandAndDescribe:(NSMutableArray *)stack withPrecedenceOfCaller:(double)precedenceOfCaller
{
    id entry = [stack lastObject];
    if (entry) [stack removeLastObject];
    
    
    if ([self isZeroOperandOperator:entry]) {
        return entry;
    } else if ([self isOneOperandOperator:entry]) {
        return [NSString stringWithFormat:@"%@(%@)",entry,[self popOperandAndDescribe:stack withPrecedenceOfCaller:0]];
    } else if ([self isTwoOperandOperator:entry]) {
        
        double precedence = [self precedenceOf:entry];
        NSString *format = (precedenceOfCaller > precedence) ? @"(%@ %@ %@)" : @"%@ %@ %@";
        
        id operator1 = [self popOperandAndDescribe:stack withPrecedenceOfCaller:precedence];
        id operator2 = [self popOperandAndDescribe:stack withPrecedenceOfCaller:precedence];
        return [NSString stringWithFormat:format,operator2,entry,operator1];
    } else {
        return [NSString stringWithFormat:@"%@",(entry ?: @"0")];
    }
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
        if ([self isVariable:entry])
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
        if ([self isVariable:entry]) {
            [variablesInProgram addObject:entry];
        }
    }
    return [[NSSet alloc] initWithArray:variablesInProgram];
}

@end
