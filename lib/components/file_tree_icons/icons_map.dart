part of affogato.editor;

enum SetiIconColor {
  white(Color(0xFFd4d7d6)),
  blue(Color(0xFF519aba)),
  grey(Color(0xFF4d5a5e)),
  green(Color(0xFF8dc149)),
  orange(Color(0xFFe37933)),
  pink(Color(0xFFf55385)),
  purple(Color(0xFFa074c4)),
  red(Color(0xFFcc3e44)),
  yellow(Color(0xFFcbcb41)),
  greyLight(Color(0xFF6d8086)),
  ignore(Color(0xFF41535b)),
  ;

  final Color color;
  const SetiIconColor(this.color);
}

// Once again, thank you generative AI for this Less-to-Dart conversion, and for saving me
// 1 gruelling hour of hand-typing 800 lines of code.

const Map<String, (String, IconData, SetiIconColor)> iconsMap = {
  // 1C:Enterprise
  ".bsl": ("bsl", SetiUiIcons.bsl, SetiIconColor.red),
  ".mdo": ("mdo", SetiUiIcons.mdo, SetiIconColor.red),

  // Apex
  ".cls": ("salesforce", SetiUiIcons.salesforce, SetiIconColor.blue),
  ".apex": ("salesforce", SetiUiIcons.salesforce, SetiIconColor.blue),

  // Assembly
  ".asm": ("asm", SetiUiIcons.asm, SetiIconColor.red),
  ".s": ("asm", SetiUiIcons.asm, SetiIconColor.red),

  // Bicep
  ".bicep": ("bicep", SetiUiIcons.bicep, SetiIconColor.blue),

  // Bazel
  ".bzl": ("bazel", SetiUiIcons.bazel, SetiIconColor.green),
  ".bazel": ("bazel", SetiUiIcons.bazel, SetiIconColor.green),
  ".BUILD": ("bazel", SetiUiIcons.bazel, SetiIconColor.green),
  ".WORKSPACE": ("bazel", SetiUiIcons.bazel, SetiIconColor.green),
  ".bazelignore": ("bazel", SetiUiIcons.bazel, SetiIconColor.green),
  ".bazelversion": ("bazel", SetiUiIcons.bazel, SetiIconColor.green),

  // C
  ".c": ("c", SetiUiIcons.c, SetiIconColor.blue),
  ".h": ("c", SetiUiIcons.c, SetiIconColor.purple),
  ".m": ("c", SetiUiIcons.c, SetiIconColor.yellow),

  // C♯
  ".cs": ("c-sharp", SetiUiIcons.c_sharp, SetiIconColor.blue),
  ".cshtml": ("html", SetiUiIcons.html, SetiIconColor.blue),
  ".aspx": ("html", SetiUiIcons.html, SetiIconColor.blue),
  ".ascx": ("html", SetiUiIcons.html, SetiIconColor.green),
  ".asax": ("html", SetiUiIcons.html, SetiIconColor.yellow),
  ".master": ("html", SetiUiIcons.html, SetiIconColor.yellow),

  // C++
  ".cc": ("cpp", SetiUiIcons.cpp, SetiIconColor.blue),
  ".cpp": ("cpp", SetiUiIcons.cpp, SetiIconColor.blue),
  ".cxx": ("cpp", SetiUiIcons.cpp, SetiIconColor.blue),
  ".c++": ("cpp", SetiUiIcons.cpp, SetiIconColor.blue),
  ".hh": ("cpp", SetiUiIcons.cpp, SetiIconColor.purple),
  ".hpp": ("cpp", SetiUiIcons.cpp, SetiIconColor.purple),
  ".hxx": ("cpp", SetiUiIcons.cpp, SetiIconColor.purple),
  ".h++": ("cpp", SetiUiIcons.cpp, SetiIconColor.purple),
  ".mm": ("cpp", SetiUiIcons.cpp, SetiIconColor.yellow),

  // Clojure
  ".clj": ("clojure", SetiUiIcons.clojure, SetiIconColor.green),
  ".cljs": ("clojure", SetiUiIcons.clojure, SetiIconColor.green),
  ".cljc": ("clojure", SetiUiIcons.clojure, SetiIconColor.green),
  ".edn": ("clojure", SetiUiIcons.clojure, SetiIconColor.blue),

  // COLDFUSION
  ".cfc": ("coldfusion", SetiUiIcons.coldfusion, SetiIconColor.blue),
  ".cfm": ("coldfusion", SetiUiIcons.coldfusion, SetiIconColor.blue),

  // COFFEESCRIPT
  ".coffee": ("coffee", SetiUiIcons.coffee, SetiIconColor.yellow),
  ".litcoffee": ("coffee", SetiUiIcons.coffee, SetiIconColor.yellow),

  // CONFIG
  ".config": ("config", SetiUiIcons.config, SetiIconColor.greyLight),
  ".cfg": ("config", SetiUiIcons.config, SetiIconColor.greyLight),
  ".conf": ("config", SetiUiIcons.config, SetiIconColor.greyLight),

  // CRYSTAL
  ".cr": ("crystal", SetiUiIcons.crystal, SetiIconColor.white),
  ".ecr": (
    "crystal_embedded",
    SetiUiIcons.crystal_embedded,
    SetiIconColor.white
  ),
  ".slang": (
    "crystal_embedded",
    SetiUiIcons.crystal_embedded,
    SetiIconColor.white
  ),

  // CSON
  ".cson": ("json", SetiUiIcons.json, SetiIconColor.yellow),

  // CSS
  ".css": ("css", SetiUiIcons.css, SetiIconColor.blue),
  ".css.map": ("css", SetiUiIcons.css, SetiIconColor.blue),
  ".sss": ("css", SetiUiIcons.css, SetiIconColor.blue),

  // CSV
  ".csv": ("csv", SetiUiIcons.csv, SetiIconColor.green),
  ".xls": ("xls", SetiUiIcons.xls, SetiIconColor.green),
  ".xlsx": ("xls", SetiUiIcons.xls, SetiIconColor.green),

  // CUDA
  ".cu": ("cu", SetiUiIcons.cu, SetiIconColor.green),
  ".cuh": ("cu", SetiUiIcons.cu, SetiIconColor.purple),
  ".hu": ("cu", SetiUiIcons.cu, SetiIconColor.purple),

  // CAKE
  ".cake": ("cake", SetiUiIcons.cake, SetiIconColor.red),
  ".ctp": ("cake_php", SetiUiIcons.cake_php, SetiIconColor.red),

  // D
  ".d": ("d", SetiUiIcons.d, SetiIconColor.red),

  // DOC
  ".doc": ("word", SetiUiIcons.word, SetiIconColor.blue),
  ".docx": ("word", SetiUiIcons.word, SetiIconColor.blue),

  // EJS
  ".ejs": ("ejs", SetiUiIcons.ejs, SetiIconColor.yellow),

  // ELIXIR
  ".ex": ("elixir", SetiUiIcons.elixir, SetiIconColor.purple),
  ".exs": ("elixir_script", SetiUiIcons.elixir_script, SetiIconColor.purple),
  "mix": ("hex", SetiUiIcons.hex, SetiIconColor.red), // Partial

  // ELM
  ".elm": ("elm", SetiUiIcons.elm, SetiIconColor.blue),

  // FAVICON
  ".ico": ("favicon", SetiUiIcons.favicon, SetiIconColor.yellow),

  // F#
  ".fs": ("f-sharp", SetiUiIcons.f_sharp, SetiIconColor.blue),
  ".fsx": ("f-sharp", SetiUiIcons.f_sharp, SetiIconColor.blue),

  // GITIGNORE
  ".gitignore": ("git", SetiUiIcons.git, SetiIconColor.ignore),
  ".gitconfig": ("git", SetiUiIcons.git, SetiIconColor.ignore),
  ".gitkeep": ("git", SetiUiIcons.git, SetiIconColor.ignore),
  ".gitattributes": ("git", SetiUiIcons.git, SetiIconColor.ignore),
  ".gitmodules": ("git", SetiUiIcons.git, SetiIconColor.ignore),
  "COMMIT_EDITMSG": ("git", SetiUiIcons.git, SetiIconColor.ignore),
  "MERGE_MSG": ("git", SetiUiIcons.git, SetiIconColor.ignore),

  // GO
  ".go": ("go2", SetiUiIcons.go2, SetiIconColor.blue),
  ".slide": ("go", SetiUiIcons.go2, SetiIconColor.blue),
  ".article": ("go", SetiUiIcons.go2, SetiIconColor.blue),

  // GODOT
  ".gd": ("godot", SetiUiIcons.godot, SetiIconColor.blue),
  ".godot": ("godot", SetiUiIcons.godot, SetiIconColor.red),
  ".tres": ("godot", SetiUiIcons.godot, SetiIconColor.yellow),
  ".tscn": ("godot", SetiUiIcons.godot, SetiIconColor.purple),

  // GRADLE
  ".gradle": ("gradle", SetiUiIcons.gradle, SetiIconColor.blue),

  // GRAILS
  ".groovy": ("grails", SetiUiIcons.grails, SetiIconColor.green),
  ".gsp": ("grails", SetiUiIcons.grails, SetiIconColor.green),

  // GRAPHQL
  ".gql": ("graphql", SetiUiIcons.graphql, SetiIconColor.pink),
  ".graphql": ("graphql", SetiUiIcons.graphql, SetiIconColor.pink),
  ".graphqls": ("graphql", SetiUiIcons.graphql, SetiIconColor.pink),

  // HACK
  ".hack": ("hacklang", SetiUiIcons.hacklang, SetiIconColor.orange),

  // HAML
  ".haml": ("haml", SetiUiIcons.haml, SetiIconColor.red),

  // HANDLEBARS
  ".handlebars": ("mustache", SetiUiIcons.mustache, SetiIconColor.orange),
  ".hbs": ("mustache", SetiUiIcons.mustache, SetiIconColor.orange),
  ".hjs": ("mustache", SetiUiIcons.mustache, SetiIconColor.orange),

  // HASKELL
  ".hs": ("haskell", SetiUiIcons.haskell, SetiIconColor.purple),
  ".lhs": ("haskell", SetiUiIcons.haskell, SetiIconColor.purple),

  // HAXE
  ".hx": ("haxe", SetiUiIcons.haxe, SetiIconColor.orange),
  ".hxs": ("haxe", SetiUiIcons.haxe, SetiIconColor.yellow),
  ".hxp": ("haxe", SetiUiIcons.haxe, SetiIconColor.blue),
  ".hxml": ("haxe", SetiUiIcons.haxe, SetiIconColor.purple),

  // HTML
  ".html": ("html", SetiUiIcons.html, SetiIconColor.orange),

  // JADE
  ".jade": ("jade", SetiUiIcons.jade, SetiIconColor.red),

  // JAVA
  ".java": ("java", SetiUiIcons.java, SetiIconColor.red),
  ".class": ("java", SetiUiIcons.java, SetiIconColor.blue),
  ".classpath": ("java", SetiUiIcons.java, SetiIconColor.red),
  ".properties": ("java", SetiUiIcons.java, SetiIconColor.red),

  // JAVASCRIPT
  ".js": ("javascript", SetiUiIcons.javascript, SetiIconColor.yellow),
  ".js.map": ("javascript", SetiUiIcons.javascript, SetiIconColor.yellow),
  ".cjs": ("javascript", SetiUiIcons.javascript, SetiIconColor.yellow),
  ".cjs.map": ("javascript", SetiUiIcons.javascript, SetiIconColor.yellow),
  ".mjs": ("javascript", SetiUiIcons.javascript, SetiIconColor.yellow),
  ".mjs.map": ("javascript", SetiUiIcons.javascript, SetiIconColor.yellow),
  ".spec.js": ("javascript", SetiUiIcons.javascript, SetiIconColor.orange),
  ".spec.cjs": ("javascript", SetiUiIcons.javascript, SetiIconColor.orange),
  ".spec.mjs": ("javascript", SetiUiIcons.javascript, SetiIconColor.orange),
  ".test.js": ("javascript", SetiUiIcons.javascript, SetiIconColor.orange),
  ".test.cjs": ("javascript", SetiUiIcons.javascript, SetiIconColor.orange),
  ".test.mjs": ("javascript", SetiUiIcons.javascript, SetiIconColor.orange),
  ".es": ("javascript", SetiUiIcons.javascript, SetiIconColor.yellow),
  ".es5": ("javascript", SetiUiIcons.javascript, SetiIconColor.yellow),
  ".es6": ("javascript", SetiUiIcons.javascript, SetiIconColor.yellow),
  ".es7": ("javascript", SetiUiIcons.javascript, SetiIconColor.yellow),

  // JINJA
  ".jinja": ("jinja", SetiUiIcons.jinja, SetiIconColor.red),
  ".jinja2": ("jinja", SetiUiIcons.jinja, SetiIconColor.red),

  // JSON
  ".json": ("json", SetiUiIcons.json, SetiIconColor.yellow),

  // JULIA
  ".jl": ("julia", SetiUiIcons.julia, SetiIconColor.purple),

  // KARMA
  "karma.conf.js": ("karma", SetiUiIcons.karma, SetiIconColor.green),
  "karma.conf.cjs": ("karma", SetiUiIcons.karma, SetiIconColor.green),
  "karma.conf.mjs": ("karma", SetiUiIcons.karma, SetiIconColor.green),
  "karma.conf.coffee": ("karma", SetiUiIcons.karma, SetiIconColor.green),

  // KOTLIN
  '.kt': ('kotlin', SetiUiIcons.kotlin, SetiIconColor.orange),
  '.kts': ('kotlin', SetiUiIcons.kotlin, SetiIconColor.orange),

  // DART
  ".dart": ("dart", SetiUiIcons.dart, SetiIconColor.blue),

  // LESS
  ".less": ("less", SetiUiIcons.less, SetiIconColor.blue),

  // LIQUID
  ".liquid": ("liquid", SetiUiIcons.liquid, SetiIconColor.green),

  // LIVESCRIPT
  ".ls": ("livescript", SetiUiIcons.livescript, SetiIconColor.blue),

  // LUA
  ".lua": ("lua", SetiUiIcons.lua, SetiIconColor.blue),

  // MARKDOWN
  ".markdown": ("markdown", SetiUiIcons.markdown, SetiIconColor.blue),
  ".md": ("markdown", SetiUiIcons.markdown, SetiIconColor.blue),

  // ARGDOWN
  ".argdown": ("argdown", SetiUiIcons.argdown, SetiIconColor.blue),
  ".ad": ("argdown", SetiUiIcons.argdown, SetiIconColor.blue),

  // README
  "README.md": ("info", SetiUiIcons.info, SetiIconColor.blue),
  "README.txt": ("info", SetiUiIcons.info, SetiIconColor.blue),
  "README": ("info", SetiUiIcons.info, SetiIconColor.blue),

  // CHANGELOG
  'CHANGELOG.md': ('clock', SetiUiIcons.clock, SetiIconColor.blue),
  'CHANGELOG.txt': ('clock', SetiUiIcons.clock, SetiIconColor.blue),
  'CHANGELOG': ('clock', SetiUiIcons.clock, SetiIconColor.blue),
  'CHANGES.md': ('clock', SetiUiIcons.clock, SetiIconColor.blue),
  'CHANGES.txt': ('clock', SetiUiIcons.clock, SetiIconColor.blue),
  'CHANGES': ('clock', SetiUiIcons.clock, SetiIconColor.blue),
  'VERSION.md': ('clock', SetiUiIcons.clock, SetiIconColor.blue),
  'VERSION.txt': ('clock', SetiUiIcons.clock, SetiIconColor.blue),
  'VERSION': ('clock', SetiUiIcons.clock, SetiIconColor.blue),

  // MAVEN
  "mvnw": ("maven", SetiUiIcons.maven, SetiIconColor.red),
  "pom.xml": ("maven", SetiUiIcons.maven, SetiIconColor.red),

  // MUSTACHE
  ".mustache": ("mustache", SetiUiIcons.mustache, SetiIconColor.orange),
  ".stache": ("mustache", SetiUiIcons.mustache, SetiIconColor.orange),

  // NIM
  ".nim": ("nim", SetiUiIcons.nim, SetiIconColor.yellow),
  ".nims": ("nim", SetiUiIcons.nim, SetiIconColor.yellow),

  // NOTEBOOKS
  ".github-issues": ("github", SetiUiIcons.github, SetiIconColor.white),
  ".ipynb": ("notebook", SetiUiIcons.notebook, SetiIconColor.blue),

  // NPM
  ".njk": ("nunjucks", SetiUiIcons.nunjucks, SetiIconColor.green),
  ".nunjucks": ("nunjucks", SetiUiIcons.nunjucks, SetiIconColor.green),
  ".nunjs": ("nunjucks", SetiUiIcons.nunjucks, SetiIconColor.green),
  ".nunj": ("nunjucks", SetiUiIcons.nunjucks, SetiIconColor.green),
  ".njs": ("nunjucks", SetiUiIcons.nunjucks, SetiIconColor.green),
  ".nj": ("nunjucks", SetiUiIcons.nunjucks, SetiIconColor.green),

  // NPM
  ".npm-debug.log": ("npm", SetiUiIcons.npm, SetiIconColor.ignore),
  ".npmignore": ("npm", SetiUiIcons.npm, SetiIconColor.red),
  ".npmrc": ("npm", SetiUiIcons.npm, SetiIconColor.red),

  // OCAML
  ".ml": ("ocaml", SetiUiIcons.ocaml, SetiIconColor.orange),
  ".mli": ("ocaml", SetiUiIcons.ocaml, SetiIconColor.orange),
  ".cmx": ("ocaml", SetiUiIcons.ocaml, SetiIconColor.orange),
  ".cmxa": ("ocaml", SetiUiIcons.ocaml, SetiIconColor.orange),

  // ODATA
  ".odata": ("odata", SetiUiIcons.odata, SetiIconColor.orange),

  // PERL
  ".pl": ("perl", SetiUiIcons.perl, SetiIconColor.blue),

  // PHP
  ".php": ("php", SetiUiIcons.php, SetiIconColor.purple),
  ".php.inc": ("php", SetiUiIcons.php, SetiIconColor.purple),

  // PIPELINE
  ".pipeline": ("pipeline", SetiUiIcons.pipeline, SetiIconColor.orange),

  // PLANNING
  '.pddl': ('pddl', SetiUiIcons.pddl, SetiIconColor.purple),
  '.plan': ('plan', SetiUiIcons.plan, SetiIconColor.green),
  '.happenings': ('happenings', SetiUiIcons.happenings, SetiIconColor.blue),

  // POWERSHELL
  ".ps1": ("powershell", SetiUiIcons.powershell, SetiIconColor.blue),
  ".psd1": ("powershell", SetiUiIcons.powershell, SetiIconColor.blue),
  ".psm1": ("powershell", SetiUiIcons.powershell, SetiIconColor.blue),

  // PRISMA
  ".prisma": ("prisma", SetiUiIcons.prisma, SetiIconColor.blue),

  // PUG
  ".pug": ("pug", SetiUiIcons.pug, SetiIconColor.red),

  // PUPPET .pp
  ".pp": ("puppet", SetiUiIcons.puppet, SetiIconColor.yellow),
  ".epp": ("puppet", SetiUiIcons.puppet, SetiIconColor.yellow),

  // PURESCRIPT .purs
  ".purs": ("purescript", SetiUiIcons.purescript, SetiIconColor.white),

  // PYTHON
  ".py": ("python", SetiUiIcons.python, SetiIconColor.blue),

  // REACT
  ".jsx": ("react", SetiUiIcons.react, SetiIconColor.blue),
  ".spec.jsx": ("react", SetiUiIcons.react, SetiIconColor.orange),
  ".test.jsx": ("react", SetiUiIcons.react, SetiIconColor.orange),
  ".cjsx": ("react", SetiUiIcons.react, SetiIconColor.blue),
  ".tsx": ("react", SetiUiIcons.react, SetiIconColor.blue),
  ".spec.tsx": ("react", SetiUiIcons.react, SetiIconColor.orange),
  ".test.tsx": ("react", SetiUiIcons.react, SetiIconColor.orange),

  // REASONML
  ".re": ("reasonml", SetiUiIcons.reasonml, SetiIconColor.red),

  // ReScript
  ".res": ("rescript", SetiUiIcons.rescript, SetiIconColor.red),
  ".resi": ("rescript", SetiUiIcons.rescript, SetiIconColor.pink),

  // R
  '.R': ('R', SetiUiIcons.r, SetiIconColor.blue),
  '.rmd': ('R', SetiUiIcons.r, SetiIconColor.blue),

  // RUBY
  ".rb": ("ruby", SetiUiIcons.ruby, SetiIconColor.red),
  "Gemfile": ("ruby", SetiUiIcons.ruby, SetiIconColor.red),
  "gemfile": ("ruby", SetiUiIcons.ruby, SetiIconColor.red),
  ".erb": ("html_erb", SetiUiIcons.html_erb, SetiIconColor.red),
  ".erb.html": ("html_erb", SetiUiIcons.html_erb, SetiIconColor.red),
  ".html.erb": ("html_erb", SetiUiIcons.html_erb, SetiIconColor.red),

  // RUST
  ".rs": ("rust", SetiUiIcons.rust, SetiIconColor.greyLight),

  // SASS
  ".sass": ("sass", SetiUiIcons.sass, SetiIconColor.pink),
  ".scss": ("sass", SetiUiIcons.sass, SetiIconColor.pink),

  // SPRING
  ".springBeans": ("spring", SetiUiIcons.spring, SetiIconColor.green),

  // SLIM
  ".slim": ("slim", SetiUiIcons.slim, SetiIconColor.orange),

  // SMARTY
  ".smarty.tpl": ("smarty", SetiUiIcons.smarty, SetiIconColor.yellow),
  ".tpl": ("smarty", SetiUiIcons.smarty, SetiIconColor.yellow),

  // SBT
  ".sbt": ("sbt", SetiUiIcons.sbt, SetiIconColor.blue),

  // SCALA
  ".scala": ("scala", SetiUiIcons.scala, SetiIconColor.red),

  // SCALA
  ".sol": ("ethereum", SetiUiIcons.ethereum, SetiIconColor.blue),

  // STYLUS
  ".styl": ("stylus", SetiUiIcons.stylus, SetiIconColor.green),

  // SVELTE
  ".svelte": ("svelte", SetiUiIcons.svelte, SetiIconColor.red),

  // SWIFT
  ".swift": ("swift", SetiUiIcons.swift, SetiIconColor.orange),

  // SQL
  ".sql": ("db", SetiUiIcons.db, SetiIconColor.pink),

  // SOQL
  ".soql": ("db", SetiUiIcons.db, SetiIconColor.blue),

  // TERRAFORM
  ".tf": ("terraform", SetiUiIcons.terraform, SetiIconColor.purple),
  ".tf.json": ("terraform", SetiUiIcons.terraform, SetiIconColor.purple),
  ".tfvars": ("terraform", SetiUiIcons.terraform, SetiIconColor.purple),
  ".tfvars.json": ("terraform", SetiUiIcons.terraform, SetiIconColor.purple),

  // TEX
  ".tex": ("tex", SetiUiIcons.tex, SetiIconColor.blue),
  ".sty": ("tex", SetiUiIcons.tex, SetiIconColor.yellow),
  ".dtx": ("tex", SetiUiIcons.tex, SetiIconColor.orange),
  ".ins": ("tex", SetiUiIcons.tex, SetiIconColor.white),

  // TEXT
  ".txt": ("default", SetiUiIcons.default_icon, SetiIconColor.white),

  // TOML
  ".toml": ("config", SetiUiIcons.config, SetiIconColor.greyLight),

  // TWIG
  ".twig": ("twig", SetiUiIcons.twig, SetiIconColor.green),

  // TYPESCRIPT
  ".ts": ("typescript", SetiUiIcons.typescript, SetiIconColor.blue),
  ".spec.ts": ("typescript", SetiUiIcons.typescript, SetiIconColor.orange),
  ".test.ts": ("typescript", SetiUiIcons.typescript, SetiIconColor.orange),

  // TSCONFIG
  "tsconfig.json": ("tsconfig", SetiUiIcons.tsconfig, SetiIconColor.blue),

  // VALA
  ".vala": ("vala", SetiUiIcons.vala, SetiIconColor.greyLight),
  ".vapi": ("vala", SetiUiIcons.vala, SetiIconColor.greyLight),

  // Visualforce
  ".component": ("html", SetiUiIcons.html, SetiIconColor.orange),

  // VITE
  "vite.config.js": ("vite", SetiUiIcons.vite, SetiIconColor.yellow),
  "vite.config.ts": ("vite", SetiUiIcons.vite, SetiIconColor.yellow),
  "vite.config.mjs": ("vite", SetiUiIcons.vite, SetiIconColor.yellow),
  "vite.config.mts": ("vite", SetiUiIcons.vite, SetiIconColor.yellow),
  "vite.config.cjs": ("vite", SetiUiIcons.vite, SetiIconColor.yellow),
  "vite.config.cts": ("vite", SetiUiIcons.vite, SetiIconColor.yellow),

  // VUE
  ".vue": ("vue", SetiUiIcons.vue, SetiIconColor.green),

  // WEBASSEMBLY
  '.wasm': ('wasm', SetiUiIcons.wasm, SetiIconColor.purple),
  '.wat': ('wat', SetiUiIcons.wat, SetiIconColor.purple),

  // XML
  ".xml": ("xml", SetiUiIcons.xml, SetiIconColor.orange),

  // YML
  '.yml': ('yml', SetiUiIcons.yml, SetiIconColor.purple),
  '.yaml': ('yml', SetiUiIcons.yml, SetiIconColor.purple),

  // SWAGGER
  'swagger.json': ('json', SetiUiIcons.json, SetiIconColor.green),
  'swagger.yml': ('json', SetiUiIcons.json, SetiIconColor.green),
  'swagger.yaml': ('json', SetiUiIcons.json, SetiIconColor.green),

  // PROLOG
  '.pro': ('prolog', SetiUiIcons.prolog, SetiIconColor.orange),

  // ZIG
  ".zig": ("zig", SetiUiIcons.zig, SetiIconColor.orange),

  // - - - - - - - - - - - - - - - - - - -
  //  GENERIC FILE TYPES - EXTENSION BASED
  // - - - - - - - - - - - - - - - - - - -

  // ARCHIVES
  ".jar": ("zip", SetiUiIcons.zip, SetiIconColor.red),
  ".zip": ("zip", SetiUiIcons.zip, SetiIconColor.greyLight),
  ".wgt": ("wgt", SetiUiIcons.wgt, SetiIconColor.blue),

  // ADOBE FILE
  ".ai": ("illustrator", SetiUiIcons.illustrator, SetiIconColor.yellow),
  ".psd": ("photoshop", SetiUiIcons.photoshop, SetiIconColor.blue),
  ".pdf": ("pdf", SetiUiIcons.pdf, SetiIconColor.red),

  // FONT FILES
  ".eot": ("font", SetiUiIcons.font, SetiIconColor.red),
  ".ttf": ("font", SetiUiIcons.font, SetiIconColor.red),
  ".woff": ("font", SetiUiIcons.font, SetiIconColor.red),
  ".woff2": ("font", SetiUiIcons.font, SetiIconColor.red),
  ".otf": ("font", SetiUiIcons.font, SetiIconColor.red),

  // IMAGE FILES
  ".avif": ("image", SetiUiIcons.image, SetiIconColor.purple),
  ".gif": ("image", SetiUiIcons.image, SetiIconColor.purple),
  ".jpg": ("image", SetiUiIcons.image, SetiIconColor.purple),
  ".jpeg": ("image", SetiUiIcons.image, SetiIconColor.purple),
  ".png": ("image", SetiUiIcons.image, SetiIconColor.purple),
  ".pxm": ("image", SetiUiIcons.image, SetiIconColor.purple),
  ".svg": ("svg", SetiUiIcons.svg, SetiIconColor.purple),
  ".svgx": ("image", SetiUiIcons.image, SetiIconColor.purple),
  ".tiff": ("image", SetiUiIcons.image, SetiIconColor.purple),
  ".webp": ("image", SetiUiIcons.image, SetiIconColor.purple),

  // SUBLIME
  ".sublime-project": ("sublime", SetiUiIcons.sublime, SetiIconColor.orange),
  ".sublime-workspace": ("sublime", SetiUiIcons.sublime, SetiIconColor.orange),

  // VS CODE
  ".code-search": (
    "code-search",
    SetiUiIcons.code_search,
    SetiIconColor.purple
  ),

  // SHELL
  ".sh": ("shell", SetiUiIcons.shell, SetiIconColor.green),
  ".zsh": ("shell", SetiUiIcons.shell, SetiIconColor.green),
  ".fish": ("shell", SetiUiIcons.shell, SetiIconColor.green),
  ".zshrc": ("shell", SetiUiIcons.shell, SetiIconColor.green),
  ".bashrc": ("shell", SetiUiIcons.shell, SetiIconColor.green),

  // VIDEO FILES
  ".mov": ("video", SetiUiIcons.video, SetiIconColor.pink),
  ".ogv": ("video", SetiUiIcons.video, SetiIconColor.pink),
  ".webm": ("video", SetiUiIcons.video, SetiIconColor.pink),
  ".avi": ("video", SetiUiIcons.video, SetiIconColor.pink),
  ".mpg": ("video", SetiUiIcons.video, SetiIconColor.pink),
  ".mp4": ("video", SetiUiIcons.video, SetiIconColor.pink),

// AUDIO FILES
  '.mp3': ('audio', SetiUiIcons.audio, SetiIconColor.purple),
  '.ogg': ('audio', SetiUiIcons.audio, SetiIconColor.purple),
  '.wav': ('audio', SetiUiIcons.audio, SetiIconColor.purple),
  '.flac': ('audio', SetiUiIcons.audio, SetiIconColor.purple),

// 3D files
  '.3ds': ('svg', SetiUiIcons.svg, SetiIconColor.blue),
  '.3dm': ('svg', SetiUiIcons.svg, SetiIconColor.blue),
  '.stl': ('svg', SetiUiIcons.svg, SetiIconColor.blue),
  '.obj': ('svg', SetiUiIcons.svg, SetiIconColor.blue),
  '.dae': ('svg', SetiUiIcons.svg, SetiIconColor.blue),

// WINDOWS
  ".bat": ("windows", SetiUiIcons.windows, SetiIconColor.blue),
  ".cmd": ("windows", SetiUiIcons.windows, SetiIconColor.blue),

// - - - - - - - - -
// NAME BASED ICONS
// - - - - - - - - -

// APACHE
  "mime.types": ("config", SetiUiIcons.config, SetiIconColor.greyLight),

// CI
  "Jenkinsfile": ("jenkins", SetiUiIcons.jenkins, SetiIconColor.red),

// BABEL
  ".babelrc": ("babel", SetiUiIcons.babel, SetiIconColor.yellow),
  ".babelrc.js": ("babel", SetiUiIcons.babel, SetiIconColor.yellow),
  ".babelrc.cjs": ("babel", SetiUiIcons.babel, SetiIconColor.yellow),
  "babel.config.js": ("babel", SetiUiIcons.babel, SetiIconColor.yellow),
  "babel.config.json": ("babel", SetiUiIcons.babel, SetiIconColor.yellow),
  "babel.config.cjs": ("babel", SetiUiIcons.babel, SetiIconColor.yellow),

// BAZEL
  "BUILD": ("bazel", SetiUiIcons.bazel, SetiIconColor.green),
  "BUILD.bazel": ("bazel", SetiUiIcons.bazel, SetiIconColor.green),
  "WORKSPACE": ("bazel", SetiUiIcons.bazel, SetiIconColor.green),
  "WORKSPACE.bazel": ("bazel", SetiUiIcons.bazel, SetiIconColor.green),
  ".bazelrc": ("bazel", SetiUiIcons.bazel, SetiIconColor.grey),

// BOWER
  "bower.json": ("bower", SetiUiIcons.bower, SetiIconColor.orange),
  "Bower.json": ("bower", SetiUiIcons.bower, SetiIconColor.orange),
  ".bowerrc": ("bower", SetiUiIcons.bower, SetiIconColor.orange),

// DOCKER
  "dockerfile": ("docker", SetiUiIcons.docker, SetiIconColor.blue),
  "Dockerfile": ("docker", SetiUiIcons.docker, SetiIconColor.blue),
  "DOCKERFILE": ("docker", SetiUiIcons.docker, SetiIconColor.blue),
  ".dockerignore": ("docker", SetiUiIcons.docker, SetiIconColor.grey),
  "docker-healthcheck": ("docker", SetiUiIcons.docker, SetiIconColor.green),
  "docker-compose.yml": ("docker", SetiUiIcons.docker, SetiIconColor.pink),
  "docker-compose.yaml": ("docker", SetiUiIcons.docker, SetiIconColor.pink),
  "docker-compose.override.yml": (
    "docker",
    SetiUiIcons.docker,
    SetiIconColor.pink
  ),
  "docker-compose.override.yaml": (
    "docker",
    SetiUiIcons.docker,
    SetiIconColor.pink
  ),

// BABEL
  ".codeclimate.yml": (
    "code_climate",
    SetiUiIcons.code_climate,
    SetiIconColor.green
  ),

// ESLINT
  ".eslintrc": ("eslint", SetiUiIcons.eslint, SetiIconColor.purple),
  ".eslintrc.js": ("eslint", SetiUiIcons.eslint, SetiIconColor.purple),
  ".eslintrc.cjs": ("eslint", SetiUiIcons.eslint, SetiIconColor.purple),
  ".eslintrc.yaml": ("eslint", SetiUiIcons.eslint, SetiIconColor.purple),
  ".eslintrc.yml": ("eslint", SetiUiIcons.eslint, SetiIconColor.purple),
  ".eslintrc.json": ("eslint", SetiUiIcons.eslint, SetiIconColor.purple),
  ".eslintignore": ("eslint", SetiUiIcons.eslint, SetiIconColor.grey),
  "eslint.config.js": ("eslint", SetiUiIcons.eslint, SetiIconColor.purple),

// FIREBASE
  ".firebaserc": ("firebase", SetiUiIcons.firebase, SetiIconColor.orange),
  "firebase.json": ("firebase", SetiUiIcons.firebase, SetiIconColor.orange),

// GECKODRIVER
  "geckodriver": ("firefox", SetiUiIcons.firefox, SetiIconColor.orange),

// GITLAB
  ".gitlab-ci.yml": ("gitlab", SetiUiIcons.gitlab, SetiIconColor.orange),

// GRUNT
  "Gruntfile.js": ("grunt", SetiUiIcons.grunt, SetiIconColor.orange),
  "gruntfile.babel.js": ("grunt", SetiUiIcons.grunt, SetiIconColor.orange),
  "Gruntfile.babel.js": ("grunt", SetiUiIcons.grunt, SetiIconColor.orange),
  "gruntfile.js": ("grunt", SetiUiIcons.grunt, SetiIconColor.orange),
  "Gruntfile.coffee": ("grunt", SetiUiIcons.grunt, SetiIconColor.orange),
  "gruntfile.coffee": ("grunt", SetiUiIcons.grunt, SetiIconColor.orange),

// GULP
  "GULPFILE": ("gulp", SetiUiIcons.gulp, SetiIconColor.red),
  "Gulpfile": ("gulp", SetiUiIcons.gulp, SetiIconColor.red),
  "gulpfile": ("gulp", SetiUiIcons.gulp, SetiIconColor.red),
  "gulpfile.js": ("gulp", SetiUiIcons.gulp, SetiIconColor.red),

// IONIC
  "ionic.config.json": ("ionic", SetiUiIcons.ionic, SetiIconColor.blue),
  "Ionic.config.json": ("ionic", SetiUiIcons.ionic, SetiIconColor.blue),
  "ionic.project": ("ionic", SetiUiIcons.ionic, SetiIconColor.blue),
  "Ionic.project": ("ionic", SetiUiIcons.ionic, SetiIconColor.blue),

// JSHINT
  ".jshintrc": ("javascript", SetiUiIcons.javascript, SetiIconColor.blue),
  ".jscsrc": ("javascript", SetiUiIcons.javascript, SetiIconColor.blue),

  "platformio.ini": (
    'platformio',
    SetiUiIcons.platformio,
    SetiIconColor.orange
  ),

// ROLLUP
  "rollup.config.js": ("rollup", SetiUiIcons.rollup, SetiIconColor.red),

// SASS LINT
  "sass-lint.yml": ("sass", SetiUiIcons.sass, SetiIconColor.pink),

// STYLELINT
  '.stylelintrc': ('stylelint', SetiUiIcons.stylelint, SetiIconColor.white),
  '.stylelintrc.json': (
    'stylelint',
    SetiUiIcons.stylelint,
    SetiIconColor.white
  ),
  '.stylelintrc.yaml': (
    'stylelint',
    SetiUiIcons.stylelint,
    SetiIconColor.white
  ),
  '.stylelintrc.yml': ('stylelint', SetiUiIcons.stylelint, SetiIconColor.white),
  '.stylelintrc.js': ('stylelint', SetiUiIcons.stylelint, SetiIconColor.white),
  '.stylelintignore': ('stylelint', SetiUiIcons.stylelint, SetiIconColor.grey),
  'stylelint.config.js': (
    'stylelint',
    SetiUiIcons.stylelint,
    SetiIconColor.white
  ),
  'stylelint.config.cjs': (
    'stylelint',
    SetiUiIcons.stylelint,
    SetiIconColor.white
  ),
  'stylelint.config.mjs': (
    'stylelint',
    SetiUiIcons.stylelint,
    SetiIconColor.white
  ),

// YARN
  "yarn.clean": ("yarn", SetiUiIcons.yarn, SetiIconColor.blue),
  "yarn.lock": ("yarn", SetiUiIcons.yarn, SetiIconColor.blue),

// WEBPACK // seem to be missing webpack icons
/*   "webpack.config.js": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.config.cjs": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.config.mjs": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.config.ts": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.config.build.js": (
    "webpack",
    SetiUiIcons.webpack,
    SetiIconColor.blue
  ),
  "webpack.config.build.cjs": (
    "webpack",
    SetiUiIcons.webpack,
    SetiIconColor.blue
  ),
  "webpack.config.build.mjs": (
    "webpack",
    SetiUiIcons.webpack,
    SetiIconColor.blue
  ),
  "webpack.config.build.ts": (
    "webpack",
    SetiUiIcons.webpack,
    SetiIconColor.blue
  ),
  "webpack.common.js": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.common.cjs": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.common.mjs": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.common.ts": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.dev.js": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.dev.cjs": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.dev.mjs": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.dev.ts": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.prod.js": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.prod.cjs": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.prod.mjs": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
  "webpack.prod.ts": ("webpack", SetiUiIcons.webpack, SetiIconColor.blue),
 */
// MISC SETTING
  ".direnv": ("config", SetiUiIcons.config, SetiIconColor.greyLight),
  ".env": ("config", SetiUiIcons.config, SetiIconColor.greyLight),
  ".static": ("config", SetiUiIcons.config, SetiIconColor.greyLight),
  ".editorconfig": ("config", SetiUiIcons.config, SetiIconColor.greyLight),
  ".slugignore": ("config", SetiUiIcons.config, SetiIconColor.greyLight),
  ".tmp": ("clock", SetiUiIcons.clock, SetiIconColor.greyLight),
  ".htaccess": ("config", SetiUiIcons.config, SetiIconColor.greyLight),
  ".key": ("lock", SetiUiIcons.lock, SetiIconColor.green),
  ".cert": ("lock", SetiUiIcons.lock, SetiIconColor.green),
  ".cer": ("lock", SetiUiIcons.lock, SetiIconColor.green),
  ".crt": ("lock", SetiUiIcons.lock, SetiIconColor.green),
  ".pem": ("lock", SetiUiIcons.lock, SetiIconColor.green),

// LICENSE FILES
  "LICENSE": ("license", SetiUiIcons.license, SetiIconColor.yellow),
  "LICENCE": ("license", SetiUiIcons.license, SetiIconColor.yellow),
  "LICENSE.txt": ("license", SetiUiIcons.license, SetiIconColor.yellow),
  "LICENCE.txt": ("license", SetiUiIcons.license, SetiIconColor.yellow),
  "LICENSE.md": ("license", SetiUiIcons.license, SetiIconColor.yellow),
  "LICENCE.md": ("license", SetiUiIcons.license, SetiIconColor.yellow),
  "COPYING": ("license", SetiUiIcons.license, SetiIconColor.yellow),
  "COPYING.txt": ("license", SetiUiIcons.license, SetiIconColor.yellow),
  "COPYING.md": ("license", SetiUiIcons.license, SetiIconColor.yellow),
  "COMPILING": ("license", SetiUiIcons.license, SetiIconColor.orange),
  "COMPILING.txt": ("license", SetiUiIcons.license, SetiIconColor.orange),
  "COMPILING.md": ("license", SetiUiIcons.license, SetiIconColor.orange),
  "CONTRIBUTING": ("license", SetiUiIcons.license, SetiIconColor.red),
  "CONTRIBUTING.txt": ("license", SetiUiIcons.license, SetiIconColor.red),
  "CONTRIBUTING.md": ("license", SetiUiIcons.license, SetiIconColor.red),

// MAKEFILES
  "MAKEFILE": ("makefile", SetiUiIcons.makefile, SetiIconColor.orange),
  "Makefile": ("makefile", SetiUiIcons.makefile, SetiIconColor.orange),
  "makefile": ("makefile", SetiUiIcons.makefile, SetiIconColor.orange),
  "QMAKEFILE": ("makefile", SetiUiIcons.makefile, SetiIconColor.purple),
  "QMakefile": ("makefile", SetiUiIcons.makefile, SetiIconColor.purple),
  "qmakefile": ("makefile", SetiUiIcons.makefile, SetiIconColor.purple),
  "OMAKEFILE": ("makefile", SetiUiIcons.makefile, SetiIconColor.greyLight),
  "OMakefile": ("makefile", SetiUiIcons.makefile, SetiIconColor.greyLight),
  "omakefile": ("makefile", SetiUiIcons.makefile, SetiIconColor.greyLight),
  "CMAKELISTS.TXT": ("makefile", SetiUiIcons.makefile, SetiIconColor.blue),
  "CMAKELISTS.txt": ("makefile", SetiUiIcons.makefile, SetiIconColor.blue),
  "CMakeLists.txt": ("makefile", SetiUiIcons.makefile, SetiIconColor.blue),
  "cmakelists.txt": ("makefile", SetiUiIcons.makefile, SetiIconColor.blue),

// PROCFILE
  "Procfile": ("heroku", SetiUiIcons.heroku, SetiIconColor.purple),

// TODO
/*   "TODO": ("todo", SetiUiIcons.todo, SetiIconColor.seti_primary),
  "TODO.txt": ("todo", SetiUiIcons.todo, SetiIconColor.seti_primary),
  "TODO.md": ("todo", SetiUiIcons.todo, SetiIconColor.seti_primary),
 */
// - - - - - - -
// IGNORED FILES
// - - - - - - -

  "npm-debug.log": (
    "npm_ignored",
    SetiUiIcons.npm_ignored,
    SetiIconColor.ignore
  ),
  ".DS_Store": ("ignored", SetiUiIcons.ignored, SetiIconColor.ignore),

  "unknown": ("unknown", SetiUiIcons.default_icon, SetiIconColor.white),
};
