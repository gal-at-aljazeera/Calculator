//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Gal Steinitz on 12/12/12.
//  Copyright (c) 2012 Gal Steinitz. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController

@synthesize display;

- (IBAction)sqrtPressed:(id)sender {
    NSLog(@"sqrt was clicked, yo!");
}
 
- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
//    NSLog(@"user touched %@", digit);
    self.display.text = [self.display.text stringByAppendingString:digit];
}

@end
