'use strict';

var toaster = angular.module('toaster', [ 'ui.bootstrap' ]);

toaster.controller('ChatController', function($scope, $http) {

	$http.get('messages').success(function(data) {
		$scope.messages = data;
	});

	$scope.submit = function(msg) {
		$scope.messages.unshift({ message: msg.message })
		$http.post('message', msg).success(function(data) {

		});
	};

        function paging(msg) {
          $http.get('messages/' + msg.id).success(function(data) {
        });

	function poll (msg) {
          $http.get('blah?id=' + msg.id).success(function(data) {
	});
  };
});
