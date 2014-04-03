#PHP Checkstyle

This plugin is for the Atom editor from GitHub, and aims to provide “Checkstyle” integration for PHP.

The plugin supports:

* PHP_CodeSniffer (phpcs)
* Linter (php -l)
* PHP Mess Detector (phpmd)
* Fix the issues using the PHP Coding Standards Fixer (php-cs-fixer) application

You can configure which commands above you want to execute, be it all of them, or just one of them, such as the linter.

The plugin renders the errors in the following formats, again configurable:

* List view
* Gutter view
* Status bar view

You can customise the colours used in the gutter by providing your own stylesheet, just override the css colours for
the 3 CSS classes:

```css
.php-checkstyle-report-phpcs
.php-checkstyle-report-phpmd
.php-checkstyle-report-lint
```

the defaults colours are:

```css
@background-color-phpcs: #3292B8;
@background-color-phpmd: #A087DE;
@background-color-lint: @background-color-error;
```

## List View
![PHP Checkstyle List View](http://www.soulbroken.co.uk/wp-content/uploads/atom-php-checkstyle-sniffer.png)

## Gutter View
![PHP Checkstyle Gutter View](http://www.soulbroken.co.uk/wp-content/uploads/atom-php-checkstyle-gutter-view.png)

## Status Bar View
![PHP Checktyle Status Bar View](http://www.soulbroken.co.uk/wp-content/uploads/atom-php-checkstyle-status-view.png)

This is currently very much work in progress, see [here](https://github.com/benmatselby/atom-php-checkstyle/issues) for features/issues

For more information, please visit [here](http://www.soulbroken.co.uk/code/atom-php-checkstyle/)
