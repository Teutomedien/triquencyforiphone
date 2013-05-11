//
//  playlistSong.h
//  triquencyforiphone
//
//  Created by Christoph Wolff on 17.04.13.
//  Copyright (c) 2013 Christoph Wolff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface playlistSong : NSObject
{
    NSDictionary *Title;
    NSDictionary *Artist;
    NSDictionary *Time;

}

@property (nonatomic, retain) NSDictionary *Title;
@property (nonatomic, retain) NSDictionary *Artist;
@property (nonatomic, retain) NSDictionary *Time;
@end
