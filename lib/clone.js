(function() {
  var inquirer, process, shell;

  shell = require('shelljs');

  inquirer = require('inquirer');

  exports.process = process = function(repos) {
    var choices, repo, _i, _len;
    if (!shell.which('git')) {
      throw new Error('Git is required in order to clone repos');
    }
    console.log('Git is installed');
    console.log('Lets clone repos!');
    choices = [];
    for (_i = 0, _len = repos.length; _i < _len; _i++) {
      repo = repos[_i];
      choices.push({
        name: repo.name + ': ' + repo.description,
        value: repo.clone_url
      });
    }
    inquirer.prompt([
      {
        type: "checkbox",
        message: "Select repos to clone",
        name: "repos",
        choices: choices
      }
    ], function(answers) {
      var answer, _j, _len1, _ref;
      if (answers.repos && answers.repos.length > 0) {
        _ref = answers.repos;
        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
          answer = _ref[_j];
          shell.exec('git clone ' + answer, {
            silent: true
          }, function(code, output) {
            return console.log(output.cyan);
          });
        }
        console.log('========================================'.cyan);
        console.log('All chosen repos cloned'.cyan);
        return console.log('========================================'.cyan);
      } else {
        console.log('========================================'.cyan);
        console.log('No repos were selected for cloning'.cyan);
        return console.log('========================================'.cyan);
      }
    });
  };

}).call(this);
