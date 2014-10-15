
/*
 *
 * Data Utilities for grabbing data simply or paged
 *
 */

(function() {
  var colors, grab, grabPaged, promise, request;

  colors = require('colors');

  request = require('request');

  promise = require('promise');


  /*
   * GRAB - Our basic HTTP request method for data. Essentially, a request wrapped # in a promise
   */

  exports.grab = grab = function(options) {
    return new promise(function(resolve, reject) {
      return request(options, function(e, r, b) {
        var body;
        if (e) {
          return reject(e);
        } else if (r.statusCode !== 200) {
          body = JSON.parse(b);
          return reject(new Error("Unexpected status code: " + r.statusCode + ', ' + body.message));
        }
        return resolve(b);
      });
    });
  };


  /*
   * GRABPAGED - An function that will group grab promises into one promise for
   * grabbing paged data from the API
   */

  exports.grabPaged = grabPaged = function(options, pages) {
    var i, pagedData, promises;
    pagedData = [];
    promises = [];
    i = 1;
    while (i < (pages + 1)) {
      options.url = options.url + '&page=' + i.toString();
      promises.push(grab(options));
      i++;
    }
    return new promise(function(resolve, reject) {
      return promise.all(promises).then(function(data) {
        var len;
        len = 0;
        while (len < data.length) {
          if (pagedData) {
            pagedData = pagedData.concat(JSON.parse(data[len]).items);
          } else {
            pagedData = JSON.parse(data[len]).items;
          }
          len++;
        }
        return resolve(pagedData);
      });
    });
  };

}).call(this);
