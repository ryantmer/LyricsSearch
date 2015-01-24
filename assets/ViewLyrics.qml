import bb.cascades 1.2

Page {
    property variant data
    
    function setup() {
        console.log(data["url"]);
        webView.url = data["url"];
    }
    
    Container {
        layout: DockLayout {}
        topPadding: 20
        rightPadding: 20
        leftPadding: 20
        bottomPadding: 20
        
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
                            "var head = document.getElementsByTagName('head')[0];" +
                            "head.innerHTML = '';" + 
                            "var body = document.getElementsByTagName('body')[0];" +
                            "var lyrics = document.getElementsByClassName('lyricbox')[0];" +
                            "var song = document.createElement('h1');" +
                            "song.innerText = '" + data["song"] + "';" +
                            "var artist = document.createElement('h6');" +
                            "artist.innerText = 'Lyrics by " + data["artist"] + "';" +
                            "body.innerHTML = '';" +
                            "body.appendChild(song);" +
                            "body.appendChild(artist);" +
                            "body.appendChild(lyrics);"
                            );
                        activity.stop();
                        activity.visible = false;
                        webView.opacity = 1.0;
                    }
                }
            }
        }
    }
}
