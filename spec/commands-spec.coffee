commands = require '../lib/commands'

describe "CommandPhpcs", ->
    it 'should build the basic command with the config options passed', ->
        options = {
            'executablePath': '/bin/phpcs',
            'standard': 'PSR2',
            'warnings': true
        }
        phpcs = new commands.CommandPhpcs('/path/to/file', options)
        command = phpcs.getCommand()

        expect(command).toBe "/bin/phpcs --standard=PSR2 --report=checkstyle /path/to/file"

    it 'should build the command with the -n flag if warnings should be turned off', ->
        options = {
            'executablePath': '/bin/phpcs',
            'standard': 'PSR2',
            'warnings': false
        }
        phpcs = new commands.CommandPhpcs('/path/to/file', options)
        command = phpcs.getCommand()
        console.log command
        console.log "/bin/phpcs --standard=PSR2 -n --report=checkstyle /path/to/file"
        expect(command).toBe "/bin/phpcs --standard=PSR2 -n --report=checkstyle /path/to/file"

    it 'should parse the report and if there are errors, make an array [line, message]', ->
        phpcs = new commands.CommandPhpcs('/path/to/file', {})

        stdout = """
        <?xml version="1.0" encoding="UTF-8"?>
<checkstyle version="1.5.2">
<file name="/path/to/a/file">
 <error line="160" column="78" severity="error" message="Expected 1 blank line at end of file; 4 found" source="PSR2.Files.EndFileNewline.TooMany"/>
</file>
</checkstyle>
        """

        report = phpcs.process('', stdout, '')
        expect(report).toEqual([['160', 'Expected 1 blank line at end of file; 4 found']])

    it 'should produce an empty report if no errors are found', ->
        phpcs = new commands.CommandPhpcs('/path/to/file', {})

        stdout = """
        <?xml version="1.0" encoding="UTF-8"?>
<checkstyle version="1.5.2">
</checkstyle>
        """

        report = phpcs.process('', stdout, '')
        expect(report).toEqual([])


describe "CommandPhpcsFixer", ->
    it 'should build the basic command with the config options passed', ->
        options = {
            'executablePath': '/bin/php-cs-fixer',
            'level': 'all'
        }
        fixer = new commands.CommandPhpcsFixer('/path/to/file', options)
        command = fixer.getCommand()

        expect(command).toBe "/bin/php-cs-fixer --level=all fix /path/to/file"

    it 'should parse the report and if there are errors, make an array [fixNumber!, message]', ->
        fixer = new commands.CommandPhpcsFixer('/path/to/file', {})

        stdout = """
 1) /home/user/git/path/to/file
        """

        report = fixer.process('', stdout, '')
        expect(report).toEqual([['1', '/home/user/git/path/to/file']])
