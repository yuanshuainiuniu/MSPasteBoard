//
//  UIResponder+MS.m
//  MSPasteBoard
//
//  Created by Marshal on 2022/7/29.
//

#import "UIResponder+MS.h"
#import <objc/runtime.h>

@implementation UIResponder (MS)
#if TARGET_IPHONE_SIMULATOR
static __weak id currentFirstResponder;
+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
   currentFirstResponder = self;
}

+ (void)load{
    [self hookClass:UITextField.class originalSelector:@selector(paste:) swizzledSelector:@selector(ms_paste:)];
    [self hookClass:UITextView.class originalSelector:@selector(paste:) swizzledSelector:@selector(ms_textViewPaste:)];

}
+ (void)hookClass:(Class)classObject originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class class = classObject;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    if (didAddMethod) {
        originalMethod = class_getInstanceMethod(class, originalSelector);
    }
    method_exchangeImplementations(swizzledMethod, originalMethod);
}
- (void)ms_paste:(id)sender{
    [self zt_rootVCPerformCommand:nil callback:^(BOOL open) {
        if (open) {
            
        }else{
            [self ms_paste:sender];
        }
    }];
}
- (void)ms_textViewPaste:(id)sender{
    [self ms_textViewPaste:sender];
    [self zt_rootVCPerformCommand:nil callback:^(BOOL open) {
        if (open) {
            
        }else{
            [self ms_paste:sender];
        }
    }];
}
- (void)zt_rootVCPerformCommand:(UIKeyCommand *)command callback:(void(^)(BOOL open))callback
{
    if ([self isSimuLator]) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8123/getPasteboardString"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"GET";
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"======error:服务未开启！");
                    if (callback) {
                        callback(NO);
                    }
                } else {
                    if (callback) {
                        callback(YES);
                    }
                    NSString *pasteString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    UIResponder* aFirstResponder = [UIResponder currentFirstResponder];
                    if ([aFirstResponder isKindOfClass:[UITextField class]]) {
                        [(UITextField *)aFirstResponder setText:pasteString];
                    } else if ([aFirstResponder isKindOfClass:[UITextView class]]) {
                        [(UITextView *)aFirstResponder setText:pasteString];
                    } else {
                        
                    }
                }
            });
            
        }];
        
        [task resume];
    }
}
- (BOOL)isSimuLator{
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE) {
        return YES;
    }
    return NO;
}
#endif
@end

