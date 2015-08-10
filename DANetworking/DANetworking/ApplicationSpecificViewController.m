//
//  ApplicationSpecificViewController.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "ApplicationSpecificViewController.h"
#import "DANetworking-Swift.h" //Import Swift files
#import "DecideObserver.h"
#import "DAMessage.h"
#import "PrimesComponent.h"
#import "PrimesTask.h"


@interface ApplicationSpecificViewController () <DecideObserverDelegate>


#pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet UILabel *decideStatusLabel;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *subscribersNumberLabel;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *activityLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendDummyMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *startDecideButton;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerConsumptionLabel;

@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property (weak, nonatomic) IBOutlet UISlider *powerConsumtionSlider;

@end

@implementation ApplicationSpecificViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. Setup delegate.
    [DecideObserver sharedInstance].delegate = self;
    
    // 2. Create environment.
    [self createGlobalTask];
    
    // 3. Networking initial String.
    NSString *initialActivityLabelMessage = [NSString stringWithFormat:@"%@ is connected to the channel",[DANetwork sharedInstance].userIdentifier];
    
    // 4. Update acivity label.
    [self updateActivityLabelWithText:initialActivityLabelMessage];
}

- (void)dealloc {
    NSLog(@"%s is deallocated", object_getClassName(self));
}


#pragma mark - ApplicationSpecificViewController

- (void)updateActivityLabelWithText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.activityLabel.text = text;
    });
}

- (void)createGlobalTask {
    
    // Create a global task that will be divided into the components.
    //RobotTask *globalTask = [[RobotTask alloc] initWithMeters:100 time:50 powerConsumtion:20];
    
    PrimesTask *globalTask = [[PrimesTask alloc] initWithLowerLimit:20 upperLimit:50];
    [[[DecideObserver sharedInstance] myComponent] addGlobalTask:globalTask];
    
}


#pragma mark - Actions

- (IBAction)sendMessageTypeUnknownButtonPressed:(id)sender {
    // Deprecated
    //[[DecideObserver sharedInstance] sendDummyMessageToPeers];
}

- (IBAction)speedSliderValueChanged:(UISlider *)sender {
    _speedLabel.text = [NSString stringWithFormat:@"%.02g", sender.value];
}

- (IBAction)powerConsumptionValueChanged:(UISlider *)sender {
    _powerConsumptionLabel.text = [NSString stringWithFormat:@"%.02g", sender.value];
}

- (IBAction)startDecideButtonPressed:(id)sender {
    
    // 1.Create the robot instance
    PrimesComponent *myComponent = [[PrimesComponent alloc] initWithIdentifier:[DANetwork sharedInstance].userIdentifier maxPowerConsumtion:[_speedLabel.text doubleValue] powerConsumtionPerSec:[_powerConsumptionLabel.text doubleValue]];
    
    // 2.Set this as my robot to the observer
    [[DecideObserver sharedInstance] setMyComponent:myComponent];
    
    // 3.Start the process
    [[DecideObserver sharedInstance] start];
}


#pragma mark - DecideObserverDelegate

- (NSArray * __nonnull)localCapabilitiesAnalysisCalculation {

    PrimesComponent *myComponent = (PrimesComponent *)[DecideObserver sharedInstance].myComponent;
    
    for (double i = 0; i<= myComponent.maxPowerConsumtion; i++) {
        
        // 1.Create possible task instance
        PrimesTask *possibleTask = [[PrimesTask alloc] initWithLowerLimit:i upperLimit:i+10];
        
        // 2. Calculate the cost of the task
        possibleTask.cost = (i+10) * myComponent.powerConsumtionPerSec;
        
        if (possibleTask.cost <= myComponent.maxPowerConsumtion * 10) {
            [myComponent addLocalContributioPossibleCombinationsObject:possibleTask];
        }
        
        #ifdef DEBUG
            NSLog(@"LCA task: Lower limit: %ld, Upper limit: %ld, Cost: %ld" ,(long)possibleTask.lowerLimit, (long)possibleTask.upperLimit, (long)possibleTask.cost);
        #endif
    }
    
    
    return myComponent.localContributioPossibleCombinations;
}

