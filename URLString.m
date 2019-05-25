//
//  URLString.m
//  YRProject
//
//  Created by GoodWill on 2016/10/14.
//  Copyright © 2016年 GoodWill. All rights reserved.
//

#import "URLString.h"

@implementation URLString

+ (NSString *)encodeUrl:(NSString *)url {
    return [self lyj_URLEncode:url];
}

+ (NSString *)lyj_URLEncode:(NSString *)url {
    
    NSString *newString =
    (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)url,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    
    if (newString) {
        return newString;
    }
    
    return url;
}



@end
