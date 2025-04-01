var HLSManifest = /** @class */ (function () {
    function HLSManifest() {
        this.VERSION = 2;
        this.TAGMAP = { 'f': '#EXT-X-STREAM-INF:', 'm': '#EXT-X-MEDIA:', 'i': '#EXT-X-I-FRAME-STREAM-INF:' };
        this.KEYMAP = { 'TYPE': 't', 'URI': 'u', 'GROUP-ID': 'g', 'NAME': 'n', 'AUTOSELECT': 'A', 'CHANNELS': 'C', 'BANDWIDTH': 'b', 'AVERAGE-BANDWIDTH': 'B', 'CODECS': 'c', 'RESOLUTION': 'r', 'AUDIO': 'a' };
        this.MAPKEY = { 't': 'TYPE', 'u': 'URI', 'g': 'GROUP-ID', 'n': 'NAME', 'A': 'AUTOSELECT', 'C': 'CHANNELS', 'b': 'BANDWIDTH', 'B': 'AVERAGE-BANDWIDTH', 'c': 'CODECS', 'r': 'RESOLUTION', 'a': 'AUDIO' };
        this.USEQUOTES = ['C', 'u', 'n', 'g', 'c', 'a'];
        this.basemap = null;
        this.duMap = { '2': 6, '3': 3 };
        this.master = "";
        this.masterURL = "";
        this.flavours = {};
    }
    HLSManifest.prototype.parse = function (url) {
        this.fromJson(url);
    };
    HLSManifest.prototype.parseString = function (str) {
        this.fromJson(JSON.parse(str));
    };
    HLSManifest.prototype._getMasterLine = function (obj, type) {
        var _this = this;
        if (obj == null)
            return null;
        var line = this.TAGMAP[type];
        var sb = [];
        var val;
        var b;
        var u = null, s;
        Object.keys(obj).forEach(function (key) {
            b = false;
            s = type === 'f' && key === 'u' ? null : _this.MAPKEY[key];
            val = obj[key] || "";
            if (key === 'u')
                u = val;
            if (val !== '' && s != null) {
                b = true;
                sb.push(s);
                sb.push('=');
                if (_this.USEQUOTES.indexOf(key) != -1) {
                    sb.push('\"');
                    sb.push(val);
                    sb.push('\"');
                }
                else {
                    sb.push(val);
                }
            }
            if (b) {
                sb.push(",");
            }
        });
        if (sb.length > 0) {
            sb.pop();
            if (type == 'f') {
                sb.push('\n');
                sb.push(u);
            }
            sb.unshift(line);
            sb.push("\n");
            return sb.join('');
        }
        return null;
    };
    HLSManifest.prototype._paddy = function (num, padlen, padchar) {
        var pad_char = typeof padchar !== 'undefined' ? padchar : '0';
        var pad = new Array(1 + padlen).join(pad_char);
        return (pad + num).slice(-pad.length);
    };
    HLSManifest.prototype._getFlavour = function (obj, version) {
        if (this.basemap === null) {
            this.basemap = { '2': "#EXTM3U\n#EXT-X-VERSION:3\n#EXT-X-MEDIA-SEQUENCE:0\n#EXT-X-ALLOW-CACHE:YES" + "\n#EXT-X-TARGETDURATION:" + obj['d'] + "\n",
                '3': "#EXTM3U\n#EXT-X-VERSION:6\n#EXT-X-TARGETDURATION:" + obj['d'] + "\n#EXT-X-PLAYLIST-TYPE:VOD\n#EXT-X-MAP:URI=\"init.mp4\"\n" };
        }
        var sb = [];
        sb.push(this.basemap[version]);
        var i, len = obj["s"] || 0;
        var tc = this._getTimecode(obj["m"], len);
        var s;
        for (i = 0; i < len; i++) {
            //s = tc[i].toFixed(this.duMap[version]);
            s = tc[i];
            sb.push('#EXTINF:');
            sb.push(s);
            sb.push(',\n');
            if (version == 2) {
                sb.push(this._paddy(i, 3, 0) + ".ts");
            }
            else {
                sb.push((i + 1) + ".m4s");
            }
            sb.push("\n");
        }
        sb.push("#EXT-X-ENDLIST\n");
        return sb.join('');
    };
    HLSManifest.prototype._getTimecode = function (obj, count) {
        var map, i, d, dv = obj ? obj['0'] : 0;
        map = {};
        for (i = 0; i < count; i++) {
            d = dv;
            Object.keys(obj).forEach(function (key) {
                if (obj[key].indexOf(i) !== -1) {
                    d = key;
                    return;
                }
            });
            map[i] = d;
        }
        return map;
    };
    HLSManifest.prototype.fromJson = function (obj) {
        var _this = this;
        if (obj == null)
            return null;
        var i, len;
        var flavours = {};
        var masterline = [];
        var arr, item;
        masterline.push("#EXTM3U\n\n");
        var str;
        Object.keys(obj).forEach(function (key) {
            if (key === 'v')
                _this.VERSION = obj[key] || 2;
            else {
                arr = obj[key];
                if (arr !== 'undefined') {
                    len = arr.length;
                    for (i = 0; i < len; i++) {
                        item = arr[i];
                        if (item !== 'undefined') {
                            if (item['s'] !== 'undefined' && item['u'] !== 'undefined') {
                                _this.flavours[item['u']] = _this._getFlavour(item, _this.VERSION);
                            }
                            str = _this._getMasterLine(item, key);
                            masterline.push(str);
                        }
                    }
                }
            }
        });
        this.master = masterline.join('');
        return this.master;
    };
    return HLSManifest;
}());
//# sourceMappingURL=mfl.js.map
