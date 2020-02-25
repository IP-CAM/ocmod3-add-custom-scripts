# Add Custom Scripts

## Short description
The «Add Custom Scripts» extension is for OpenCart 3 CMS. It is a helper tool that allows to store and get custom scripts as a text.

## Details
The extension extends standard OpenCart class "Document" by adding two methods - addCustomScript and getCustomScripts.
Scripts can be stored in different groups.
* To add script is using `$this->document->addCustomScript($group, $name, $script, $type)`, where:
    * `$group` - group name to store script, type: string;
    * `$name` - name of script, type: string;
    * `$script` - script text, type: string;
    * `$type` - script type ('text/javascript', 'application/ld+json' etc), type: string;
* To get certain group(array) of scripts is using  `$this->document->getCustomScripts($group)`, where:
    * `$group` - name of script group, type: string;

## License
Licensed under [MIT](https://git.io/JvEHu)

## Related modules and extensions
* [Path Manager+](https://www.opencart.com/index.php?route=marketplace/extension/info&extension_id=38192)
* [Breadcrumbs+](https://www.opencart.com/index.php?route=marketplace/extension/info&extension_id=35022)
