# Affogato Editor

Finally, the powerful, extensible, and beautiful code ~~editor~~ workspace that Flutter Web needed.

# Features

This is an outline of Affogato's existing and planned features. The version number indicates the first release where the feature will be made available.

## Core Editor Functionality

| Feature                         | Sub-Features                              | Status                                                                                                  |
|---------------------------------|-------------------------------------------|---------------------------------------------------------------------------------------------------------|
| File Operations                 | Create, Open, Modify, Save                | ![ stable - 1.0.0 ]( https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646 )         |
|                                 | Loading files from local FS via Orca      | ![ underway - 0.1.0 ]( https://img.shields.io/static/v1?label=underway&message=0.1.0&color=3890A8 )     |
|                                 | Loading files from VC/cloud storage       | ![ future - -- ]( https://img.shields.io/static/v1?label=future&message=--&color=685369 )               |
| File Handling UI                | Directory Tree                            | ![ stable - 1.0.0 ]( https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646 )         |
|                                 | Setting/Unsetting Active Document         | ![ stable - 1.0.0 ]( https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646 )         |
|                                 | Drag-and-drop files to move               | ![ underway - 0.2.0 ]( https://img.shields.io/static/v1?label=underway&message=0.2.0&color=3890A8 )     |
|                                 | Read-only file handling                   | ![ stable - 1.0.0 ]( https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646 )         |
| Multi-Pane Support              | Side-by-side panes                        | ![ underway - 0.2.0 ]( https://img.shields.io/static/v1?label=underway&message=0.2.0&color=3890A8 )     |
|                                 | Non-editor panes                          | ![ future - -- ]( https://img.shields.io/static/v1?label=future&message=--&color=685369 )               |
|                                 | Free resizing and layouting               | ![ future - -- ]( https://img.shields.io/static/v1?label=future&message=--&color=685369 )               |
|                                 | Drag-and-drop files into panes            | ![ future - -- ]( https://img.shields.io/static/v1?label=future&message=--&color=685369 )               |
| Status Bar                      | Current Language                          | ![stable - 1.0.0](https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646)             |
| Basic Editor UI                 | Line numbers                              | ![stable - 1.0.0](https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646)             |
|                                 | Breadcrumbs                               | ![stable - 1.0.0](https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646)             |
|                                 | VC diff indicators (sidebar)              | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
| Keyboard Commands               | Custom keybindings to editor actions      | ![underway - 0.0.2](https://img.shields.io/static/v1?label=underway&message=0.0.2&color=3890A8)         |
| Text Editing                    | Bracket/quote matching                    | ![stable - 1.0.0](https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646)             |
|                                 | Automatic indentation                     | ![stable - 1.0.0](https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646)             |
|                                 | Word wrapping                             | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
|                                 | Code folding                              | ![stable - 1.0.0](https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646)             |

## IDE Functionality

| Feature                         | Sub-Features                              | Status                                                                                                  |
|---------------------------------|-------------------------------------------|---------------------------------------------------------------------------------------------------------|
| Syntax Highlighting             | Markdown                                  | ![stable - 1.0.0](https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646)             |
|                                 | Generic (HighlightJS)                     | ![stable - 1.0.0](https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646)             |
|                                 | Custom Affogato Language Bundle           | ![stable - 1.0.0](https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646)             |
| Advanced Text Editing           | Search-and-replace                        | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
|                                 | Multi-file search                         | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
| Static Analysis                 | Semantic Highlighting                     | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
|                                 | Error Formatting UI                       | ![underway - 0.0.2](https://img.shields.io/static/v1?label=underway&message=0.0.2&color=3890A8)         |
|                                 | Linting                                   | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
|                                 | Language Server Protocol Support          |  ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                  |
|                                 | Multi-caret editing                       | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
| Code Execution                  | Intergated Terminal                       | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
|                                 | Multi-shell support                       | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
|                                 | Shell type customisation                  | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
|                                 | ANSI support                              | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
|                                 | Interactive Notebooks                     | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
| Version Control                 | Git commands                              | ![community contrib - --](https://img.shields.io/static/v1?label=community+contrib&message=--&color=724CF9)  |
|                                 | Commit history browser                    | ![community contrib - --](https://img.shields.io/static/v1?label=community+contrib&message=--&color=724CF9)  |
|                                 | Merge conflict resolution UI              | ![community contrib - --](https://img.shields.io/static/v1?label=community+contrib&message=--&color=724CF9)  |
|                                 | Local history for uncomitted files        | ![community contrib - --](https://img.shields.io/static/v1?label=community+contrib&message=--&color=724CF9)  |
|                                 | File diffing (side-by-side)               | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
| IntelliSense                    | Inline suggestions UI                     | ![experimental - 0.0.1](https://img.shields.io/static/v1?label=experimental&message=0.0.1&color=BAAB26) |
|                                 | Docstrings/basic suggestions              | ![experimental - 0.0.1](https://img.shields.io/static/v1?label=experimental&message=0.0.1&color=BAAB26) |
|                                 | Snippets/user-defined shortcuts           | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
| Command Palette                 |                                           | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
| Debugger                        |                                           | ![not included - --](https://img.shields.io/static/v1?label=not+included&message=--&color=8F1A00)       |
| Refactoring                     |                                           | ![not included - --](https://img.shields.io/static/v1?label=not+included&message=--&color=8F1A00)       |
| Real-Time Collaboration         |                                           | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |

## Customisation and Extensibility
| Feature                         | Sub-Features                              | Status                                                                                                  |
|---------------------------------|-------------------------------------------|---------------------------------------------------------------------------------------------------------|
| Configuration and Customisation | Styling configs                           | ![experimental - 0.0.1](https://img.shields.io/static/v1?label=experimental&message=0.0.1&color=BAAB26) |
|                                 | Performance configs                       | ![experimental - 0.0.1](https://img.shields.io/static/v1?label=experimental&message=0.0.1&color=BAAB26) |
|                                 | Workspace configs and layout saving       | ![experimental - 0.0.1](https://img.shields.io/static/v1?label=experimental&message=0.0.1&color=BAAB26) |
|                                 | Session persistence                       | ![experimental - 0.0.1](https://img.shields.io/static/v1?label=experimental&message=0.0.1&color=BAAB26) |
|                                 | Affogato theme bundle                     | ![stable - 1.0.0](https://img.shields.io/static/v1?label=stable&message=1.0.0&color=4D8646)             |
|                                 | User-defined widgets                      | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
| Extensibility                   |  3rd-party extensions/plugins marketplace | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
|                                 | Extension management                      | ![future - --](https://img.shields.io/static/v1?label=future&message=--&color=685369)                   |
|                                 | Window API                                | ![experimental - 0.0.1](https://img.shields.io/static/v1?label=experimental&message=0.0.1&color=BAAB26) |
|                                 | Languages API                             | ![experimental - 0.0.1](https://img.shields.io/static/v1?label=experimental&message=0.0.1&color=BAAB26) |
|                                 | File Manager API                          | ![experimental - 0.0.1](https://img.shields.io/static/v1?label=experimental&message=0.0.1&color=BAAB26) |
|                                 | Extensions API                            | ![experimental - 0.0.1](https://img.shields.io/static/v1?label=experimental&message=0.0.1&color=BAAB26) |
|                                 | Events API                                | ![experimental - 0.0.1](https://img.shields.io/static/v1?label=experimental&message=0.0.1&color=BAAB26) |

> [!WARNING]  
> Experimental features are subject to drastic changes, and dependent projects should not rely on those features until they reach a stable release.