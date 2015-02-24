import bb.cascades 1.2

Page {
    property variant data: null
    attachedObjects: [
        ComponentDefinition {
            id: viewLyricsDef
            content: ViewLyrics {}
        }
    ]
    actions: [
        ActionItem {
            title: "Add Favourite"
            imageSource: "asset:///images/favourite.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                app.addFavourite(data);
            }
        }
    ]
    onCreationCompleted: {
        console.log(searchResultsListView.dataModel.hasChildren([]));
    }
    
    Container {
        layout: StackLayout { orientation: LayoutOrientation.TopToBottom }
        
        Label {
            text: "Search Results"
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.fontSize: FontSize.XXLarge
        }
        Label {
            text: "No results"
            horizontalAlignment: HorizontalAlignment.Center
            visible: searchResultsListView.dataModel.empty
        }
        ListView {
            function subtitleText(data) {
                if (data.lyrics) {
                    if (data.lyrics.indexOf("\n") > -1) {
                        return data.lyrics.substring(0, data.lyrics.indexOf("\n")) + "...";
                    } else {
                        return data.lyrics;
                    }
                }
            }
            id: searchResultsListView
            objectName: "searchResultsListView"
            layout: StackListLayout { headerMode: ListHeaderMode.Sticky }
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            dataModel: resultsModel
            listItemComponents: [
                ListItemComponent {
                    type: "item"
                    Container {
                        id: itemContainer
                        StandardListItem {
                            title: ListItemData.song
                            description: itemContainer.ListItem.view.subtitleText(ListItemData)
                        }
                    }
                },
                ListItemComponent {
                    type: "header"
                    Header {
                        title: ListItemData.album
                        subtitle: ListItemData.year
                    }
                }
            ]
            onTriggered: {
                var data = dataModel.data(indexPath);
                var page = viewLyricsDef.createObject();
                page.data = data;
                page.lyricsUrl = data.url;
                navigationPane.push(page);
            }
        }
    }
}