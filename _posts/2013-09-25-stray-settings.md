---
layout: post
title: Slide in UIViewController in iOS 7
---

I decided to redo the settings dialog for [Stray](http://itunes.apple.com/app/stray/id570951876?mt=8) and this is the end result, sure, there are some tweaks to made to the design, but i wanted something that slides in from the right.

![Settings dialog](http://cdn.artsoftheinsane.com/blog/iOS%20Simulator%20Screen%20shot%2027%20aug%202013%2019.16.31.png)

The swipe gesture was easy enough, but having recently watched some WWDC 2013 videos I decided to make use of the new animation frameworks.

So in order of how things happen

To show the controller i call this in the swipe gesture

	[self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PreferencesViewController"] animated:YES completion:nil];

In the controller i made sure to set

	self.modalPresentationStyle = UIModalPresentationCustom;
	self.transitioningDelegate = self;

`UIModalPresentationCustom` is the new modal presentation style in iOS 7 and it brings along a way to customize how controller is presented.

On the presented controller you make it conform the the `UIViewControllerTransitioningDelegate` protocol, in this case `PreferencesViewController` and you implemented these two methods

	- (id <UIViewControllerAnimatedTransitioning> )animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
		return [[PreferenceAnimationController alloc] init];
	}
	
	- (id <UIViewControllerAnimatedTransitioning> )animationControllerForDismissedController:(UIViewController *)dismissed {
		PreferenceAnimationController *controller = [[PreferenceAnimationController alloc] init];
		controller.isDismissed = YES;
	
		return controller;
	}

As you might have guessed, `PreferenceAnimationController` is were the magic happens. It's a class that conforms to the `UIViewControllerAnimatedTransitioning` protocol.

For a non interactive animation (oh yes, there are interactive one's to) you implement these two methods

	- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
	    UIView *inView = [transitionContext containerView];
	    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
	    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
	
	    if (self.isDismissed) {
	        UIView *preferenceOverlay = [inView viewWithTag:1];
	
	        [UIView animateWithDuration:0.4
	                              delay:0 options:UIViewAnimationOptionCurveEaseOut
	                         animations:^{
	            fromView.center = CGPointMake(-CGRectGetMidX(inView.frame), CGRectGetMidY(inView.frame));
	            preferenceOverlay.alpha = 0;
	        } completion:^(BOOL finished) {
	            [preferenceOverlay removeFromSuperview];
	            [fromView removeFromSuperview];
	            [transitionContext completeTransition:YES];
	        }];
	    } else {
	        UIView *preferenceOverlay = [self createOverlayViewWithFrame:inView.frame];
	        [inView addSubview:preferenceOverlay];
	
	        toView.center = CGPointMake(-CGRectGetMidX(inView.frame), CGRectGetMidY(inView.frame));
	        [inView addSubview:toView];
	
	        [UIView animateWithDuration:1
	                              delay:0
	             usingSpringWithDamping:0.7f
	              initialSpringVelocity:2.3f
	                            options:UIViewAnimationOptionCurveEaseOut
	                         animations:^{
	                             preferenceOverlay.alpha = 0.8;
	                             toView.center = CGPointMake(toView.center.x + 200, CGRectGetMidY(inView.frame));
	                         } completion:^(BOOL finished) {
	                             [transitionContext completeTransition:YES];
	                         }];
	    }
	}
	
	- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
	    return 1;
	}

They are responsible for moving the presented controllers view into the correct position when presented and when dismissed. You can of course have two different animation controllers, on for presenting and one for dismissing, but it seemed simpler with just the one.
