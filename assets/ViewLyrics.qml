import bb.cascades 1.2

Page {
    property variant data: null
    property alias lyricsUrl: webView.url
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
    
    Container {
        layout: DockLayout {}
        
        ActivityIndicator {
            id: activity
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            preferredHeight: 100
        }
        ScrollView {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            id: scrollView
            objectName: "scrollView"
            scrollViewProperties.pinchToZoomEnabled: false
            scrollViewProperties.scrollMode: ScrollMode.Vertical
            
            WebView {
                id: webView
                onLoadingChanged: {
                    if (loadRequest.status == WebLoadStatus.Started) {
                        activity.start();
                        activity.visible = true;
                        webView.opacity = 0.1;
                    } else if (loadRequest.status == WebLoadStatus.Succeeded) {
                        webView.evaluateJavaScript(
                            "var content = document.getElementById('mw-content-text');" +
                            "while (document.head.firstChild) { document.head.removeChild(document.head.firstChild); }" +
                            "while (document.body.firstChild) { document.body.removeChild(document.body.firstChild); }" +
                            "var header = document.createElement('h1');" + 
                            "header.innerHTML = '" + data.artist + ":" + data.song + " Lyrics';" + 
                            "document.body.appendChild(header);" + 
                            "var lyrics = content.getElementsByClassName('lyricbox')[0];" +
                            "lyrics.removeChild(lyrics.firstChild);" +
                            "document.body.appendChild(lyrics);"
                            );
                    }
                }
                onJavaScriptResult: {
                    activity.stop();
                    activity.visible = false;
                    webView.opacity = 1.0;
                }
            }
        }
    }
}
