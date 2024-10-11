# FeastIdeas

## Steps to Run the App

This project has dependencies that are managed by SPM.

  1. Open `FeastIdeas.xcodeproj`
  2. Allow the packages to resolve
  3. Select "Run"; or press `CMD + R` 

## Focus Areas: 
The areas I focused on in the beginning was the architecture. I started with the architecture because that will dictate
the project flow and answer the fundamental questions that will quickly need answered once coding begins.

Once coding begins I focus on building out foundation pieces of code that all other parts of the application will rely 
on. In parallel I keep testing front of mind. So as I start coding I apply tests as needed or I at least write the code
so tests can be applied later without modifications. 

## Time Spent: 

I spent 4-5 hours on this project. I allocated my time by setting aside 15 - 20 mins to think through the requirements
and identify any areas of concern. I then spent another 15 - 20 mins thinking through my approach. What was the shape of
the architecture, what areas I should start first. Lastly, I spent about about 5 - 10 mins thinking about the UI.

Once I felt like I had a good plan I started development. The rest of the time was spent building this application.

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

A side from the dependency, I feel the weakest part of this project is better UI component build outs. Some of the UI 
components feel bloated.

## External Code and Dependencies: 

I used KingFisher for image resource management.

## Additional Information: 

For this project I used a basic 3 tiered architecture. UI, Core and Data.

There is another Foundation "module" which is in addition to the 3 tiers in the application. This "module" represents 
code that is not specific to this application and would likely be used across all products.

The rules for these boundaries are as follows

  - Foundation - This layer has the following attributes
    - This layer provides support and functionality to the rest of the system.
    - Contains modules that are not domain specific. For example, networking clients and design systems.
    - This layer is also not specific to any product and belongs to the "platform".
    - These modules MUST NOT depend on any "lower" layers.
  - Core - This layer has the following attributes
    - Contains Entities, communication protocols and any other business logic that would be used by the UI layer.
    - This layer SHOULD contain most of the business logic that is not UI specific.
    - This layer SHOULD NOT depend on the Data layer.
    - This layer SHOULD NOT depend on the UI layer.
  - UI - This layer has the following attributes
    - Contains the UI components and screens for the particular feature.
    - This layer contains View Models which is the business logic for the view itself.
    - This layer SHOULD depend on the Core layer.
    - This layer MUST NOT depend on the Data layer.
  - Data - This layer has the following attributes.
    - Contains modules for retrieving and storing data. For example, in memory data storage, disk I/O, specific rest clients (i.e. CloudFrontClient).
    - This layer SHOULD contain mapping from client to Core types.
    - This layer MUST NOT depend on the UI layer.
    - This layer CAN depend on the Core layer.

