pragma Singleton
import QtQml

QtObject {
    property string host: "http://localhost:8080"
    function request(method, path, header, body) {
        return new Promise((resolve, reject) => {
            let xhr = new XMLHttpRequest();

            xhr.onreadystatechange = () => {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        if (typeof xhr.response === 'string')
                            try {
                                resolve(JSON.parse(xhr.response));
                            } catch (e) {
                                resolve(xhr.response)
                            }
                        else
                            resolve(xhr.response)
                    } else {
                        console.log(xhr.responseText)
                        if (typeof xhr.response === 'string')
                            reject(JSON.parse(xhr.response));
                        else
                            reject(xhr.response)
                    }
                }
            }

            xhr.open(method, host + path);
            if (header) {
                for (let key of Object.keys(header)) {
                    xhr.setRequestHeader(key, header[key]);
                }
            }
            xhr.setRequestHeader('Content-Type', 'application/json');
            if (body)
                xhr.send(JSON.stringify(body));
            else
                xhr.send();
        })
    }
}