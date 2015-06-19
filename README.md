# Code Climate CSSLint Engine

[![Code Climate](https://codeclimate.com/repos/558419b6e30ba012290173f6/badges/85c90e6df38db8a9492d/gpa.svg)](https://codeclimate.com/repos/558419b6e30ba012290173f6/feed)

`codeclimate-csslint` is a Code Climate engine that wraps [CSSLint](https://github.com/CSSLint/csslint). You can run it on your command line using the Code Climate CLI, or on our hosted analysis platform.

CSSLint helps point out problems with your CSS code. It does basic syntax checking as well as applying a set of rules that look for problematic patterns or signs of inefficiency. Each rule is pluggable, so you can easily write your own or omit ones you don't want.

### Installation

1. If you haven't already, [install the Code Climate CLI](https://github.com/codeclimate/codeclimate).
2. Run `codeclimate engines:enable csslint`. This command both installs the engine and enables it in your `.codeclimate.yml` file.
3. You're ready to analyze! Browse into your project's folder and run `codeclimate analyze`.

### Need help?

For help with CSSLint, [check out their documentation](https://github.com/CSSLint/csslint).

If you're running into a Code Climate issue, first look over this project's [GitHub Issues](https://github.com/codeclimate/codeclimate-csslint/issues), as your question may have already been covered. If not, [go ahead and open a support ticket with us](https://codeclimate.com/help).
