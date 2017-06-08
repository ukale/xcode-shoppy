//
//  StoreItem.h
//  Shoppy
//
//  Created by Admin Dev on 6/6/17.
//  Copyright © 2017 Kinetic Bytes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreItem : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* price;
@property (nonatomic, strong) NSString* imageName;
@property (nonatomic, strong) NSString* status;

+ (instancetype)itemWithName:(NSString*)name price:(NSNumber*)price image:(NSString*)image status:(NSString*) status;

+ (instancetype)itemWithDictionary:(NSDictionary*)dict;

@end
