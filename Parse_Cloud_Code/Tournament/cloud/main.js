
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:

// Parse.Cloud.define("TournamentList", function(request, response){
//   var query = new Parse.Query("Tournament");

//   query.equalTo("Creator_Name", request.params.Creator_Name);

//   query.find(
//   {
//     success: function(results) 
//     {
//       var sum = 0;
//       var tournamentListAR = [];

//       for (var i = 0; i < results.length; ++i) 
//       {
//       	var dict = {"game_name":results[i].get("game_name"),
//       				"name":results[i].get("name"),
//       				"state":results[i].get("state"),
//       				"tournament_type":results[i].get("tournament_type"),
//               "tournament_id":results[i].get("tournament_id"),
//               "objectId":results[i].id};

//       	tournamentListAR.push(dict);
//       }

//       response.success(tournamentListAR);
//     },
//     error: function() 
//     {
//       response.error("TournamentList failed. :(");
//     }
//   });

// });


Parse.Cloud.job("removeDuplicatedParticipants", function(request, status)
{
  Parse.Cloud.useMasterKey();

  var _ = require("underscore");

  var hashTable = {};

  function hashKeyForParticipant(participant) 
  {
    var fields = ["participant_id"];
    var hashKey = "";
    _.each(fields, function (field) 
    {
        hashKey += participant.get(field) + "/" ;
    });
    return hashKey;
  }

  var participantQuery = new Parse.Query("Participant");

  participantQuery.each(function (participant) 
  {
    var key = hashKeyForParticipant(participant);

    if (key in hashTable) 
    { 
    	// this item was seen before, so destroy this
        return participant.destroy();
    } 
    else 
    { 
    	// it is not in the hashTable, so keep it
        hashTable[key] = 1;
    }

  }).then(function() {
    status.success("removedDuplicatedParticipants completed successfully.");
  }, function(error) {
    status.error("Uh oh, something went wrong.");
  });

});


Parse.Cloud.job("removeDuplicatedMatches", function(request, status)
{
  Parse.Cloud.useMasterKey();

  var _ = require("underscore");

  var hashTable = {};

  function hashKeyForMatch(match) 
  {
    var fields = ["match_id"];
    var hashKey = "";
    _.each(fields, function (field) 
    {
        hashKey += match.get(field) + "/" ;
    });
    return hashKey;
  }

  var matchQuery = new Parse.Query("Match");

  matchQuery.each(function (match) 
  {
    var key = hashKeyForMatch(match);

    if (key in hashTable) 
    { 
    	// this item was seen before, so destroy this
        return match.destroy();
    } 
    else 
    { 
    	// it is not in the hashTable, so keep it
        hashTable[key] = 1;
    }

  }).then(function() {
    status.success("removeDuplicatedMatches completed successfully.");
  }, function(error) {
    status.error("Uh oh, something went wrong.");
  });

});


Parse.Cloud.job("removeDuplicatedTournaments", function(request, status)
{
  Parse.Cloud.useMasterKey();

  var _ = require("underscore");

  var hashTable = {};

  function hashKeyForTournament(tournament) 
  {
    var fields = ["tournament_id"];
    var hashKey = "";
    _.each(fields, function (field) 
    {
        hashKey += tournament.get(field) + "/" ;
    });
    return hashKey;
  }

  var tournamentQuery = new Parse.Query("Tournament");

  tournamentQuery.each(function (tournament) 
  {
    var key = hashKeyForParticipant(tournament);

    if (key in hashTable) 
    { 
    	// this item was seen before, so destroy this
        return tournament.destroy();
    } 
    else 
    { 
    	// it is not in the hashTable, so keep it
        hashTable[key] = 1;
    }

  }).then(function() {
    status.success("removeDuplicatedTournaments completed successfully.");
  }, function(error) {
    status.error("Uh oh, something went wrong.");
  });

});