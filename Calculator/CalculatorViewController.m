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
- (void)AddToHistory:(NSString *)historyText;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredADecimalPoint = _userHasEnteredADecimalPoint;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)AddToHistory:(NSString *)textToAddToHistory
{
    self.history.text = [NSString stringWithFormat:@"%@ %@", self.history.text, textToAddToHistory];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredADecimalPoint = NO;
    
    [self AddToHistory:self.display.text];
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    [self AddToHistory:operation];
}

- (IBAction)decimalPointPressed {
    if (!self.userHasEnteredADecimalPoint) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
        self.userHasEnteredADecimalPoint = YES;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)sinPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }

    double result = [self.brain calculateSine];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)cosPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }

    double result = [self.brain calculateCosine];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)sqrtPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    double result = [self.brain calculateSquareRoot];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)piPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];

    double pi = [self.brain calculatePi];
    self.display.text = [NSString stringWithFormat:@"%g", pi];
    [self.brain pushOperand:pi];
}

- (IBAction)clearPressed {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredADecimalPoint = NO;
    self.display.text = @"0";
    self.history.text = @"";
    [self.brain clear];
}

- (IBAction)backspacePressed {
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

@end
