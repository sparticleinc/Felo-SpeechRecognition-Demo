//
//  ViewController.m
//  TestFeloRecognition
//
//  Created by lee on 2022/9/24.
//

#import "ViewController.h"
#import <FeloRecognition/FeloRecognition.h>
#import "SubTitleViewController.h"
@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userId;
@property (weak, nonatomic) IBOutlet UITextField *bzid;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userId.delegate = self;

    [self.view endEditing:YES];
}


- (IBAction)joinConversization:(id)sender {
    if( [self.userId.text isEqualToString:@""] || [self.bzid.text isEqualToString:@""]){
        [self showAlert:@"请输入房间ID或者用户ID"];
        return;
    }
        [self createRoom];
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




- (void)createRoom {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SubTitleViewController *viewcontroller = (SubTitleViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SubTitleViewController"];
    viewcontroller.userId = self.userId.text;
    viewcontroller.roomId = self.bzid.text;
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.bzid.text = textField.text;
    }else if (textField.tag == 1001) {
        self.userId.text = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
