describe 'CLI', ->
  it 'defaults to using AMD type', ->
    expect(parseOptions('--stdio --anonymous').type).toEqual('amd')

  it 'fails on unknown types', ->
    optionsShouldBeInvalid '--stdio --type foogle'

  it 'fails when stdio and AMD are used and the module name is not given and not anonymous', ->
    optionsShouldBeInvalid '--stdio --type amd'

  it 'fails when both anonymous and module name are set', ->
    optionsShouldBeInvalid '--stdio --anonymous --module-name foo'

  it 'fails when coffee is set without stdio', ->
    optionsShouldBeInvalid '--stdio --coffee'

  it 'fails when stdio is not used and to is missing', ->
    optionsShouldBeInvalid '--type amd'

  it 'can read from stdin and write to stdout', ->
    shouldRunCLI ['-s', '-m', 'mymodule'], """
      import "jQuery" as $;
    """, """
      define("mymodule",
        ["jQuery"],
        function($) {
          "use strict";
        });
    """

  it 'can create anonymous modules if desired', ->
    shouldRunCLI ['-s', '--anonymous'], """
      import "jQuery" as $;
    """, """
      define(
        ["jQuery"],
        function($) {
          "use strict";
        });
    """

  it 'can process CoffeeScript', ->
    shouldRunCLI ['-s', '--coffee', '-m', 'caret'], """
      import "jQuery" as $

      $.fn.caret = ->
    """, """
      define("caret",
        ["jQuery"],
        ($) ->
          "use strict"

          $.fn.caret = ->
        )
    """

  it 'can output using a different type', ->
    shouldRunCLI ['-s', '--type', 'cjs'], """
      import "jQuery" as $;

      $.fn.caret = {};
    """, """
      "use strict";
      var $ = require("jQuery");

      $.fn.caret = {};
    """

  it 'will read and write to files in the appropriate directory', ->
    shouldRunCLI ['--to', 'out', 'lib/test.js'],
      'lib/test.js':
        read: """
          import "jQuery" as $;
        """
      'out':
        mkdir: yes
      'out/lib':
        mkdir: yes
      'out/lib/test.js':
        write: """
          define("lib/test",
            ["jQuery"],
            function($) {
              "use strict";
            });
        """

  it 'will automatically process as CoffeeScript based on the filename', ->
    shouldRunCLI ['--to', 'out', 'lib/test.coffee'],
      'lib/test.coffee':
        read: """
          import "jQuery" as $
        """
      'out':
        mkdir: yes
      'out/lib':
        mkdir: yes
      'out/lib/test.coffee':
        write: """
          define("lib/test",
            ["jQuery"],
            ($) ->
              "use strict"
            )
        """

  it 'will not attempt to create directories that already exist', ->
    shouldRunCLI ['--to', 'out', 'lib/test.coffee'],
      'lib/test.coffee':
        read: """
          import "jQuery" as $
        """
      'out':
        exists: yes
      'out/lib':
        mkdir: yes
      'out/lib/test.coffee':
        write: """
          define("lib/test",
            ["jQuery"],
            ($) ->
              "use strict"
            )
        """
