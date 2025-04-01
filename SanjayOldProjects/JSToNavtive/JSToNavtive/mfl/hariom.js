var NetworkRequest = /** @class */ (function () {
    function NetworkRequest() {
    }
    NetworkRequest.prototype.loadData = function (url, callback) {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', url);
        xhr.send();
        xhr.onload = function () {
            if (xhr.status != 200) {
                console.log("Error " + xhr.status + ": " + xhr.statusText);
                if (callback !== null)
                    callback(null);
            }
            else {
                console.log("Done, got " + xhr.response.length + " bytes");
                if (callback !== null)
                    callback(JSON.parse(xhr.response));
            }
        };
        xhr.onerror = function () {
            console.log("Request failed");
            if (callback !== null)
                callback(null);
        };
    };
    return NetworkRequest;
}());
//# sourceMappingURL=hariom.js.map