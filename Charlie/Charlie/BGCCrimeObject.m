//
//  BGCCrimeObject.m
//  Charlie
//
//  Created by Adam Gluck on 7/12/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import "BGCCrimeObject.h"

@implementation BGCCrimeObject

-(BGCCrimeObject *) initWithProbability: (double) probability time: (NSInteger) time andLocation: (CLLocation *) location {
    
    self = [super init];
    
    if (self){
        self.probability = probability;
        self.time = time;
        self.location = [location copy];
    }
    
    return self;
}

@end
