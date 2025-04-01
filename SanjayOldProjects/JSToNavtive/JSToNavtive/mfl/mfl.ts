class HLSManifest {
    public VERSION:number = 2;
    public TAGMAP = {'f' : '#EXT-X-STREAM-INF:', 'm' : '#EXT-X-MEDIA:', 'i' : '#EXT-X-I-FRAME-STREAM-INF:'};
    public KEYMAP = {'TYPE' : 't', 'URI' : 'u', 'GROUP-ID' : 'g', 'NAME' : 'n', 'AUTOSELECT' : 'A', 'CHANNELS' : 'C', 'BANDWIDTH' : 'b', 'AVERAGE-BANDWIDTH' : 'B', 'CODECS' : 'c', 'RESOLUTION' : 'r', 'AUDIO' : 'a'};
    public MAPKEY = {'t' : 'TYPE', 'u' : 'URI', 'g' : 'GROUP-ID', 'n' : 'NAME', 'A' : 'AUTOSELECT', 'C' : 'CHANNELS', 'b' : 'BANDWIDTH', 'B' : 'AVERAGE-BANDWIDTH', 'c' : 'CODECS', 'r' : 'RESOLUTION', 'a' : 'AUDIO'};
    public USEQUOTES = ['C', 'u', 'n', 'g', 'c', 'a'];

    public basemap = null;
    public duMap = {'2' : 6, '3' : 3};
    public master:string = "";
    public masterURL:string = "";
    public flavours = {};

    public parse(url):void{
        this.fromJson(url);
    }

    public parseString(str):void{
        this.fromJson(JSON.parse(str));
    }

    public _getMasterLine(obj, type):string{
        if(obj == null) return null;
        var line = this.TAGMAP[type];
        var sb = [];
        var val;
        var b:boolean;
        var u = null, s;
        Object.keys(obj).forEach(key => {
            b = false;
            s = type === 'f' && key === 'u' ? null : this.MAPKEY[key];
            val = obj[key] || "";
            if(key === 'u') u = val;
            if(val !== '' && s != null){
                b = true;
                sb.push(s); sb.push('=');
                if(this.USEQUOTES.indexOf(key) != -1){
                    sb.push('\"'); sb.push(val); sb.push('\"');
                } else {
                    sb.push(val);
                }
            }
            if(b){
                sb.push(",");
            }
        });
        if(sb.length > 0) {
            sb.pop();
            if(type == 'f') {
                sb.push('\n'); sb.push(u);
            }
            sb.unshift(line);
            sb.push("\n");
            return sb.join('');
        }
        return null;
    }

    public _paddy(num, padlen, padchar):string {
        var pad_char = typeof padchar !== 'undefined' ? padchar : '0';
        var pad = new Array(1 + padlen).join(pad_char);
        return (pad + num).slice(-pad.length);
    }

    public _getFlavour(obj, version):string{
        if(this.basemap === null){
            this.basemap = {'2' : "#EXTM3U\n#EXT-X-VERSION:3\n#EXT-X-MEDIA-SEQUENCE:0\n#EXT-X-ALLOW-CACHE:YES" + "\n#EXT-X-TARGETDURATION:" + obj['d'] + "\n",
 '3' : "#EXTM3U\n#EXT-X-VERSION:6\n#EXT-X-TARGETDURATION:" + obj['d'] + "\n#EXT-X-PLAYLIST-TYPE:VOD\n#EXT-X-MAP:URI=\"init.mp4\"\n"};
        }
        var sb = [];
        sb.push(this.basemap[version]);
        var i:number, len:number = obj["s"] || 0;
        var tc = this._getTimecode(obj["m"], len);
        var s:string;
        for(i = 0; i < len; i++){
            //s = tc[i].toFixed(this.duMap[version]);
            s = tc[i];
            sb.push('#EXTINF:'); sb.push(s); sb.push(',\n');
            if(version == 2) {
                sb.push(this._paddy(i, 3, 0) + ".ts");
            }
            else {
                sb.push((i+1) + ".m4s");
            }
            sb.push("\n");
        }
        sb.push("#EXT-X-ENDLIST\n");
        return sb.join('');
    }

    public _getTimecode(obj, count:number):object{
        var map, i, d, dv = obj ? obj['0'] : 0;
        map = {};
        for(i = 0; i < count; i++){
            d = dv;
            Object.keys(obj).forEach(key => {
                if(obj[key].indexOf(i) !== -1){
                    d = key;
                    return;
                }
            });
            map[i] = d;
        }
        return map;
    }

    public fromJson(obj){
        if(obj == null) return null;
        var i, len;
        var flavours = {};
        var masterline = [];
        var arr, item;
        masterline.push("#EXTM3U\n\n");
        var str:string;
        Object.keys(obj).forEach(key => {
            if(key === 'v') this.VERSION = obj[key] || 2;
            else {
                arr = obj[key];
                if(arr !== 'undefined') {
                    len = arr.length;
                    for(i = 0; i < len; i++){
                        item = arr[i];
                        if(item !== 'undefined'){
                            if(item['s'] !== 'undefined' && item['u'] !== 'undefined'){
                                this.flavours[item['u']] = this._getFlavour(item, this.VERSION);
                            }
                            str = this._getMasterLine(item, key);
                            masterline.push(str);
                        }
                    }
                }
            }
        });
        this.master = masterline.join('');
        return this.master;
    }
}
