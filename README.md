# Story - As a user, I want to see the Astronomy Picture of the Day, so that I can learn new things about our Universe everyday.
###### 

Approach - 
1. I've used MVVM architecture and used generic Observable class for binding data
2. Used protocols and inject dependencies using ViewModel's initializer
3. Tried to acheive as much as modularity and loose coupling 
4. Used observer, singleton design patterns
5. Added Unit(services and view model) - 90% coverage & UI(basic)test cases

######

Acceptance Criterias - All four acceptance criterias have been covered

######

Trade-offs
1. Persistence Store Manager can get extended with CoreData and image can be stored in document directory(separate manager). As in future, we can have a different story with lots of images and data
2. More Unit and UI test cases should be added - Error/failure cases
3. For enums and protocols different classes can be created
4. XCconfig file can get created for baseurl and api_key
5. Error cases should be handled gracefully with alert or toast messages
6. Code refactoring can be done for few of classes
