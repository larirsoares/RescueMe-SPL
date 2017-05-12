//
//  Location.m
//  RescueMe-SPL
//
//  Created by Larissa Rocha on 01/03/13.
//  Copyright 2013 UFBA. All rights reserved.
//

#import "Location.h"


@implementation Location

@synthesize locMgr, _delegate;

- (id)init {
	self = [super init];
	
	if(self != nil) {
		self.locMgr = [[CLLocationManager alloc] init];
		self.locMgr.delegate = self;
	}
	
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self._delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
		[self._delegate locationUpdate:newLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self._delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
		[self._delegate locationError:error];
	}
}

- (void)dealloc {
//	[self.locMgr release];
//	[super dealloc];
}

@end

