# Affogato Editor

Finally, the powerful, extensible, and beautiful code ~~editor~~ workspace that Flutter Web needed.

> [!NOTE]
> The project is currently in pre-release stage. Feel free to depend on it, but be forewarned that the functionality is very limited right now. I am working to build out features rapidly, and the [milestones](https://github.com/Affogato-Project/Affogato-Editor/milestones) page should give you a rough gauge of when certain features will be complete.

# Documentation

While you can find the API documentation on the [package page](https://pub.dev/documentation/affogato_editor/latest/index.html), you might be better served with the more user-friendly, not incomplete, and up-to-date documentation [here](https://affogato.obsivision.com/docs).

# Features

This is an outline of the features in this version. For a full list of features (both existing and planned), you may visit the [milestones page](https://github.com/Affogato-Project/Affogato-Editor/milestones) of the repo.

> [!WARNING]  
> Experimental features are subject to drastic changes, and dependent projects should not rely on those features until they reach a stable release.

> [!WARNING]  
> Here's a disclaimer that is going be either really relatable or really concerning: The features listed below are not tested systematically. Instead, all I do before pushing out a new release is a manual check that existing features are working.
> I honestly don't have the time or effort to expend on writing tests, at least not right now when the codebase is relatively small and predictable. If YOLO-ing releases into production isn't really your jam, then please reconsider depending on this package for now.
> Alternatively, you can email me directly (obsidian.infinitum@gmail.com) to request for better test coverage, and I'll definitely get down to it if there is sufficient demand for it.

## Core Editor Functionality

- UI that somewhat resembles VS Code
    - Directory tree with icons and indent guides
    - Interactions with buttons on directory tree are highly unstable
- Loading files: programmatic (no uploads/downloads supported yet)
- Modifying file content with autosave
- Multi-pane support: open multiple files at once
    - Drag-and-drop to create new panes and move files between panes
    - Can't remove panes yet
- Line numbers
- Breadcrumbs
- Bracket/quote matching
- Automatic indentation

## IDE Functionality
- Basic language-specific highlighting
- Search, search-and-replace
- Basic completions menu based on words used in document


## Customisation and Extensibility
- Custom theme support
- Save and load workspace state (open panes and documents)
- Rudimentary support for Window, Language, File Manager, Events, and Extensions APIs

# Acknowledgements

The Affogato Project is an open-source project that would not have been possible without the invaluable and selfless contributions of the open-source community:

- Much love and respect to the [Reqable](https://reqable.com/en-US/) project for:
    - the [`re_highlight`](https://pub.dev/packages/re_highlight) submodule which contains HighlightJS syntax highlighting rules rewritten in Dart.

    - the amazing work on their own high-performance code editor, [`re_editor`](https://pub.dev/packages/re_editor), which, as I have come to realise, is an ambitious undertaking
- Many thanks to the open-source [Seti UI Theme](https://github.com/jesseweed/seti-ui) which maintains the icons used by the file explorers in VSCode and other editors.
- and to the [FlutterIcon](https://www.fluttericon.com) tool for helping convert the SVG icons to TTF files that can be imported into Flutter and used as `IconData`.
