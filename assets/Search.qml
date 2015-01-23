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
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            topPadding: 20.0
            leftPadding: 20.0
            rightPadding: 20.0
            bottomPadding: 20.0
            
            //Song
            Container {
                bottomMargin: 30
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Label {
                    text: "Song Title"
                    textStyle.fontSize: FontSize.XLarge
                    verticalAlignment: VerticalAlignment.Center
                }
                TextField {
                    id: songField
                    hintText: "e.g. You Make Me Sick"
                }
            }
            //Artist
            Container {
                bottomMargin: 30
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Label {
                    text: "Artist"
                    textStyle.fontSize: FontSize.XLarge
                    verticalAlignment: VerticalAlignment.Center
                }
                TextField {
                    id: artistField
                    hintText: "e.g. Of Mice And Men"
                }
            }
            //Album
            Container {
                bottomMargin: 30
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                Label {
                    text: "Album"
                    textStyle.fontSize: FontSize.XLarge
                    verticalAlignment: VerticalAlignment.Center
                }
                TextField {
                    id: albumField
                    hintText: "e.g. Restoring Force"
                }
            }

            Button {
                text: "Search for Lyrics"
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                onClicked: {
                    navigationPane.push(searchResultsPage);
                    console.log("Searching for song " + songField.text);
                    console.log("Searching for artist " + artistField.text);
                    console.log("Searching for album " + albumField.text);
                    var query = {};
                    query["song"] = songField.text;
                    query["artist"] = artistField.text;
                    query["album"] = albumField.text;
                    app.search(query);
                }
            }
        }

        actions: ActionItem {
            title: "Favourites"
            imageSource: "asset:///images/favourite.png"
            ActionBar.placement: ActionBarPlacement.OnBar

            onTriggered: {
                navigationPane.push(favouritesPage);
            }
        }
    }

    attachedObjects: [
        Favourites {
            id: favouritesPage
        },
        SearchResults {
            id: searchResultsPage
        }
    ]
}
