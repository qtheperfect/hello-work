// Loaded already the details by Video Downloader Helper 

(function() {
    'use strict';    
    // Your code here...

    var interestedRows = ["videoUrl", "audioUrl", "pageUrl"];
    function fromRow(tr){
        var key = tr.firstChild.innerText
        if (interestedRows.includes(key))
            return [{key:key,value:tr.lastChild.innerText}]
        else
            return []
    }
    function fromTable(tb){
        var trs = Array.from( tb.getElementsByTagName("tr")  )
        return trs.flatMap((tr) => fromRow(tr))
    }
    function getTitle(li){
        var tt = li.find((o)=> o.key == "pageUrl")
        if (tt){
            var title = tt.value.match(/v=([a-zA-Z0-9_-]+)/)
            if (title)
                return title[1]
        }
        return "new_media"
    }

    var details = document.getElementsByClassName("details")[0]
    var trs = fromTable(details)
    var title = getTitle(trs)

    function useAudio(trs , title  ) {
        var ado = trs.find(i => i.key == "audioUrl")
        if (!ado) return ";"
        else return "wget -O" + title + ".audio \'" + ado.value + "\' -o- 2>&1 & date ;  "
    }

    function useVideo(trs , title ) {
        var vdo = trs.find(i => i.key == "videoUrl")
        if (!vdo) return ";"
        else return "wget -O" + title + ".video \'" + vdo.value + "\' -o- 2>&1 & date ; "
    }

    console.log(useAudio(trs, title) + useVideo(trs, title))
})();
