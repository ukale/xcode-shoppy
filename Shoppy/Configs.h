//
//  Configs.h
//  Shoppy
//
//  Created by Admin Dev on 6/6/17.
//  Copyright © 2017 Kinetic Bytes. All rights reserved.
//

#ifndef Configs_h
#define Configs_h


#define UIColorFromRGBA(rgbaValue) [UIColor colorWithRed:((float)((rgbaValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbaValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbaValue & 0xFF))/255.0 alpha:((float)((rgbaValue & 0xFF000000) >> 24))/255.0]


#endif /* Configs_h */
