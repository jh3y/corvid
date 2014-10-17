(function() {
  var colors, corvid, err, pkg, program;

  program = require('commander');

  colors = require('colors');

  pkg = require('../package.json');

  corvid = require('./corvid');

  program.version(pkg.version).option('-a, --all', 'use if more than 100 repos').option('-u, --username [username]', 'git username to be browsed').option('-r, --repos [count]', 'flag for grabbing repos and also defining number of repos for user').option('-i, --interactive', 'enables interactive search').option('-o, --organisation [organisation]', 'git organisation to be browsed').option('-c, --clone', 'provide interactive cloning of defined user/org repos').option('-d, --detailed', 'return repo details');

  program.on('--help', function() {
    console.log('  Examples:');
    console.log('""');
    console.log('    $ ' + pkg.name + ' --browse jh3y');
  });

  program.parse(process.argv);

  if (process.argv.length === 2) {
    program.help();
  } else {
    try {
      corvid.process({
        username: program.username,
        reponame: program.reponame,
        repos: program.repos,
        organisation: program.organisation,
        clone: program.clone,
        detailed: program.detailed,
        all: program.all
      });
    } catch (_error) {
      err = _error;
      console.log('[', 'corvid'.white, ']', err.toString().red);
    }
  }

}).call(this);
