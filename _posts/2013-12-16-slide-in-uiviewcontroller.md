---
layout: post
title: UIModalPresentationCustom in iOS 7
---

On the road to iOS 7 I've decided to rethink some of the design decisions of [Stray](http://itunes.apple.com/app/stray/id570951876?mt=8) and this is the journey.

After having watched some of the WWDC 2013 sessions on the new transition animation frameworks for presenting a controller I decided this was something I wanted to do, more specifically to have my settings controller slide in from the left on a swipe/pan gesture from the left edge.

This is what I ended up with

![Settings dialog](http://cdn.artsoftheinsane.com/blog/iOS%20Simulator%20Screen%20shot%2027%20aug%202013%2019.16.31.png)

First problem I tackled was the swipe/pan gesture. Since Stray is using a `UIPageViewController` I simply added a transparent `UIView` that covered the left side and attached my gesture to that. This won't register a swipe/pan on the actual settings dialog but for the moment that is good enough.

Next up was the transition animation controller, i recommend having a look at session 218 for a thorough review of what it can do, but in essence what you do are the following steps.

	[self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PreferencesViewController"]
                               animated:YES
                             completion:nil];


And in the controller being presented, here PreferencesViewController, you have to set up the following to make sure that it uses your custom transition animation.

	self.modalPresentationStyle = UIModalPresentationCustom;
	self.transitioningDelegate = self;

`UIModalPresentationCustom` is the new modal presentation style in iOS 7

On the presented controller you make it conform to the `UIViewControllerTransitioningDelegate` protocol, in this case `PreferencesViewController` and you implemented these two methods

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

And that is that, honestly, it was easier than the wwdc 218 session made it look like, but then of course, if you want harder then i suggest you try your hand at the interactive kind.
