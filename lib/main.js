(function() {
  var colors, corvid, pkg, program, startCorvid;

  program = require('commander');

  colors = require('colors');

  pkg = require('../package.json');

  corvid = require('./corvid');


  /*
   *
   * Main entry point into corvid
   *
   */

  program.version(pkg.version).option('-a, --all', 'use if more than 100 repos').option('-u, --username [username]', 'git username to be browsed').option('-r, --repos [count]', 'flag for grabbing repos and also defining number of repos for user').option('-i, --interactive', 'enables interactive search').option('-b, --bare', 'return less information').option('-o, --organisation [organisation]', 'git organisation to be browsed').option('-c, --clone', 'provide interactive cloning of user/org repos').option('--sort [criteria]', 'how to sort results [forks, stars, updated]').option('--order [order]', 'how to order results [asc, desc]').option('-l, --limit [limit]', 'limit the number of results [< 100]').option('--location [location]', 'a location for a user').option('--language [language]', 'a language used by a user or in a repo').option('--followers [followers]', 'amount of followers for a repo or user').option('-f, --forks [forks]', 'amount of forks for repo').option('-s, --stars [stars]', 'amount of stars for a repo');

  program.on('--help', function() {
    console.log('  Examples:');
    console.log('    $ ' + pkg.name + ' --username jh3y');
  });

  program.parse(process.argv);

  startCorvid = function() {
    var err;
    try {
      return corvid.process({
        all: program.all,
        username: program.username,
        repos: program.repos,
        interactive: program.interactive,
        organisation: program.organisation,
        clone: program.clone,
        bare: program.bare,
        sort: program.sort,
        order: program.order,
        limit: program.limit,
        location: program.location,
        language: program.language,
        followers: program.followers,
        forks: program.forks,
        stars: program.stars
      });
    } catch (_error) {
      err = _error;
      return console.log('[', 'corvid'.white, ']', err.toString().red);
    }
  };

  if (process.argv.length === 2) {
    program.help();
  } else {
    if (program.interactive) {
      console.log('lets go INTERACTIVE up in here');
      startCorvid();
    } else {
      startCorvid();
    }
  }

}).call(this);
