const assert = require('assert');

const options = {
  url: 'https://staging.justdrive.cloudcar.com/api/v1/auth/'
};

function callabck(err, response, body) {
    const data = JSON.parse(body);
    console.log(data);
    assert.equal(response.statusCode, 200, 'Expected 200 response code');
    assert.equal(response.headers['content-type'], 'application/json;charset=UTF-8', 'Expected Content-Type header of application/json;charset=UTF-8');
    assert.equal(data.accessToken, undefined, 'Response body should not contain "accessToken" key');
};