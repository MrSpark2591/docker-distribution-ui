'use strict';

// This is the main entrypoint to interact with the Docker registry.

// Helpful resources
//
// https://docs.angularjs.org/tutorial/step_11
// https://docs.angularjs.org/api/ngResource/service/$resource

angular.module('registry-services', ['ngResource'])
  .factory('RegistryHost', ['$resource', '$log',  function($resource, $log){
    return $resource('/registry-host.json', {}, {
      'query': {
        method:'GET',
        isArray: false,
      },
    });
  }])
  .factory('Repository', ['$resource', '$log',  function($resource, $log){
    return $resource('/v2/_catalog', {}, {
      'query': {
        method:'GET',
        isArray: true,
        transformResponse: function(data, headers){
          var res = angular.fromJson(data).repositories;
          var result = [];
          angular.forEach(res, function(value, key) {
            result.push({username: value.split("/")[0], selected: false, name: value, description: value});
          });
          return result;
        }
      },
      'delete': {
        url: '/v1/repositories/:repoUser/:repoName/',
        method: 'DELETE',
      },
    });
  }])
  .factory('Tag', ['$resource', '$log',  function($resource, $log){
    // TODO: rename :repo to repoUser/repoString for convenience.
    return $resource('/v2/:repoUser/:repoName/tags/list', {}, {
      'query': {
        method:'GET',
        isArray: true,
        transformResponse: function(data, headers){
          var res = [];
          var resp = angular.fromJson(data).tags;
          for (var i in resp){
            res.push({name: resp[i], imageId: '' , selected: false});
          }
          return res;
        },
      },
      'delete': {
        url: '/v1/repositories/:repoUser/:repoName/tags/:tagName',
        method: 'DELETE',
      },
      'exists': {
        url: '/v1/repositories/:repoUser/:repoName/tags/:tagName',
        method: 'GET',
        transformResponse: function(data, headers){
          // data will be the image ID if successful or an error object.
          data = angular.isString(angular.fromJson(data));
          return data;
        },
      },
      // Usage: Tag.save({repoUser:'someuser', repoName: 'someRepo', tagName: 'someTagName'}, imageId);
      'save': {
        method:'PUT',
        url: '/v1/repositories/:repoUser/:repoName/tags/:tagName',
      },
    });
  }])
  .factory('Image', ['$resource', '$log',  function($resource, $log){
    return $resource('/v1/images/:imageId/json', {}, {
      'query': { method:'GET', isArray: false},
    });
  }])
  .factory('Ancestry', ['$resource', '$log',  function($resource, $log){
    return $resource('/v1/images/:imageId/ancestry', {}, {
      'query': { method:'GET', isArray: true},
    });
  }]);
