
# West Day Ever

It's a small SwiftUI app, that displays Albums of Kanye West and a brief info about the artist.

### Technical notes

Low level packages that don't depend on any other package.
- DesignKit: for common UI components and tokens
- Networking: for making REST API request
- Storage: for data persistency
- Fetcher: an abstraction over Networking and Storage yet a totally stand alone package without depending on those two. It uses dependency inversion, by declaring the dependencies that fetcher needs in order to function properly. These dependencies will be injected either in the app or the feature packages. I only implemented a single behaviour which tryes to load local data first, then reaches out to the server to update the data.

Feature packages don't depend on each other, but uses the low level packages.
- Artist: contains logic and UI for fetching, storing and displaying artist info.
- Album: contains logic and UI for fetching, storing and displaying albums info.
- Track: contains logic and UI for fetching, storing and displaying tracks info.

Using dependency inversion also means there are some code duplication, however with proper design it's barely noticable.
In this small project it only resulted in two redundant types (`ArtistId` and `AlbumId`) and dupliction of protocol comformances like this:
```
extension CodableStorage: LocalSource {}
extension RequestLoader: RemoteSource {}
```

However, this enables to have a flat project dependency graph, so more packages can be built in parallel, which is a major win at a large scale project.

I used MVVM with no navigation pattern. In procudtion I'd rather use MVI with proper states, actions and reducers, however I felt the current implementation is clean enough and scalable as well.

I didn't write any tests, however I used POP & functional approach. Every layer has a Protocol to abstract them and most of the concrete implementation of those protocols can be initialised with an injected function that provides the working mechanism. That means it's really easy to make stub implementations for testing. I created some stub implementation that also helps with SwiftUI previews.

I made both the protocols and the implementations generic. That might seem a bit verbose yet it helps with performance, as the layers can invoke each others methods with static dispatch instead of dynamic dispatch. The new Swift 5.6 already started encouraging developers to do so, by adding the `any` keyword.

References: 
- https://github.com/apple/swift-evolution/blob/main/proposals/0335-existential-any.md
- https://developer.apple.com/videos/play/wwdc2016/416/

The app supports Light and Dark mode, I put some effort to enhance accessibility capabilities like DynamicType and Voice over.
It runs on macOS and iOS, supporting smaller and larger screens as well.

I was also experimenting with Actors, async/away and Tasks instead of using Combine. It seems like on the long term Swift concurrency will probably replace Combine:
- https://swift.org/blog/swift-async-algorithms/
