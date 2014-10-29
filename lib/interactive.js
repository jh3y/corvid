(function() {
  var getCriteria, inquirer, repoQuestions, userQuestions;

  inquirer = require('inquirer');


  /*
   *
   * Interactive utilities
   *
   */

  userQuestions = [
    {
      type: 'input',
      name: 'userName',
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
      name: 'repoName',
      message: 'Enter the name for a repo or repos if searching by name (else leave blank)'
    }, {
      type: 'input',
      name: 'userName',
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
      name: 'grabAll',
      message: 'Would you like to grab all of the repos matching your criteria? (if expecting more than 100 results)'
    }, {
      type: 'confirm',
      name: 'clone',
      message: 'Would you like to clone any of the found repos? (can do more than one at once)'
    }, {
      type: 'confirm',
      name: 'bare',
      message: 'Would you like to strip some information from the results?'
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
    inquirer.prompt([
      {
        type: 'confirm',
        name: 'searchForRepo',
        message: 'Are you searching for a repo or repos?'
      }
    ], function(answers) {
      if (answers.searchForRepo) {
        console.log('show repo questions');
        return inquirer.prompt(repoQuestions, function(answers) {
          return console.log(JSON.stringify(answers));
        });
      } else {
        console.log('show user questions');
        return inquirer.prompt(userQuestions, function(answers) {
          return console.log(JSON.stringify(answers));
        });
      }
    });
  };

}).call(this);
