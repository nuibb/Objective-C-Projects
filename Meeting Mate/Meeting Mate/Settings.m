//
//  Settings.m
//  bdipo
//
//  Created by Nascenia on 3/30/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "Settings.h"

@implementation Settings

- (id)init
{
    self = [super init];
    if (self)
    {
        //_hostName = @"http://www.mobioapp.net"; //@"192.168.1.178:3000";//
        
        _hostName = @"http://mobioappnetworks.com";
    }
    
    return self;
}

-(NSString *) getLogInUrl
{
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/apps/meeting_mate/index.php/jsons/varifylogin_old"];
}

-(NSString *) getMeetingInfo
{
    return [NSString stringWithFormat:@"%@%@", _hostName, @"/apps/meeting_mate/index.php/jsons"];
}

-(NSString *) getMeetingMemberList:(NSString *)_id
{
    return [NSString stringWithFormat:@"%@%@%@", _hostName, @"/apps/meeting_mate/index.php/jsons/get_memberinfo/", _id];
}

@end
