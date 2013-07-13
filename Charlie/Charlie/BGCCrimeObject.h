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

@property (assign, nonatomic) NSInteger probability;
@property (assign, nonatomic) NSInteger time;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end
