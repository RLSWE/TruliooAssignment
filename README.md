# Trulioo Assignment - Login

## Design
This app consists of 3 screens:
- Login
- Register
- Successful login
  

Since the app is relatively simple, I attempted to write it in MVC and keep SOLID principles as much as possible.
I would add couple more layers to make even more separation of concerns, but as with any project, there's always room for improvement, it just takes time (Which I currently don't have much of 😁)
I tried to make everything as simple as possible so there's a lot to improve here. For real, big apps I would add more layers and design it better.

### Business logic
I decided to use Keychain Services. Besides that being secure, it is also the way Apple recommends for storing credentials on an app locally.
For the business logic units, I used TDD.
Those units' dependencies are declared as an interface (protocol) and the actual types are injected via DI in the Scene delegate, where the module is being initiated.
If the app was a bit more complex and let's say I had two different type of login and register, let's say one for regular users and 1 for backoffice users, I would have probably used an Abstract Factory.

### UI
For the UI I used storyboards.
Why storyboards and not SwiftUI? I am very comfortable with UIKit and I make UI much faster with it. I still need to sharpen my skills with SwiftUI. 
SwiftUI still has some issues I've seen and it has some way to go, although it is going in a good direction and I'd like to do more of it in the future.

-----
## What I would add if I had more time
- Currently, `KeychainAuthWorker` speaks directly to Keychain Services. I would probably create or import a keychain wrapper to do that, so that I can write tests for the logic of `KeychainAuthWorker`, although besides communicating with Keychain Services and throwing custom errors, there's not much "meat" in there. 
- Integration tests to verify items are being saved to the keychain. (Submit in ViewController, make sure item is added to the keychain, etc.)
- UITests - To verify couple of things: Passwords are hidden, alerts are showing, navigation, etc.
- Routing logic layer, so I can unit test view controller routing logic (Currently not tested)
- Password rules? (Like length, special characters, and so)
- Module configurators - For example, currently both `RegisterViewController` and `LoginViewController` are sharing the auth provider, since it's using the same logic. But I think it's better to have it separated into two different protocols. I didn't want to add the logic of initiating the `RegisterViewController` and give it dependencies from the `LoginViewController`. It's not the view's responsibility. Module Configurators would solve that. Could be really nice with a decent routing layer.
- I think there's an option to query for all Keychain items, but I didn't try. If that's true, then we can check that in order to display `RegisterViewController` right away.
- Better error handling. Currently the app only handles trivial errors and it doesn't do it well (Mostly just displaying the message). In a real case, I would probably make better error types and also check for more errors that Keychain Services may return.
- Regarding the architecture, I think that if the project was a bit more complicated and I had a bit more time, I would probably choose VIP or MVVM with some additions. 
-----
## To summarize
This was a fun assignment. Simple and I think there's a lot of places you can "show yourself".
Unfortunately I don't have much time lately so I didn't get to do all the stuff I wanted. But that's our lives as programmers. 😁
