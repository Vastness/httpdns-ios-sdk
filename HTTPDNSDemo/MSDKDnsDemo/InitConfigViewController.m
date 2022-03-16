//
//  InitConfigViewController.m
//  MSDKDnsDemo
//
//  Created by vast on 2022/3/15.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "InitConfigViewController.h"
#import <MSDKDns_C11/MSDKDns.h>

@interface InitConfigViewController ()

@property (weak, nonatomic) IBOutlet UITextField *appIdText;
@property (weak, nonatomic) IBOutlet UITextField *dnsIdText;
@property (weak, nonatomic) IBOutlet UITextField *dnsKeyText;
@property (weak, nonatomic) IBOutlet UITextField *tokenText;
@property (weak, nonatomic) IBOutlet UITextField *timeoutText;
@property (weak, nonatomic) IBOutlet UITextField *ruoteIpText;
@property (weak, nonatomic) IBOutlet UITextField *retryText;
@property (weak, nonatomic) IBOutlet UITextField *switchText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *encryptTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *addressTypeControl;
@property (weak, nonatomic) IBOutlet UISwitch *debugSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *reportSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *httpOnlySwitch;
@property (weak, nonatomic) IBOutlet UITextField *preResolveDomainsText;

@end

@implementation InitConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadConfig {
    DnsConfig *config = new DnsConfig();
    config->dnsId = _dnsIdText.text ? [_dnsIdText.text intValue] : 0;
    config->dnsKey = _dnsKeyText.text;
    config->token = _tokenText.text;
    config->encryptType = [self getEncryptType];
    config->debug = YES;
    config->minutesBeforeSwitchToMain = [_switchText.text intValue];
    config->retryTimesBeforeSwitchServer = [_retryText.text intValue];
    config->enableReport = [_reportSwitch isOn];
    config->addressType = [self getAddrType];
    [[MSDKDns sharedInstance] initConfig: config];

    [[MSDKDns sharedInstance] WGSetPreResolvedDomains:[self getPreresolveDomains]];
}

- (HttpDnsEncryptType)getEncryptType {
    NSUInteger index = [_encryptTypeControl selectedSegmentIndex];
    if(index == 1) {
        return HttpDnsEncryptTypeAES;
    } else if(index == 2) {
        return HttpDnsEncryptTypeHTTPS;
    }
    return HttpDnsEncryptTypeDES;
}

- (HttpDnsAddressType)getAddrType {
    NSUInteger index = [_addressTypeControl selectedSegmentIndex];
    if(index == 1) {
        return HttpDnsAddressTypeIPv4;
    } else if(index == 2) {
        return HttpDnsAddressTypeIPv6;
    } else if(index == 3) {
        return HttpDnsAddressTypeDual;
    }
    return HttpDnsAddressTypeAuto;
}

- (NSArray*)getPreresolveDomains {
    NSString *text = _preResolveDomainsText.text;
    return text && text.length > 0 ? [text componentsSeparatedByString:@","] : nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self loadConfig];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
