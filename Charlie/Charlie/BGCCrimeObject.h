//
//  BGCCrimeObject.h
//  Charlie
//
//  Created by Adam Gluck on 7/12/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BGCCrimeObject : NSObject 

@property (assign, nonatomic) double probability;
@property (assign, nonatomic) NSInteger time;
@property (strong, nonatomic) CLLocation * location;

-(BGCCrimeObject *) initWithProbability: (double) probability time: (NSInteger) time andLocation: (CLLocation *) location;

@end
