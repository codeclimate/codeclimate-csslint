"use strict";

const fs = require("fs");
const path = require("path");
const glob = require("glob");
const CSSLint = require("csslint/dist/csslint-node").CSSLint;
const CodeClimateFormatter = require("./codeclimate-formatter");

const DEFAULT_EXTENSIONS = [".css"];

CSSLint.addFormatter(CodeClimateFormatter);

function readFile(filename) {
  try {
    return fs.readFileSync(filename, "utf-8");
  } catch (ex) {
    return "";
  }
}


class Analyzer {
  constructor(directory, console, config) {
    this.directory = directory;
    this.console = console;
    this.config = config;
  }

  run() {
    let files = this.expandPaths(this.config.include_paths || ["./"]);

    this.processFiles(files);
  }


  // private =================================================================


  print(message) {
    this.console.log(message);
  }

  processFile(relativeFilePath) {
    let input = readFile(path.join(this.directory, relativeFilePath));
    let formatter = CSSLint.getFormatter("codeclimate");

    if (!input) {
      this.print(formatter.readError(relativeFilePath, "Could not read file data. Is the file empty?"));
    } else {
      let result = CSSLint.verify(input);
      let messages = result.messages || [];
      let output = formatter.formatResults(result, relativeFilePath);
      if (output) {
        this.print(output);
      }
    }
  }


  processFiles(files) {
    for (let file of files) {
      this.processFile(file);
    }
  }


  expandPaths(paths) {
    let files = [];

    for (let path of paths) {
      let new_files = this.getFiles(path, this.directory);
      files = files.concat(new_files);
    }

    return files;
  }

  getFiles(pathname) {
    var files = [];
    let full_pathname = path.normalize(path.join(this.directory, pathname));
    let stat;
    let base_name = path.basename(pathname);

    try {
      stat = fs.statSync(full_pathname);
    } catch (ex) {
      return [];
    }

    if (stat.isFile() && this.extensionsRegExp.test(full_pathname)) {
      return [pathname];
    } else if (stat.isDirectory()) {
        for (let file of fs.readdirSync(full_pathname)) {
          let new_path = path.join(full_pathname, file);
          files = files.concat(this.getFiles(path.relative(this.directory, new_path)));
        };
    }

    return files;
  }

  get extensionsRegExp() {
    return RegExp(
      (this.config.extensions || DEFAULT_EXTENSIONS).
        map(e => e.replace('.', '\\.')).
        join("|") +
        "$"
    );
  }
}

module.exports = class {
  constructor(directory, console, config) {
    this.analyzer = new Analyzer(directory, console, config);
  }

  run() {
    this.analyzer.run();
  }
};
