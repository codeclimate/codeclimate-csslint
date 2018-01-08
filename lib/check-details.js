// https://github.com/CSSLint/csslint/wiki/Rules
const ALL_RULES = {
  "adjoining-classes": "Compatibility",
  "box-model": "Bug Risk",
  "box-sizing": "Compatibility",
  "bulletproof-font-face": "Compatibility",
  "compatible-vendor-prefixes": "Compatibility",
  "display-property-grouping": "Bug Risk",
  "duplicate-background-images": "Performance",
  "duplicate-properties": "Bug Risk",
  "empty-rules": "Bug Risk",
  "fallback-colors": "Compatibility",
  "floats": "Clarity",
  "font-faces": "Performance",
  "font-sizes": "Clarity",
  "gradients": "Compatibility",
  "ids": "Complexity",
  "import": "Performance",
  "important": "Complexity",
  "known-properties": "Bug Risk",
  "overqualified-elements": "Performance",
  "parse-error": "Bug Risk",
  "regex-selectors": "Performance",
  "shorthand": "Performance",
  "star-property-hack": "Compatibility",
  "text-indent": "Compatibility",
  "underscore-property-hack": "Compatibility",
  "unique-headings": "Duplication",
  "universal-selector": "Performance",
  "unqualified-attributes": "Performance",
  "vendor-prefix": "Compatibility",
  "zero-units": "Performance"
};

const DEFAULT_CATEGORY = "Style";
const DEFAULT_REMEDIATION_POINTS = 50000;

module.exports = function(check_name) {
  let category = ALL_RULES[check_name] || DEFAULT_CATEGORY;
  return {
    categories: [category],
    remediation_points: DEFAULT_REMEDIATION_POINTS
  };
};
