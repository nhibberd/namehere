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
});