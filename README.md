# Requirements:
- XCode 15.2
- Support iOS 15+
- Third party libraries:
    + [NukeUI](https://github.com/kean/Nuke) loads and displays images from multiple sources with simple APIs, utilizing powerful image processing and efficient caching..

# How to install:
- Pull the code
- Open `ZGithub.xcodeproj`, build and run.

# High level design:
- Using Clean architecture and MVVM with Coordinator for the Presentation.
```
Data Layer -> Domain Layer <- Presentation
```

# Low level design: 
## Domain layer
- Always put business logic of the application in domain layer.
- Domain layer is the lowest layer in the system, it should not have any reference to Presentation or Data layer.
- Ideally Domain layer can be shared among platforms like Backend, Android and Web (if they use Swift).
- Repository protocols are placed in the Domain layer, their implementaions are provided by Data layer.
- UseCase is the unit of task excution, which depends on the repository procol to perform the task. UseCase can depend on other UseCases.

## Data layer
- Single source of truth is the Local Storage (CoreData), not the remote.
    + Always try to load from local storage first and display on screen first (because it is fast), then
    + Pull remote data from server (to get up-to-date data), save to local storage, and finally update on screen.

- Local storage: CoreData
    + Data model: single CDUser entity to store the githut user info. User info in user list api actually a portion of the detail user info, so we can use a single entity to store user info.
    + Simple core data stack setup with single mainContext.
    + Read/write tasks will be executed in background queue and return to mainContext via callback/async continuation.

## Presentation layer
- Presentation have no connection to Data layer, get data via Domain layer via use-cases.
- Apply MVVM pattern for each feature (user list and user detail screens).
- With the vision of scalable app, we extract the navigation flow away from the view model to the coordinator.
```
         Coordinator
              ^
              |
UseCase <- ViewModel <-> View
              |
              v 
            Model
```

# Development area & Discussion:
## Further improvement:

###. Extract /Domain /Data to standalone modules for better development interation.

###. Network request:
- Currently we pull data from and public api service, so no worries about the security, but when we need to access company api, need more security network infrastructure, we can use any Networking library like Alamofier or Moya and simply write adapters to connect 3th networking with current networking logic simple via conformming the `NetworkingProtocol`.
- Currently I assume that we need to fetch

###. Database: 
- Can use [mogenerator](https://github.com/rentzsch/mogenerator) to generate core data entity class for fully type-safe.
- Can apply more advanced CoreData stack pattern in case we need more complex and heavy read/write operations. E.g: persistent store <- private context <- main context <- child context.
- Replace the CoreData with other database like Realm simply by implement the Storage protocols.

## The potential issue of user list view
- If the user continuously scroll down to load more and more users, it is okay for 1K or even 10k of users. But technically we have case of 1 billions users, should we load them all to the memory?
- Eventhought UITableView or SwiftUI list have the reuseable cell mechanism to optimize the performance when handling large dataset. But it is not enough though. If we load huge dataset to memory, it increases the memory usage and once it peaks over the system threadhold, system will warn us or even terminate the applications.
- So what should we do, here are some approaches:
+ Limit the maximum number of users:
    + Pro: Simplest for development, cheap maintaining cost.
    + Cons: But how to determine the `limit`? It is case by case, need to align with product manager.

+ If PM does not agree with the simplest approach above, we need to dirty our hand in more advance appoach:
    + Maintains a display range of user list with a certain range size N.
    + We need to support 2 ways load mores:
        + Bottom load more: 
            > Call rest API, append the response list to the current range.
            > If the current range size exceeds the limit, evicts elements from `head` of current range.
        + Top load more:
            > Load earlier data from local storage (*), and prepend to the current range.
            > If the current range size exceeds the limit, evicts elements from `tail` of current range.
            (*) No need remote api because we know that data is existed in local storage.

    + Pros:
        + Best for user exeriece, we can display all github users without threaten from memory issue.
    + Cons:
        + Complex development, more expensive maintaince cost.
        + Introduce more edge-case to handle when load more.
