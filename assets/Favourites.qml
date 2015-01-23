import bb.cascades 1.2

Page {
    titleBar: TitleBar {
        title: "Favourites"
    }
    
    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            title: "Cancel"
            onTriggered: {
                navigationPane.pop();
            }
        }
    }
    
    Container {
        ListView {
            id: favouritesListView
            objectName: "favouritesListView"
            layout: StackListLayout {}
            horizontalAlignment: HorizontalAlignment.Fill
            
            dataModel: favouritesDataModel
            
            listItemComponents: [
                ListItemComponent {
                    StandardListItem {
                        id: favourite
                        title: favourite.ListItem.view.getTitle(ListItemData)
                        description: favourite.ListItem.view.getDescription(ListItemData)
                    }
                }
            ]
            
            onTriggered: {
                var favourite = dataModel.data(indexPath);
                console.log("Selected " + favourite);
            }
            
            function getTitle(data) {
                if (data.song != "") {
                    return data.song;
                } else if (data.album != "") {
                    return data.album + " (" + data.year + ")";
                } else {
                    return data.artist + " (artist)";
                }
            }
            function getDescription(data) {
                if (data.song != "") {
                    return data.artist
                }
            }
        }
    }
}
