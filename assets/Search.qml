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
            
            
            Label {
                text: "Search For Lyrics"
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.XXLarge
            }
            Container {
                bottomMargin: 30
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                TextField {
                    id: songField
                    hintText: "Song Title"
                }
                Label {
                    text: "by"
                    textStyle.fontSize: FontSize.XLarge
                    verticalAlignment: VerticalAlignment.Center
                }
                TextField {
                    id: artistField
                    hintText: "Artist"
                }
            }

            Button {
                text: "Search"
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                onClicked: {
                    navigationPane.push(searchResultsPage);
                    console.log("Searching for song " + songField.text);
                    console.log("Searching for artist " + artistField.text);
                    var query = {};
                    query["song"] = songField.text;
                    query["artist"] = artistField.text;
                    app.search(query);
                }
            }
        }

        actions: [
            ActionItem {
                title: "Favourites"
                imageSource: "asset:///images/favourite.png"
                ActionBar.placement: ActionBarPlacement.OnBar
    
                onTriggered: {
                    navigationPane.push(favouritesPage);
                }
            }
        ]
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
