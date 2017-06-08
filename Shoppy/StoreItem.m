//
//  StoreItem.m
//  Shoppy
//
//  Created by Admin Dev on 6/6/17.
//  Copyright © 2017 Kinetic Bytes. All rights reserved.
//

#import "StoreItem.h"

@implementation StoreItem

+ (instancetype) itemWithName:(NSString*)name price:(NSNumber*)price image:(NSString*)image status:(NSString*)status
{
    StoreItem* item = [[StoreItem alloc] init];
    item.name = name;
    item.price = price;
    item.imageName = image;
    item.status = status;
    return item;
}

+ (instancetype)itemWithDictionary:(NSDictionary*)dict {
    StoreItem* item = [[StoreItem alloc] init];
    item.status = [dict[@"status"] isKindOfClass:[NSNull class]] ? @"" : dict[@"status"];
    item.name = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"" : dict[@"name"];
    item.price = [dict[@"price"] isKindOfClass:[NSNumber class]] ? dict[@"price"] : @0;
    item.imageName = [dict[@"photo"] isKindOfClass:[NSNull class]] ? @"" : dict[@"photo"];
    return item;
}

@end
