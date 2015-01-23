import bb.cascades 1.2

NavigationPane {
    id: navigationPane
    
    Menu.definition: MenuDefinition {
        actions: [
            ActionItem {
                title: "About"
                imageSource: "asset:///images/about.png"
            }
        ]
    }

    Page {
        titleBar: TitleBar {
            title: "Search for Lyrics"
        }

        Container {
        }

        actions: ActionItem {
            title: "Favourites"
            imageSource: "asset:///images/favourite.png"
            ActionBar.placement: ActionBarPlacement.OnBar

            onTriggered: {
                navigationPane.push(favouritesDef.createObject());
            }
        }
    }

    attachedObjects: [
        ComponentDefinition {
            id: favouritesDef
            source: "Favourites.qml"
        }
    ]

    onPopTransitionEnded: {
        page.destroy();
    }
}
