(function() {
  var getCriteria, inquirer, promise, repoQuestions, userQuestions;

  promise = require('promise');

  inquirer = require('inquirer');


  /*
   *
   * Interactive utilities
   *
   */

  userQuestions = [
    {
      type: 'input',
      name: 'username',
      message: 'Enter the name of the user you are looking for (leave blank if not known)'
    }, {
      type: 'input',
      name: 'location',
      message: 'Enter a location for user/s (leave blank if not required)'
    }, {
      type: 'input',
      name: 'language',
      message: 'Enter a language that the user is using (leave blank if not required)'
    }, {
      type: 'input',
      name: 'followers',
      message: 'Enter the minimum number of followers for user/s (leave blank if not required)'
    }, {
      type: 'confirm',
      name: 'bare',
      message: 'Would you like returned information to omit extra details such as followers etc.?'
    }, {
      type: 'input',
      name: 'limit',
      message: 'Enter the limit on the amount of returned results (leave blank if fine with 100 MAX)'
    }
  ];

  repoQuestions = [
    {
      type: 'input',
      name: 'repos',
      message: 'Enter the name for a repo or repos if searching by name (else leave blank)'
    }, {
      type: 'input',
      name: 'username',
      message: 'Enter the user associated with the repo/s if there is one (else leave blank)'
    }, {
      type: 'input',
      name: 'language',
      message: 'Enter the language for the repo/s (leave blank if non specific)'
    }, {
      type: 'input',
      name: 'stars',
      message: 'Enter the minimum number of stars for repo/s (leave blank for no minimum)'
    }, {
      type: 'input',
      name: 'forks',
      message: 'Enter the minimum number of forks for repo/s (leave blank for no minimum)'
    }, {
      type: 'confirm',
      name: 'all',
      message: 'Would you like to grab all of the repos matching your criteria? (if expecting more than 100 results)',
      "default": false
    }, {
      type: 'confirm',
      name: 'clone',
      message: 'Would you like to clone any of the found repos? (can do more than one at once)',
      "default": false
    }, {
      type: 'confirm',
      name: 'bare',
      message: 'Would you like to strip some information from the results?',
      "default": false
    }, {
      type: 'list',
      name: 'order',
      choices: ['stars', 'forks', 'updated'],
      "default": 0,
      message: 'Choose which stat you would like to order results by'
    }, {
      type: 'list',
      name: 'sort',
      choices: ['Descending', 'Ascending'],
      "default": 0,
      message: 'Choose the sort order'
    }, {
      type: 'input',
      name: 'limit',
      message: 'Enter the limit on the amount of returned results (leave blank if fine with 100 MAX or requesting all results)'
    }
  ];

  exports.getCriteria = getCriteria = function() {
    var processAnswers;
    processAnswers = function(answers) {
      var answer, criteria;
      criteria = {};
      for (answer in answers) {
        if (answers[answer] && ((typeof answers[answer] === 'string' && answers[answer].trim() !== '') || (typeof answers[answer] === 'boolean'))) {
          criteria[answer] = answers[answer];
        }
      }
      return criteria;
    };
    return new promise(function(resolve, reject) {
      return inquirer.prompt([
        {
          type: 'confirm',
          name: 'searchForRepo',
          message: 'Are you searching for a repo or repos?'
        }
      ], function(answers) {
        var userGen;
        userGen = undefined;
        if (answers.searchForRepo) {
          return inquirer.prompt(repoQuestions, function(answers) {
            var criteria;
            criteria = processAnswers(answers);
            if (!criteria.repos) {
              criteria.repos = true;
            }
            return resolve(criteria);
          });
        } else {
          return inquirer.prompt(userQuestions, function(answers) {
            var criteria;
            criteria = processAnswers(answers);
            if (!criteria.username) {
              criteria.username = true;
            }
            return resolve(criteria);
          });
        }
      });
    });
  };

}).call(this);
