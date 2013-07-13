//
//  BGCCrimeDataAccess.h
//  Charlie
//
//  Created by Adam Gluck on 7/12/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGCCrimeObject.h"

@protocol BGCCrimeDataAccessDelegate <NSObject>

-(void) crimeDataFillComplete: (NSArray *) crimeData;

@end

@interface BGCCrimeDataAccess : NSObject

@property (strong, nonatomic, readonly) NSArray * crimeData;
@property (assign, nonatomic) NSInteger beat;

-(void) fillCrimeDataFromServerASynchrously;

@end
