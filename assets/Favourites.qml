import bb.cascades 1.2
import bb.system 1.2

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
                        
                        contextActions: [
                            ActionSet {
                                DeleteActionItem {
                                    title: "Delete Favourite?"
                                    
                                    onTriggered: {
                                        app.removeFavourite(ListItemData);
                                    }
                                }
                            }
                        ]
                    }
                }
            ]
            
            onTriggered: {
                var data = dataModel.data(indexPath);
                var page = viewLyricsDef.createObject();
                page.data = data;
                page.setup();
                navigationPane.push(page);
            }
            
            function getTitle(data) {
                if (data.song != "") {
                    return data.song;
                } else {
                    return data.artist;
                }
            }
            function getDescription(data) {
                if (data.song != "") {
                    return data.artist;
                }
            }
        }
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: viewLyricsDef
            content: ViewLyrics {}
        }
    ]
}
