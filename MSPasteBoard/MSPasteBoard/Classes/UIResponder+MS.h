//
//  UIResponder+MS.h
//  MSPasteBoard
//
//  Created by Marshal on 2022/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (MS)
+ (void)hookClass:(Class)classObject originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
@end

NS_ASSUME_NONNULL_END
