//
//  func.c
//  Client
//
//  Created by qq on 2016/12/5.
//  Copyright © 2016年 qq. All rights reserved.
//

#include "func.h"

NSString* dic2str(NSDictionary* dic){
    NSError* error=nil;
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    
    if(error==nil && data!=nil){
        NSString* string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return string;
    }
    return nil;
}

NSString* makeJsCallString(NSString* funname,id params){
    
    if([params isKindOfClass:[NSString class]]){
        NSString* filtered=[(NSString*)params stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        return [NSString stringWithFormat:@"%@('%@')",funname,filtered];
    }else if([params isKindOfClass:[NSDictionary class]]){
        NSString* string = dic2str((NSDictionary*)params);
        if(string !=nil){
            return [NSString stringWithFormat:@"%@('%@')",funname,string];
        }
    }else if(params==nil){
        return [NSString stringWithFormat:@"%@()",funname];
    }
    return @"";
}



