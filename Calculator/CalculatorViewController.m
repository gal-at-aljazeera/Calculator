//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Gal Steinitz on 12/12/12.
//  Copyright (c) 2012 Gal Steinitz. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasEnteredADecimalPoint;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
- (void)displayProgram;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize variableValuesDisplay = _variableValuesDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredADecimalPoint = _userHasEnteredADecimalPoint;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)displayProgram
{
    self.history.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed
{
    [self.brain pushDoubleOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredADecimalPoint = NO;
    
    [self displayProgram];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    [self pressEnterIfNeeded];
    [self.brain pushOperation:sender.currentTitle];
    [self runCurrentProgram];
    [self displayProgram];
}

- (void)runCurrentProgram
{
    double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)decimalPointPressed
{
    if (!self.userHasEnteredADecimalPoint) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
        self.userHasEnteredADecimalPoint = YES;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)clearPressed
{
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredADecimalPoint = NO;
    self.display.text = @"0";
    self.history.text = @"";
    [self.brain clear];
    self.testVariableValues = [[NSDictionary alloc] init];
    self.variableValuesDisplay.text = @"";
}

- (IBAction)backspacePressed
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        NSUInteger newLength = self.display.text.length-1;
        if (newLength==0) {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        } else {
            NSString *newString = [self.display.text substringToIndex:newLength];
            self.display.text = newString;
        }
    }
}

- (IBAction)plusMinusPressed
{
    double currentValue = [self.display.text doubleValue] * -1;
    self.display.text = [NSString stringWithFormat:@"%g",currentValue];
}

- (void)pressEnterIfNeeded
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
}

- (IBAction)variablePressed:(UIButton *)sender
{
    [self pressEnterIfNeeded];   
    [self.brain pushVariableOperand:sender.currentTitle];
    [self displayProgram];
}

- (IBAction)testPressed:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"Test 1"])
    {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:5], @"x",
                                   [NSNumber numberWithDouble:-5], @"a",
                                   [NSNumber numberWithDouble:100], @"b",
                                   nil];
    }
    else if ([sender.currentTitle isEqualToString:@"Test 2"])
    {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:100], @"x",
                                   [NSNumber numberWithDouble:3], @"a",
                                   nil];
    }
    else if ([sender.currentTitle isEqualToString:@"Test 3"])
    {
        self.testVariableValues = nil;
    }

    [self updateVariableValuesDisplay];
    [self runCurrentProgram];
}

- (void)updateVariableValuesDisplay
{
    NSSet *variables = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    NSDictionary *values = self.testVariableValues;
    NSMutableArray *output = [[NSMutableArray alloc] init];

    for(id variable in variables)
    {
        double value = [[values valueForKey:variable] doubleValue];
        [output addObject:[NSString stringWithFormat:@"%@ = %g",variable,value]];
    }
    
    self.variableValuesDisplay.text = [output componentsJoinedByString:@"  "];
}

@end
