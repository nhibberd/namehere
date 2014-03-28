'use strict';

var toaster = angular.module('toaster', [ 'ui.bootstrap' ]);

toaster.controller('ChatController', function($scope, $http, $timeout) {

    var id = 0;
    $scope.messages = [];

    var poll = function() {
        $timeout(function() {
            $http.get('newmessages?id=' + id).success(function(data) {
                data.forEach(function(entry) {
                    $scope.messages.unshift({ message: entry })
                    id = Math.max(id,entry.id);
                });
                poll();
            });
        }, 1000);
    };     

    $http.get('messages').success(function(data) {
        data.forEach(function(entry) {
            // Push the first call to order messages
            $scope.messages.push({ message: entry })
            id = Math.max(id,entry.id);
        });
    });

    poll();

	$scope.submit = function(msg) {
		$http.post('message', msg).success(function(data) {
            // do nothing
		});
	};

    function paging(msg) {
        $http.get('messages/' + msg.id).success(function(data) {
            // do something        
        }); 
    };
});
