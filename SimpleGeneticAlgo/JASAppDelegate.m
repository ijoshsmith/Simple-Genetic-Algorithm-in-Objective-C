//
//  JASAppDelegate.m
//  SimpleGeneticAlgo
//
//  Created by Joshua Smith on 4/3/12.
//  Copyright (c) 2012 iJoshSmith. All rights reserved.
//

#import "JASAppDelegate.h"
#import "JASGeneticAlgo.h"

@implementation JASAppDelegate

@synthesize window = _window;
@synthesize textView = _textView;
@synthesize textField = _textField;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (IBAction)handleRunAlgorithmButton:(id)sender 
{
    [self.textView setString:@"Processing..."];
    [self performSelector:@selector(runAlgorithm) 
               withObject:nil 
               afterDelay:0.1];
}

- (void)runAlgorithm
{
    NSString *targetString = [self.textField stringValue];
    NSDate *start = [NSDate date];
    JASGeneticAlgo *algo = [[JASGeneticAlgo alloc] initWithTargetSequence:targetString];
    [algo execute];
    NSTimeInterval runtime = [start timeIntervalSinceNow] * -1;
    NSString *msg = [NSString stringWithFormat:
                     @"Output Sequence: %@\nElapsed Generations: %d\nDuration: %.2f seconds", 
                     algo.result, 
                     algo.generations, 
                     runtime];
    [self.textView setString:msg];
}

@end