- (NSMutableArray *)calculatePossibleCombinations {

    NSMutableArray *combinations = [NSMutableArray array];
    
    for (PrimesTask *myCandidateCombinationTask in [DecideObserver sharedInstance].myComponent.localContributioPossibleCombinations) {
        for (DecideComponent *peer in [DecideObserver sharedInstance].components) {
            
            #ifdef DEBUG
                NSLog(@"Processing LCA peer with identifier: %@", peer.identifier);
            #endif

            for (PrimesTask *peersCandidateCombinationTask in peer.localContributioPossibleCombinations) {
                
                if ((peersCandidateCombinationTask.lowerLimit >= myCandidateCombinationTask.upperLimit) || peersCandidateCombinationTask.upperLimit <= myCandidateCombinationTask.lowerLimit) {
                    NSArray *aCombination = [NSArray arrayWithObjects:myCandidateCombinationTask, peersCandidateCombinationTask, nil];
                    [combinations addObject:aCombination];
                }
                
            }
        }
    }

    NSLog(@"Final Combinations");
    int numberOfCombinations = 0;
    for (NSArray *combination in combinations) {
        numberOfCombinations++;
        NSLog(@"Combination No: %d",numberOfCombinations);
        
        // 1. Calculate total cost.
        double totalCost = 0;
        for (PrimesTask *task in combination) {
            totalCost += task.cost;
        }
        
        // 2. Start logging combination.
        NSLog(@"Possible task with cost: %f", totalCost);
        
        int componentIndex = 1;
        double tempMinimumCost = 10000000000;
        for (PrimesTask *task in combination) {
            NSLog(@"Component: %d -> Lower limit: %ld, Upper limit: %ld, Cost: %f " ,componentIndex ,(long)task.lowerLimit, (long)task.upperLimit, task.cost);
            componentIndex++;
            if (totalCost < tempMinimumCost) {
                [DecideObserver sharedInstance].myComponent.localTask = [[combinations objectAtIndex:0] objectAtIndex:0];
                tempMinimumCost = totalCost;
            }
        }
    }
    
    NSLog(@"Number of possible combinations %d", numberOfCombinations);
    NSLog(@"Selecting the best combinations");
    
    PrimesTask *localTask = (PrimesTask *)[DecideObserver sharedInstance].myComponent.localTask;
    
    NSLog(@"Lower limit: %d", localTask.lowerLimit);
    NSLog(@"Upper limit: %d", localTask.upperLimit);

    return combinations;
}


- (void)didChangeDecideStatus:(NSString *)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.decideStatusLabel.text = status;
    });
}

- (void)didReceiveJoinEvent:(DAMessage * __nonnull)message {
    [self updateActivityLabelWithText:@"Someone joined your channel"];
}

- (DecideComponent *)didReceiveContributionAnalysisMessageEvent:(DAMessage * __nonnull)message {
    
    // When receiving a contribution analysis message, then you create an instance with it
    
    PrimesComponent *component = [[PrimesComponent alloc] initWithIdentifier:message.sender maxPowerConsumtion:5 powerConsumtionPerSec:1];
   
    return component;
    
}

- (void)execution {
    NSLog(@"Calculating...");
    
    int n1, n2, i, j, flag;
    
    PrimesTask *localTask = (PrimesTask *)[[DecideObserver sharedInstance] myComponent].localTask;
    n1 = localTask.lowerLimit;
    n2 = localTask.upperLimit;

    NSLog(@"Prime numbers between %d and %d are: ", n1, n2);

    for(i=n1+1; i<n2; ++i)
    {
        flag=0;
        for(j=2; j<=i/2; ++j)
        {
            if(i%j==0)
            {
                flag=1;
                break;
            }
        }
        if(flag==0)
            NSLog(@"%d ",i);
    }
    
    NSLog(@"End of calculation");

}

- (void)didReceiveStatusUpdatesMessageEvent:(DAMessage * __nonnull)message {
    NSLog(@"DAMessage: %@", (NSArray *)message.body);
}

- (void)didReceiveMajorChangeMessageEvent:(DAMessage * __nonnull)message {
}

@end
