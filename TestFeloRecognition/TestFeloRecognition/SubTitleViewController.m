//
//  SubTitleViewController.m
//  TestFeloRecognition
//
//  Created by lee on 2022/9/28.
//

#import "SubTitleViewController.h"
#import <FeloRecognition/FeloRecognition.h>
#import "MBProgressHUD+Extension.h"
@interface SubTitleViewController ()<FeloSubtitleDelegate>
@property (nonatomic,strong) SpeechRecognModel *model;
@property (nonatomic,strong) NSString *sourceLang;
@property (strong, nonatomic) NSString *authToken;
@property (weak, nonatomic) IBOutlet UISegmentedControl *changeLangSeg;
@property (weak, nonatomic) IBOutlet UITextView *zhTextView;
@property (weak, nonatomic) IBOutlet UITextView *enTextView;
@property (weak, nonatomic) IBOutlet UITextView *jaTextView;
@property (weak, nonatomic) IBOutlet UITextView *koTextView;
@property (weak, nonatomic) IBOutlet UIButton *subTitleButton;
@property (strong, nonatomic) NSString *displayName;
@property (assign, nonatomic) BOOL isSubtitleOn;
@end

@implementation SubTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.userId isEqualToString:@""] || [self.roomId isEqualToString:@""]) {
        [self showAlert:@"请输入用户ID或房间ID"];
        return;
    }
    
    [self.changeLangSeg addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventValueChanged];
    self.subTitleButton.titleLabel.text = @"离开房间";
    //获取authtoken
    __weak typeof(self) weakSelf = self;
    [self getMockAuthToken:self.userId completeHandler:^(NSDictionary *rsp) {
        [MBProgressHUD showText:@"正在初始化房间..." toView:weakSelf.view];
        weakSelf.model = [[SpeechRecognModel alloc]init];
        weakSelf.model.delegate = weakSelf;
        weakSelf.model.autoConnect = YES;//网络断开重连开关
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (rsp == nil) {
            [MBProgressHUD showText:@"初始化房间失败..." toView:weakSelf.view];
            return;
        }
        dict[@"lang"]  = @"zh";
        dict[@"bzid"]  = weakSelf.roomId;
        dict[@"appId"] = rsp[@"app_id"];
        dict[@"accessToken"] = rsp[@"access_token"];
        dict[@"refreshToken"] = rsp[@"refresh_token"];
        dict[@"userId"] = rsp[@"user_id"];
        [weakSelf.model startSubtitle:dict completeHandler:^(BOOL flag) {
                
        }];
    }];
}

//mock接口，在集成时，需要集成方提供
- (void)getMockAuthToken:(NSString *)userID completeHandler:(void (^)(NSDictionary *))completeHandler {
    [[FeloNetWorkUtils manager] feloGetToken:[@"https://open.felo.me/api/rest/meet-open-auth/mock-gzJ27aX5/8rW5FMjTY?token=" stringByAppendingString:userID]  successed:^(id responseObject) {
        NSDictionary *respDict = (NSDictionary *)responseObject;
        BOOL succ = [respDict objectForKey:@"success"];
        if (succ) {
            completeHandler(respDict);
        } else {
            completeHandler(nil);
        }
        } failed:^(NSError *error) {
            completeHandler(nil);
        }];
}

- (IBAction)openSubtitle:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectButton:(id)sender {
    UISegmentedControl* control = (UISegmentedControl*)sender;
      switch (control.selectedSegmentIndex) {
          case 0:
              self.sourceLang = @"zh";
              break;
          case 1:
              self.sourceLang = @"en";
              break;
          case 2:
              self.sourceLang = @"ja";
              break;
          case 3:
              self.sourceLang = @"ko";
          default:
              break;
      }
    [self changeSubTitleLang];
}

#pragma mark common
- (void)showAlert:(NSString *)errorMsg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:errorMsg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:^{

        }];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (void)changeSubTitleLang {
    [MBProgressHUD showText:@"正在切换语言" toView:self.view];
    [self.model setLanguage:self.roomId language:self.sourceLang completeHandler:^(BOOL flag) {
        NSLog(@"changeSubTitleLang flag:%@",@(flag));
        [MBProgressHUD hideHUD];
    }];
}

- (void)closeSubTitle {
    [self.view endEditing:YES];
    [self.model leaveConversation:self.roomId completeHandler:^(BOOL flag) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self closeSubTitle];
}


#pragma mark FeloSubtitleDelegate

- (void)disconnectServer {
    [MBProgressHUD showText:@"网络已断开，字幕服务器无法正常使用，正在重连..." duration:2.0];
}

- (void)reconnectedServer {
    [MBProgressHUD showText:@"字幕服务器已连接" duration:2.0];
}

- (void)getSubtitle:(NSDictionary *)subTitle {
    NSString *transcribeText = subTitle[@"transcribeText"];
    NSArray *array = [self arrayWithJsonString:transcribeText];
    if ([self.displayName isEqualToString:@""]) {
        self.displayName = subTitle[@"displayName"];
    }
    for (NSDictionary *dict in array) {
        if ([subTitle[@"displayName"] isEqualToString:self.displayName]){
            if ([dict[@"language"] isEqualToString:@"zh-TW"]) {
                self.zhTextView.text = [[self.displayName stringByAppendingString:@": "] stringByAppendingString: dict[@"text"]];
            } else if ([dict[@"language"] isEqualToString:@"en-US"]) {
                self.enTextView.text = [[self.displayName stringByAppendingString:@": "] stringByAppendingString: dict[@"text"]];
            }else if ([dict[@"language"] isEqualToString:@"ja-JP"]) {
                self.jaTextView.text = [[self.displayName stringByAppendingString:@": "] stringByAppendingString: dict[@"text"]];
            }else if ([dict[@"language"] isEqualToString:@"ko-KR"]) {
                self.koTextView.text = [[self.displayName stringByAppendingString:@": "] stringByAppendingString: dict[@"text"]];
            }
        } else {
            self.displayName = subTitle[@"displayName"];
            if ([dict[@"language"] isEqualToString:@"zh-TW"]) {
                self.zhTextView.text = [[self.zhTextView.text stringByAppendingString:@"\n"] stringByAppendingString:[[self.displayName stringByAppendingString:@": "] stringByAppendingString: dict[@"text"]]];
            } else if ([dict[@"language"] isEqualToString:@"en-US"]) {
                self.enTextView.text = [[self.enTextView.text stringByAppendingString:@"\n"] stringByAppendingString:[[self.displayName stringByAppendingString:@": "] stringByAppendingString: dict[@"text"]]];
            }else if ([dict[@"language"] isEqualToString:@"ja-JP"]) {
                self.jaTextView.text = [[self.jaTextView.text stringByAppendingString:@"\n"] stringByAppendingString:[[self.displayName stringByAppendingString:@": "] stringByAppendingString: dict[@"text"]]];
            }else if ([dict[@"language"] isEqualToString:@"ko-KR"]) {
                self.koTextView.text = [[self.koTextView.text stringByAppendingString:@"\n"] stringByAppendingString:[[self.displayName stringByAppendingString:@": "] stringByAppendingString: dict[@"text"]]];
            }
        }
    }
}

- (id)arrayWithJsonString:(NSString *)string{
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                    error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

@end
