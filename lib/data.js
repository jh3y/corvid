(function() {
  var colors, getErrCallback, getRequestOptions, getResults, getUrlParameters, grab, grabPaged, hasCriteria, promise, request;

  colors = require('colors');

  request = require('request');

  promise = require('promise');


  /*
   *
   * Data Utilities
   *
   */


  /*
    @method grab - used for making a data request
    @params options - the request options including url and headers
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
    @method grabPaged - a paged version of grab that utilises grab to pull pages
    @params options - the request options including url and headers
    @params pages - the number of pages of data to be requested
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


  /*
    @method getUrlParameters - generate dynamic url for request options
    @params criteria - user set options
    @params qString - whether to build query string
    @params order - whether to append ordering query to query string
    @params sort - whether to append sorting query to query string
   */

  getUrlParameters = function(criteria, qString, order, sort) {
    var genQueryString, parameterString, resPageLimit;
    resPageLimit = 100;
    genQueryString = function() {
      var key, queryObj, regex, result;
      regex = new RegExp(' ', 'g');
      queryObj = {};
      if (criteria.username && typeof criteria.username === 'string') {
        queryObj.user = criteria.username;
      }
      if (criteria.repos && typeof criteria.repos !== 'boolean' && !isNaN(parseInt(criteria.repos, 10))) {
        console.log(typeof (parseInt(criteria.repos, 10)));
        queryObj.repos = '%3E' + criteria.repos;
      }
      if (criteria.location && typeof criteria.location === 'string') {
        queryObj.location = criteria.location.replace(regex, '%2B');
      }
      if (criteria.language && typeof criteria.language === 'string') {
        queryObj.language = criteria.language;
      }
      if (criteria.followers && typeof criteria.followers !== 'boolean' && typeof parseInt(criteria.followers, 10) === 'number') {
        queryObj.followers = '%3E' + criteria.followers;
      }
      if (criteria.forks && typeof criteria.repos !== 'boolean' && typeof parseInt(criteria.forks, 10) === 'number') {
        queryObj.forks = '%3E' + criteria.forks;
      }
      if (criteria.stars && typeof criteria.stars !== 'boolean' && typeof parseInt(criteria.stars, 10) === 'number') {
        queryObj.stars = '%3E' + criteria.stars;
      }
      result = '&q=';
      if (typeof criteria.repos === 'string' && isNaN(parseInt(criteria.repos, 10))) {
        result = '&q=' + criteria.repos;
      }
      for (key in queryObj) {
        if (result === '&q=') {
          result += key + ':' + queryObj[key];
        } else {
          result += '+' + key + ':' + queryObj[key];
        }
      }
      return result;
    };
    parameterString = '';
    if (qString) {
      parameterString += genQueryString();
    }
    if (sort && criteria.sort && typeof criteria.sort === 'string') {
      parameterString += '&sort=' + criteria.sort;
    }
    if (order && criteria.order && typeof criteria.order === 'string') {
      parameterString += '&order=' + criteria.order;
    }
    if (criteria.limit && typeof criteria.limit !== 'boolean' && typeof parseInt(criteria.limit, 10) === 'number') {
      parameterString += '&per_page=' + criteria.limit;
    } else {
      criteria.limit = resPageLimit;
      parameterString += '&per_page=' + resPageLimit;
    }
    return parameterString;
  };


  /*
    @method hasCriteria - returns whether criteria related to query string
    @params criteria - the user set criteria
   */

  hasCriteria = function(criteria) {
    var has;
    has = false;
    if (criteria.location || criteria.language || criteria.followers || criteria.forks || criteria.stars) {
      has = true;
    } else {
      has = false;
    }
    return has;
  };


  /*
    @method getRequestOptions - returns request options object for use with grab
    @params criteria - the user set criteria
   */

  exports.getRequestOptions = getRequestOptions = function(criteria) {
    var complex, repoName, requestOptions, urlBase, urlParameters;
    urlBase = 'https://api.github.com/';
    urlParameters = getUrlParameters(criteria, true, true, true);
    repoName = (typeof criteria.repos === 'string' ? criteria.repos + '&' : '');
    requestOptions = {
      headers: {
        'User-Agent': 'request'
      }
    };
    complex = hasCriteria(criteria);
    if (criteria.all && criteria.username && typeof criteria.username === 'string' && criteria.repos) {
      requestOptions.url = urlBase + 'search/repositories?q=user:' + criteria.username + getUrlParameters(criteria, false, false, false);
    } else if (criteria.repos && isNaN(parseInt(criteria.repos, 10) && typeof criteria.repos === 'boolean')) {
      requestOptions.url = urlBase + 'search/repositories?' + urlParameters;
    } else if (criteria.repos && isNaN(parseInt(criteria.repos, 10) && typeof criteria.repos === 'string')) {
      requestOptions.url = urlBase + 'search/repositories?' + criteria.repos + urlParameters;
    } else if (criteria.username && (typeof criteria.username === 'boolean') && complex) {
      requestOptions.url = urlBase + 'search/users?' + urlParameters;
    } else if (complex && criteria.username && (typeof criteria.username === 'string')) {
      requestOptions.url = urlBase + 'search/users?' + urlParameters.replace('user:', '');
    } else if (criteria.username && (typeof criteria.username === 'string') && !complex) {
      requestOptions.url = urlBase + 'users/' + criteria.username;
    }
    return requestOptions;
  };


  /*
    @method getErrCallback - returns error callback for grab
   */

  getErrCallback = function() {
    var errCallback;
    errCallback = function(err) {
      return console.error(err);
    };
    return errCallback;
  };


  /*
    @method getResults - process criteria, make request and return data
    @params criteria - user set criteria
   */

  exports.getResults = getResults = function(criteria) {
    return new promise(function(resolve, reject) {
      var errCallback, reposRequest, requestCallback, requestOptions;
      requestOptions = getRequestOptions(criteria);
      reposRequest = (requestOptions.url.indexOf('repos') !== -1 ? true : false);
      requestCallback = undefined;
      if (criteria.all && criteria.username && typeof criteria.username === 'string' && criteria.repos) {
        requestCallback = function(data) {
          var pages, response;
          response = JSON.parse(data);
          pages = Math.ceil(response.total_count / criteria.limit);
          return grabPaged(requestOptions, pages).then(function(data) {
            return resolve({
              data: data,
              renderAsRepos: reposRequest
            });
          });
        };
      } else {
        requestCallback = function(data) {
          return resolve({
            data: JSON.parse(data),
            renderAsRepos: reposRequest
          });
        };
      }
      errCallback = getErrCallback();
      return grab(requestOptions).then(requestCallback, errCallback);
    });
  };

}).call(this);
