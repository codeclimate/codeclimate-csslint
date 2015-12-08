module CC
  module Engine
    class CSSlint
      class CheckDetails
        ALL_RULES = {
          # https://github.com/CSSLint/csslint/wiki/Rules
          "adjoining-classes" => { categories: "Compatibility" },
          "box-model" => { categories: "Bug Risk" },
          "box-sizing" => { categories: "Compatibility" },
          "bulletproof-font-face" => { categories: "Compatibility" },
          "compatible-vendor-prefixes" => { categories: "Compatibility" },
          "display-property-grouping" => { categories: "Bug Risk" },
          "duplicate-background-images" => { categories: "Bug Risk" },
          "duplicate-properties" => { categories: "Bug Risk" },
          "empty-rules" => { categories: "Bug Risk" },
          "fallback-colors" => { categories: "Compatibility" },
          "font-faces" => { categories: "Bug Risk" },
          "gradients" => { categories: "Compatibility" },
          "import" => { categories: "Bug Risk" },
          "known-properties" => { categories: "Bug Risk" },
          "overqualified-elements" => { categories: "Bug Risk" },
          "regex-selectors" => { categories: "Bug Risk" },
          "shorthand" => { categories: "Bug Risk" },
          "star-property-hack" => { categories: "Compatibility" },
          "text-indent" => { categories: "Compatibility" },
          "underscore-property-hack" => { categories: "Compatibility" },
          "unique-headings" => { categories: "Duplication" },
          "universal-selector" => { categories: "Bug Risk" },
          "unqualified-attributes" => { categories: "Bug Risk" },
          "vendor-prefix" => { categories: "Compatibility" },
          "zero-units" => { categories: "Bug Risk" },
        }.freeze

        DEFAULT_CATEGORY = "Style".freeze
        DEFAULT_REMEDIATION_POINTS = 50_000.freeze

        attr_reader :categories, :remediation_points

        def self.fetch(check_name)
          new(ALL_RULES.fetch(check_name, {}))
        end

        def initialize(
          categories: DEFAULT_CATEGORY,
          remediation_points: DEFAULT_REMEDIATION_POINTS
        )
          @categories = Array(categories)
          @remediation_points = remediation_points
        end
      end
    end
  end
end
