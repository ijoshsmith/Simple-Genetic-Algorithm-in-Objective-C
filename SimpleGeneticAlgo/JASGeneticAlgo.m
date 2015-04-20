//
//  JASGeneticAlgo.m
//  SimpleGeneticAlgo
//
//  Created by Joshua Smith on 4/3/12.
//  Copyright (c) 2012 iJoshSmith. All rights reserved.
//

#import "JASGeneticAlgo.h"
#import "JASChromosome.h"

@interface JASGeneticAlgo ()

// Add private setters to public properties
@property (nonatomic, readwrite, strong) NSString *result;
@property (nonatomic, readwrite, assign) NSInteger generations;

// Private properties
@property (nonatomic, strong) NSMutableArray *population;
@property (nonatomic, copy) NSString *targetSequence;

// Private methods
- (void)populate;
- (void)run;
- (void)breedNextGeneration;
- (void)shufflePopulation;
- (void)analyzePopulation;

@end


@implementation JASGeneticAlgo

@synthesize generations;
@synthesize population;
@synthesize result;
@synthesize targetSequence;

#define MAX_GENERATIONS  1000 // Prevents infinite loops.
#define POPULATION_SIZE   750 // Must be an even number.

- (id)initWithTargetSequence:(NSString *)sequence
{
    self = [super init];
    if (self)
    {
        self.targetSequence = sequence;
        self.population = 
          [NSMutableArray arrayWithCapacity:POPULATION_SIZE];
    }
    return self;
}

- (void)execute
{
    [self populate];
    [self run];
}

#pragma mark - Private methods

- (void)populate
{
    NSUInteger geneCount = self.targetSequence.length;
    JASChromosome *chromo;
    for (int i = 0; i < POPULATION_SIZE; ++i)
    {
        chromo = [[JASChromosome alloc] initWithGeneCount:geneCount];
        [self.population addObject:chromo];
    }
}

- (void)run
{
    for (self.generations = 0; 
         self.generations < MAX_GENERATIONS && !self.result; 
         self.generations++)
    {
        [self breedNextGeneration];
        [self shufflePopulation];
        [self analyzePopulation];
    }
    
    --self.generations;
}

- (void)breedNextGeneration
{
    // Declare loop variables.
    NSUInteger index1, index2, deadIndex;
    JASChromosome *chromo1, *chromo2, *child;
    NSString *seq = self.targetSequence;
    BOOL keepFirst;
    NSUInteger count = self.population.count;
 
    // Mate each two successive chromosomes and
    // replace the less fit parent with the child.
    for (int i = 0; i < count; i += 2) 
    {
        index1 = i;
        index2 = i + 1;
        chromo1 = [self.population objectAtIndex:index1];
        chromo2 = [self.population objectAtIndex:index2];
        keepFirst = [chromo1 isFitterThanChromosome:chromo2 
                                  forTargetSequence:seq];
        deadIndex = keepFirst ? index2 : index1;
        child = [chromo1 mateWithChromosome:chromo2];
        [self.population replaceObjectAtIndex:deadIndex 
                                   withObject:child];
    }
}

- (void)shufflePopulation
{    
    for (int i = 0; i < population.count; i++) {
        [population exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((u_int32_t)population.count)];
    }
}

- (void)analyzePopulation
{
    // Find the fittest chromosome in the population 
    // and see if matches the target sequence.
    JASChromosome *champion = nil;
    NSString *seq = self.targetSequence;
    for (JASChromosome *contender in self.population) 
    {
        if (!champion || 
            [contender isFitterThanChromosome:champion 
                            forTargetSequence:seq])
        {
            champion = contender;
        }
    }
    NSString *fittest = champion.geneSequence;
    BOOL matchesTarget = [fittest isEqualToString:seq];
    if (matchesTarget)
    {
        self.result = fittest;
        NSLog(@"Matched the target sequence during generation #%ld", self.generations);
    }
    else 
    {
        NSLog(@"Fittest sequence for generation #%ld: %@", self.generations, fittest);
    }
}

@end
