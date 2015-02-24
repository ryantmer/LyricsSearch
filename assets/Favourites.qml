import bb.cascades 1.2
import bb.system 1.2

Page {
    titleBar: TitleBar { title: "Favourites" }
    attachedObjects: [
        ComponentDefinition {
            id: viewLyricsDef
            content: ViewLyrics {}
        }
    ]
    
    Container {
        ListView {
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
                } else if (data.album != "") {
                    return data.album
                }
            }
            layout: StackListLayout {}
            horizontalAlignment: HorizontalAlignment.Fill
            dataModel: favouritesModel
            listItemComponents: [
                ListItemComponent {
                    StandardListItem {
                        id: favourite
                        title: favourite.ListItem.view.getTitle(ListItemData)
                        description: favourite.ListItem.view.getDescription(ListItemData)
                        contextActions: [
                            ActionSet {
                                DeleteActionItem {
                                    title: "Delete Favourite"
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
                var page;
                if (data.url) {
                    //Favourite is a song, go to lyrics
                    page = viewLyricsDef.createObject();
                    page.lyricsUrl = data.url;
                    page.data = data;
                    navigationPane.push(page);
                } else {
                    //Favourite is artist or album, go to search results
                    page = searchResultsDef.createObject();
                    page.data = data;
                    navigationPane.push(page);
                    app.search(data);
                }
            }
        }
    }
}
