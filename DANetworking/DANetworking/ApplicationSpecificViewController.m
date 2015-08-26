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

#import "StopWatch.h"



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

@property (weak, nonatomic) IBOutlet UILabel *numberOfLocalCapabilitySummariesLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberOfFeasibleCombinationsLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedContributionLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedContributionDetailsLabel;




@property (strong, nonatomic) StopWatch *watch;
@property (strong, nonatomic) PrimesTask *globalTask;
@property (strong, nonatomic) PrimesTask *localTask;
@property (strong, nonatomic) NSArray *selectedCombination;

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

#warning Ser range
    
    _globalTask = [[PrimesTask alloc] initWithLowerLimit:0 upperLimit:10 cost:1000];
    [[[DecideObserver sharedInstance] myComponent] setGlobalTask:_globalTask];
    
    #ifdef DEBUG
    #endif
    
}


#pragma mark - Actions

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

- (IBAction)disconnectDecideButtonPressed:(id)sender {
    
    [[DecideObserver sharedInstance] reset];
}

- (IBAction)updateDecideButtonPressed:(id)sender {
    
    [[DecideObserver sharedInstance] reset];
    [[DecideObserver sharedInstance] start];

}



#pragma mark - DecideObserverDelegate

- (NSArray * __nonnull)localCapabilitiesAnalysisCalculation {
    
    // 1. Retrieve an instance of my component from the Decide framework
    PrimesComponent *myComponent = (PrimesComponent *)[DecideObserver sharedInstance].myComponent;
    
    // 2. Initialize a counter for debugging puproses
    int localCapabilityAnalysisCounter = 0;
    
    // 2. Local capability summary calculation.
    // For each possible range calculate.
    for (int lower = _globalTask.lowerLimit; lower < _globalTask.upperLimit; lower++) {
        
        for (int upper = _globalTask.lowerLimit; upper <= _globalTask.upperLimit; upper++) {
           
            // 1. The cost is the range multiplied by the cosumtion rate
            double cost = (upper - lower) * myComponent.powerConsumtionPerSec;
            
            // 2.Create possible task instance
            PrimesTask *possibleTask = [[PrimesTask alloc] initWithLowerLimit:lower upperLimit:upper cost:cost];

            // 3. Add the possible task if satisfier the cost requirement
            if (possibleTask.cost <= myComponent.maxPowerConsumtion && possibleTask.cost >= 1) {
                [myComponent addLocalContributioPossibleCombinationsObject:possibleTask];
                
                localCapabilityAnalysisCounter ++;
                
                #ifdef DEBUG
                    NSLog(@"LCAS No %d: Lower: %ld, Upper: %ld, Cost: %ld" ,localCapabilityAnalysisCounter ,(long)possibleTask.lowerLimit, (long)possibleTask.upperLimit, (long)possibleTask.cost);
                #endif
            }
    
        }
        
    }
    
    // Update UI Label
    dispatch_async(dispatch_get_main_queue(), ^{
        self.numberOfLocalCapabilitySummariesLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[myComponent.localContributioPossibleCombinations count]];
    });
    
    return myComponent.localContributioPossibleCombinations;
}

