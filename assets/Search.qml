import bb.cascades 1.2

NavigationPane {
    id: navigationPane
    Menu.definition: MenuDefinition {
        actions: [
            ActionItem {
                title: "About"
                imageSource: "asset:///images/about.png"
                onTriggered: {
                    navigationPane.push(aboutDef.createObject().open());
                }
            },
            ActionItem {
                title: "Help"
                imageSource: "asset:///images/help.png"
                onTriggered: {
                    navigationPane.push(helpDef.createObject().open());
                }
            }
        ]
    }
    attachedObjects: [
        ComponentDefinition {
            id: searchResultsDef
            content: SearchResults {}
        },
        ComponentDefinition {
            id: favouritesDef
            content: Favourites {}
        },
        ComponentDefinition {
            id: aboutDef
            content: About {}
        },
        ComponentDefinition {
            id: helpDef
            content: Help {}
        }
    ]

    Page {
        titleBar: TitleBar { title: "Search for Lyrics" }
        actions: [
            ActionItem {
                title: "Favourites"
                imageSource: "asset:///images/favourite.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    navigationPane.push(favouritesDef.createObject());
                }
            }
        ]

        Container {
            layout: StackLayout { orientation: LayoutOrientation.TopToBottom }
            topPadding: 20
            rightPadding: 20
            leftPadding: 20
            bottomPadding: 20
            
            Label {
                text: "Search For Lyrics"
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.XLarge
            }
            TextField {
                id: songField
                hintText: "Song Title"
            }
            TextField {
                id: artistField
                hintText: "Artist"
            }
            Label {
                id: warningLabel
                text: "Artist required"
                textStyle.color: Color.Red
                visible: false
            }
            TextField {
                id: albumField
                hintText: "Album"
            }
            Button {
                text: "Search"
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                onClicked: {
                    if (artistField.text == "") {
                        warningLabel.visible = true;
                        return;
                    } else {
                        warningLabel.visible = false;
                    }
                    var query = {};
                    query.song = songField.text;
                    query.artist = artistField.text;
                    query.album = albumField.text;
                    var page = searchResultsDef.createObject();
                    page.data = query;
                    navigationPane.push(page);
                    app.search(query);
                }
            }
        }
    }
}
