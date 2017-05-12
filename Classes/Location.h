//
//  Location.h
//  RescueMe-SPL
//
//  Created by Larissa Rocha on 01/03/13.
//  Copyright 2013 UFBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoreLocationControllerDelegate
@required

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end

@interface Location : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locMgr;
	id delegate;
}

@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, assign) id _delegate;


@end

