const Engine = require("../lib/csslint");
const expect = require("chai").expect;
const CSSLint = require("csslint/dist/csslint-node").CSSLint;
const temp = require('temp').track();
const fs = require("fs");
const path = require("path");
const mkdirp = require('mkdirp').sync;

class FakeConsole {
  constructor() {
    this.logs = [];
    this.warns = [];
  }

  get output() {
    return this.logs.join("\n");
  }


  log(str) {
    this.logs.push(str);
  }

  warn(str) {
    console.warn(str);
    this.warns.push(str);
  }
}


function createSourceFile(root, filename, content) {
  let dirname = path.dirname(path.join(root, filename));
  if (!fs.existsSync(dirname)) {
    mkdirp(dirname);
  }
  fs.writeFileSync(path.join(root, filename), content);
}

describe("CSSLint Engine", function() {
  beforeEach(function(){
    this.id_selector_content = "#id { color: red; }";
    this.code_dir = temp.mkdirSync("code");
    this.console = new FakeConsole();
    this.lint = new Engine(this.code_dir, this.console, {});
  });

  it('analyzes *.css files', function() {
    createSourceFile(this.code_dir, 'foo.css', this.id_selector_content);

    this.lint.run();
    expect(this.console.output).to.include("Don't use IDs in selectors.");
  });

  it('fails on malformed file', function() {
    createSourceFile(this.code_dir, 'foo.css', '�6�');

    this.lint.run();
    expect(this.console.output).to.include('Unexpected token');
  });

  it("doesn't analyze *.scss files", function() {
    createSourceFile(this.code_dir, 'foo.scss', this.id_selector_content);

    this.lint.run();
    expect(this.console.output).to.eq('');
  });

  it("only reports issues in the file where they're present", function() {
    createSourceFile(this.code_dir, 'bad.css', this.id_selector_content);
    createSourceFile(this.code_dir, 'good.css', '.foo { margin: 0 }');

    this.lint.run();
    expect(this.console.output).to.not.include('good.css');
  });

  context("with include_paths", function(){
    beforeEach(function() {
      let engine_config = {
        include_paths: ["included.css", "included_dir/", "config.yml"]
      };
      this.lint = new Engine(this.code_dir, this.console, engine_config);

      createSourceFile(this.code_dir, "included.css", this.id_selector_content);
      createSourceFile(this.code_dir, "included_dir/file.css", "p { color: blue !important; }");
      createSourceFile(this.code_dir, "included_dir/sub/sub/subdir/file.css", "img { }");
      createSourceFile(this.code_dir, "config.yml", "foo:\n  bar: \"baz\"");
      createSourceFile(this.code_dir, "not_included.css", "a { outline: none; }");
    });

    it("includes all mentioned files", function() {
      this.lint.run();
      expect(this.console.output).to.include("Don't use IDs in selectors.");
    });

    it("expands directories", function() {
      this.lint.run();
      expect(this.console.output).to.include('Use of !important');
      expect(this.console.output).to.include('Rule is empty');
    });

    it("excludes any unmentioned files", function() {
      this.lint.run();
      expect(this.console.output).to.not.include('Outlines should only be modified using :focus');
    });

    it("only includes CSS files, even when a non-CSS file is directly included", function() {
      this.lint.run();
      expect(this.console.output).to.not.include('config.yml');
    });
  });

  context("with custom extensions", function(){
    beforeEach(function() {
      let engine_config = {
        extensions: [".fancycss"]
      };
      this.lint = new Engine(this.code_dir, this.console, engine_config);

      createSourceFile(this.code_dir, "master.fancycss", this.id_selector_content);
    });

    it("takes into account extensions", function() {
      this.lint.run();
      expect(this.console.output).to.include("Don't use IDs in selectors.");
    });
  });
});
