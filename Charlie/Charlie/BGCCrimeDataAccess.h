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

@optional
-(void) crimeDataFillComplete: (NSArray *) crimeData;

@end

@interface BGCCrimeDataAccess : NSObject

@property (strong, nonatomic) NSArray * crimeData;
@property (assign, nonatomic) NSInteger beat;

-(void) fillCrimeDataFromServerASynchrously;

@end
