import bb.cascades 1.2

Sheet {
    id: helpSheet
    onClosed: {
        helpSheet.destroy();
    }
    
    Page {
        titleBar: TitleBar {
            title: "Help"
            dismissAction: ActionItem {
                title: "Back"
                onTriggered: {
                    helpSheet.close();
                }
            }
        }
        attachedObjects: [
            Invocation {
                id: emailInvoke
                query.mimeType: "text/plain"
                query.invokeTargetId: "sys.pim.uib.email.hybridcomposer"
                query.invokeActionId: "bb.action.SENDEMAIL"
                onArmed: {
                    emailInvoke.trigger(emailInvoke.query.invokeActionId);
                }
            }
        ]
        
        ScrollView {
            scrollViewProperties.scrollMode: ScrollMode.Vertical
            
            Container {
                layout: StackLayout { orientation: LayoutOrientation.TopToBottom }
                topPadding: 20
                bottomPadding: topPadding
                leftPadding: topPadding
                rightPadding: topPadding
                
                Label {
                    text: "Helpful Hints"
                    textStyle.fontSize: FontSize.XLarge
                    horizontalAlignment: HorizontalAlignment.Center
                }
                Label {
                    text: "Searching"
                    textStyle.fontSize: FontSize.Large
                }
                Label {
                    text: "To search for any lyrics, you must always input the artist you are searching for. " +
                    "Searching for just the artist will give you results showing all of their songs, arranged " +
                    "into albums (sorted by year). If you would like a specific song, input the title of the " +
                    "song into the Song text field (you must still input an artist as well). Please note that " +
                    "both artist and song title searches are based on exact matches, so if you don't get any " +
                    "results, make sure to check your spelling. If you would like to view the lyrics of an " +
                    "entire album, input the artist and album name, and the search results will show a list of " +
                    "all songs on the album. The album search term is searched for anywhere in the album title, " +
                    "so searching for \"highways\" or even just \"h\" will match an album named \"Sonic Highways\". " +
                    "Have fun singing along to all your favourite songs! :)"
                    multiline: true
                    textStyle.fontSize: FontSize.Medium
                }
                Label {
                    text: "Favourites"
                    textStyle.fontSize: FontSize.Large
                }
                Label {
                    text: "When viewing a song's lyrics, you can tap the \"Add Favourite\" button to save the song as a favourite. " +
                    "You can also add an artist or an entire album by doing the same from the search results screen. " +
                    "Favourites are accessible from the main search screen by tapping \"Favourites\" at the bottom of the screen. " +
                    "To remove a favourite, simply tap and hold it's entry, and tap the Delete icon."
                    multiline: true
                    textStyle.fontSize: FontSize.Medium
                }
                Button {
                    text: "I'm Still Confused!"
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    bottomMargin: 30
                    onClicked: {
                        emailInvoke.query.uri = "mailto:ryantmer@gmail.com?subject=Lyrics%20Search%20Help";
                        emailInvoke.query.updateQuery();
                    }
                }
            }
        }
    }
}
