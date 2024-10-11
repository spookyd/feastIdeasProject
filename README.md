# FeastIdeas

## Steps to Run the App

## Focus Areas: 
What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

## Time Spent: 
Approximately how long did you spend working on this project? How did you allocate your time?

## Trade-offs and Decisions: 

### Compiler Enforced Boundaries

Typically I would have the architecture layers be located within the Swift Packages to enforce architecture boundaries.
For the sake of time I am skipping this particular step as it does take a little extra to setup.

### Better Refresh Mechanism

Having pull to refresh would have been better in my opinion. However, this is only available for `List` which forces 
undesirable UI. I could have tried to implement something on my own using `GeometryReader` or `ScrollViewReader` but
this would have required a lot of trial and error. For this exercise I am going with the manual option. 

### Image Handling

There are two challenges with image fetching. Lazy Container performance and resource management.

#### Lazy Container

The AsyncImage does not cache images. Lazy containers recreate and destroy views as they leave and enter a view. This causes unacceptable image fetching performance which results in poor UI and multiple network calls.

#### Introducing 3rd Party Code

For this project I decided to use a 3rd party library, KingFisher, for the image resource management. Given we are not 
using much of the functionality I would typically opt to avoid the 3rd party but given the tight time limit I accept 
this dependency.

## Weakest Part of the Project: 
What do you think is the weakest part of your project?

## External Code and Dependencies: 
Did you use any external code, libraries, or dependencies?

## Additional Information: 
Is there anything else we should know? Feel free to share any insights or constraints you encountered.

