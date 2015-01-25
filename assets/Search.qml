import bb.cascades 1.2

NavigationPane {
    id: navigationPane
    
    Menu.definition: MenuDefinition {
        actions: [
            ActionItem {
                title: "About"
                imageSource: "asset:///images/about.png"
                onTriggered: {
                    navigationPane.push(about);
                }
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
            topPadding: 20
            rightPadding: 20
            leftPadding: 20
            bottomPadding: 20
            
            Label {
                text: "Search For Lyrics"
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.XXLarge
            }
            Label {
                id: warningLabel
                text: "Artist and song required"
                textStyle.color: Color.Red
                visible: false
            }
            TextField {
                id: songField
                hintText: "Song Title"
            }
            Label {
                text: "by"
                textStyle.fontSize: FontSize.XLarge
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }
            TextField {
                id: artistField
                hintText: "Artist"
            }
            Button {
                text: "Search"
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                onClicked: {
                    if (artistField.text == "" || songField.text == "") {
                        warningLabel.visible = true;
                        return;
                    } else {
                        warningLabel.visible = false;
                    }
                    navigationPane.push(searchResultsPage);
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
        },
        About {
            id: about
        }
    ]
}
