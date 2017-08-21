//
//  VJResponderChangeableScrollView.m
//  DTCoreText
//
//  Created by Vincent on 2017/7/18.
//  Copyright © 2017年 Drobnik.com. All rights reserved.
//

#import "VJResponderChangeableScrollView.h"
@interface VJResponderChangeableScrollView()<UIGestureRecognizerDelegate>

@end
@implementation VJResponderChangeableScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(BOOL)delaysContentTouches{
    return YES;
}
//delaysContentTouches
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
    NSLog(@"touchesBeganaaaaaaaaa");
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesMoved:touches withEvent:event];
    NSLog(@"touchesMoveeeeeeeee");
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
//    [super motionBegan:motion withEvent:event];
//    NSLog(@"motionBeganaaaaaaaaa");
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
//    [super motionEnded:motion withEvent:event];
//    NSLog(@"motionEndddddddddddd");
}

-(BOOL)reading{
    return (self.contentOffset.y>0);
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
    
//    UIPanGestureRecognizer *gesture;
//    if ([gestureRecognizer isEqual:self.panGestureRecognizer] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        gesture = (UIPanGestureRecognizer*)gestureRecognizer;
//        
//        CGPoint vel = [gesture velocityInView:self];
//        if (vel.y > 0) {
//            if (self.contentOffset.y <= 0) {
//                NSLog(@"Velocity:%f",vel.y);
//                NSLog(@"ContentOffset:%f",self.contentOffset.y);
//                //            NSLog(@"Velocity:%f",vel.y);
//                //            NSLog(@"ContentOffset:%f",self.contentOffset.y);
//                return YES;
//            }
//        }
//    }
//
//    
//    return NO;
    
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//        UIPanGestureRecognizer *gesture;
//        if ([gestureRecognizer isEqual:self.panGestureRecognizer] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//            NSLog(@"%@ maybe failure",NSStringFromClass([otherGestureRecognizer class]));
////            return YES;
//            gesture = (UIPanGestureRecognizer*)gestureRecognizer;
//    
//            CGPoint vel = [gesture velocityInView:self];
//            if (vel.y > 0) {
//                if (self.contentOffset.y <= 0) {
//                    NSLog(@"Velocity:%f",vel.y);
//                    NSLog(@"ContentOffset:%f",self.contentOffset.y);
//                    //            NSLog(@"Velocity:%f",vel.y);
//                    //            NSLog(@"ContentOffset:%f",self.contentOffset.y);
//                    return YES;
//                }
//            }
//        }
//    
//        
//        return NO;
//}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    NSLog(@"scrollview hit");
    UIView *view = [super hitTest:point withEvent:event];
//    UIResponder *responder = [self nextResponder];
//    if(YES){
//        responder = [responder nextResponder];
//        
//        if ([responder isKindOfClass:[UIViewController class]]) {
//            view = ((UIViewController *)responder).view;
//        }
//    }
    
    return view;
}
@end