- (NSMutableArray *)calculatePossibleCombinations {

    /**
     The stop watch is for calculation performance.
     At this point we start it.
     
     :returns: <#return value description#>
     */
    _watch = [[StopWatch alloc] init];
    [_watch start];

    
    // 1. Create a possible combinations array in order to store the results.
    NSMutableArray *combinations = [NSMutableArray array];
    
    // 2. For each of my possible tasks
    for (PrimesTask *myCandidateCombinationTask in [DecideObserver sharedInstance].myComponent.localContributioPossibleCombinations) {
        
        // 3. For each peer
        for (DecideComponent *peer in [DecideObserver sharedInstance].components) {
            
            // 4. For each peer's task
            for (PrimesTask *peersCandidateCombinationTask in peer.localContributioPossibleCombinations) {
                
                // 5. We check if the combination captures the needed global range.
                if (_globalTask.lowerLimit == peersCandidateCombinationTask.lowerLimit ||
                    _globalTask.lowerLimit == myCandidateCombinationTask.lowerLimit ) {
                    
                    if (_globalTask.upperLimit == peersCandidateCombinationTask.upperLimit ||
                        _globalTask.upperLimit == myCandidateCombinationTask.upperLimit) {
                        
                        if (myCandidateCombinationTask.lowerLimit == peersCandidateCombinationTask.upperLimit ||
                            peersCandidateCombinationTask.lowerLimit == myCandidateCombinationTask.upperLimit) {
                            
                            if (_globalTask.cost >= myCandidateCombinationTask.cost + peersCandidateCombinationTask.cost ) {
                                
                                // 6. As soon as the combination fulfills the requirements we add it on the list.
                                NSArray *feasibleCombination = [NSArray arrayWithObjects:myCandidateCombinationTask, peersCandidateCombinationTask, nil];
                        
                                [combinations addObject:feasibleCombination];
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     *  Variable that captures the minimum cost. In this variable we assign the lowest cost
     */
    double minimumCostOfTask = 10000000000;
    
    /**
     *  Counter variable for indicating the processing task
     */
    int numberOfCombinations = 0;
    
    /**
     *  For all combinations find the combination that minimizes the total system's cost. 
     *  The total system's cost is persisted in the @code minimumCostOfTask @endcode
     */
    for (NSArray *combination in combinations) {
        
        numberOfCombinations++;
        
        NSLog(@"Combination No: %d",numberOfCombinations);
        
        // 1. Calculate total cost.
        double totalCostOfProcessingTask = 0;
        
        for (PrimesTask *task in combination) {
            totalCostOfProcessingTask += task.cost;
        }
        
        // 2. Start logging combination.
        int componentIndex = 1;
        
        for (PrimesTask *task in combination) {

            NSLog(@"Component: %d -> Lower limit: %ld, Upper limit: %ld, Cost: %f, Total Cost: %f " ,componentIndex ,(long)task.lowerLimit, (long)task.upperLimit, task.cost, totalCostOfProcessingTask);

            if (totalCostOfProcessingTask < minimumCostOfTask) {
               
                [DecideObserver sharedInstance].myComponent.localTask = [combination objectAtIndex:0];
               
                _localTask = [combination objectAtIndex:([DecideObserver sharedInstance].position - 1)];
                
                minimumCostOfTask = totalCostOfProcessingTask;
                
                _selectedCombination = combination;
            }
            
            componentIndex++;

        }
        
    }
    
    NSMutableString *contributionDetailsString = [NSMutableString string];
    
    for (PrimesTask *task in _selectedCombination) {
        NSString *taskString = [NSString stringWithFormat:@"[%d,%d],", task.lowerLimit, task.upperLimit];
        [contributionDetailsString appendString:taskString];
    }
    
    
    
    // Update UI with the contribution details
    dispatch_async(dispatch_get_main_queue(), ^{
        self.selectedContributionDetailsLabel.text = contributionDetailsString;
    });

    // Update UI with the number of possible combinations
    dispatch_async(dispatch_get_main_queue(), ^{
        self.numberOfFeasibleCombinationsLabel.text = [NSString stringWithFormat:@"%d",numberOfCombinations];
    });

    // Update UI with the selected combination
    dispatch_async(dispatch_get_main_queue(), ^{
        self.selectedContributionLabel.text = [NSString stringWithFormat:@"[%d,%d]",_localTask.lowerLimit, _localTask.upperLimit];
    });
    
    // Update UI with the selected combination
    dispatch_async(dispatch_get_main_queue(), ^{
        self.subscribersNumberLabel.text = [NSString stringWithFormat:@"%ld", [DecideObserver sharedInstance].position];
    });
    
    return combinations;
}

- (void)didChangeDecideStatus:(NSString *)status {
    /**
     *  Update the UI Label with the DECIDE'f framework state.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        self.decideStatusLabel.text = status;
    });
}

- (void)didReceiveJoinEvent:(DAMessage * __nonnull)message {
    [self updateActivityLabelWithText:@"Someone joined your channel"];
}

- (DecideComponent *)didReceiveContributionAnalysisMessageEvent:(DAMessage * __nonnull)message {
    
    /**
     When receiving a contribution analysis message, then you create an instance with it. We dont care about the actual power consumtion or max power consumption as all the needed information are wrapped on sender's local capability summary. The local capability summary is on the @code DAMessage * __nonnull)message @endcode inside the @code lcaBody @endcode array
     
     :returns: <#return value description#>
     */
    PrimesComponent *component = [[PrimesComponent alloc] initWithIdentifier:message.sender maxPowerConsumtion:0 powerConsumtionPerSec:0];
   
    return component;
}

- (void)execution {
    
    NSLog(@"Calculating...");
    
    int n1, n2, i, j, flag;
    
    PrimesTask *localTask = (PrimesTask *)[[DecideObserver sharedInstance] myComponent].localTask;
  
    n1 = _localTask.lowerLimit;
    n2 = _localTask.upperLimit;

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

    
    
    // Stop the watch
    [_watch stop];
    
    NSLog(@"Calculation time: %@", [_watch description]);

    
    //[self nonDistributedCalculation];
}

- (void)didReceiveStatusUpdatesMessageEvent:(DAMessage * __nonnull)message {
    NSLog(@"DAMessage: %@", (NSArray *)message.body);
}

- (void)didReceiveMajorChangeMessageEvent:(DAMessage * __nonnull)message {
}


#pragma mark - Non Distributed

- (void)nonDistributedCalculation {
    
    [_watch start];
    
    int n1, n2, i, j, flag;
    
    PrimesTask *localTask = (PrimesTask *)[DecideObserver sharedInstance].myComponent.localTask;
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
    
    
    
    // Stop the watch
    [_watch stop];
    
    NSLog(@"%@", [_watch description]);
    
}

@end
