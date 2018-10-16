//
//  NetWorking.m
//  btc123
//
//  Created by jarze on 16/1/18.
//  Copyright © 2016年 btc123. All rights reserved.
//

#import "NetWorking.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NetWorking
+(void)requestWithApi:(NSString *)url param:(NSMutableDictionary *)param thenSuccess:(void (^)(NSDictionary *responseObject))success fail:(void (^)(void))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !success ? : success(responseObject);
        });

    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            !fail ? : fail();
        });
    }];
}
+(void)requestWithApi2:(NSString *)url param:(NSMutableDictionary *)param thenSuccess:(void (^)(NSDictionary *responseObject))success fail:(void (^)(void))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //调出请求头
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //将token封装入请求头
    NSString * string = [self md5:param];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"AUTHORIZATION"];
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !success ? : success(responseObject);
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            !fail ? : fail();
        });
    }];
}
+(NSString *)md5:(NSMutableDictionary *)param{
    NSString * string = [self DataTOjsonString:param];
    NSString * string1 = [NSString stringWithFormat:@"%@&secret_key=%@",string,@"EBFB1678244B4F3DAFBF32341866F20904247934FCA5C123"];
    NSString * stringMD5 = [LCMD5Tool MD5ForUpper32Bate:string1];
    return stringMD5;
}

+(NSString*)DataTOjsonString:(id)object
{
    NSString * str;
    int i = 0;
    NSDictionary * dic = (NSDictionary*)object;
    for (NSString *key in object) {
        //NSLog(@"%@",key);
        //[dic objectForKey:key];
        //NSLog(@"%@",dic[key]);
        if(i == 0){
            str = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        }else{
            str = [NSString stringWithFormat:@"%@=%@&%@",key,dic[key],str];
        }
        i++;
    }
    
    return str;
}

@end
