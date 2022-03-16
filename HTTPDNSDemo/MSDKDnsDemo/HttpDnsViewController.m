/**
 * Copyright (c) Tencent. All rights reserved.
 */

#import "HttpDnsViewController.h"
#import <MSDKDns_C11/MSDKDns.h>

@interface HttpDnsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *Domain;
@property (strong, nonatomic) IBOutlet UITextView *resultTextView;

@end

@implementation HttpDnsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _resultTextView.layoutManager.allowsNonContiguousLayout= NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)clearCache:(id)sender {
    [[MSDKDns sharedInstance] clearCache];
    _resultTextView.text = @"缓存清理完成。";
}


-(IBAction)getHostByName:(id)sender {
    _resultTextView.text = @"";
    [_resultTextView insertText:[NSString stringWithFormat:@"\n输入域名：%@，准备开始解析...", [_Domain text]]];
    NSArray *domains = [self getQueryDomains];
    NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
//    NSDictionary* result = [[MSDKDns sharedInstance] WGGetHostsByNames:domains];
        NSDictionary* result = [[MSDKDns sharedInstance] WGGetAllHostsByNames:domains];
    NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
    if (result && [result count] > 0) {
        NSString* str = [NSString stringWithFormat:@"\n解析结果为：\n %@\n 解析耗时：%fms",result, (time2 - time1) * 1000];
        [_resultTextView insertText:str];
        [_resultTextView scrollRangeToVisible:NSMakeRange(_resultTextView.text.length, 1)];
    } else {
        [_resultTextView insertText:@"本次解析失败，请再次请求一次。"];
        [_resultTextView scrollRangeToVisible:NSMakeRange(_resultTextView.text.length, 1)];
    }
}
- (IBAction)getHostByNameAsync:(id)sender {
    _resultTextView.text = @"";
    [_resultTextView insertText:[NSString stringWithFormat:@"\n输入域名：%@，准备开始解析...", [_Domain text]]];
    NSArray *domains = [self getQueryDomains];

    NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
//    [[MSDKDns sharedInstance] WGGetHostsByNamesAsync:domains returnIps:^(NSDictionary *ipsDict) {
    [[MSDKDns sharedInstance] WGGetAllHostsByNamesAsync:domains returnIps:^(NSDictionary *ipsDict) {
        NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
        if (ipsDict && [ipsDict count] > 0) {
            NSString* str = [NSString stringWithFormat:@"\n解析结果为：\n %@\n 解析耗时：%fms",ipsDict,  (time2 - time1) * 1000];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_resultTextView insertText:str];
                [_resultTextView scrollRangeToVisible:NSMakeRange(_resultTextView.text.length, 1)];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_resultTextView insertText:@"本次解析失败，请再次请求一次。"];
                [_resultTextView scrollRangeToVisible:NSMakeRange(_resultTextView.text.length, 1)];
            });
        }
    }];
}

- (NSArray *)getQueryDomains {
    NSString *inputStr = [_Domain text];
    if (inputStr.length > 0) {
        return [inputStr componentsSeparatedByString:@","];
    }
    return @[];
}

@end
