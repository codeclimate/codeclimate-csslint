module CC
  module Engine
    class CSSlint
      class CheckDetails
        ALL_RULES = {
          # https://github.com/CSSLint/csslint/wiki/Rules
          "net.csslint.Adjoiningclasses" => { categories: "Compatability" },
          "net.csslint.Boxmodel" => { categories: "Bug Risk" },
          "net.csslint.Boxsizing" => { categories: "Compatability" },
          "net.csslint.Bulletprooffontface" => { categories: "Compatability" },
          "net.csslint.Compatiblevendorprefixes" => { categories: "Compatability" },
          "net.csslint.Displaypropertygrouping" => { categories: "Bug Risk" },
          "net.csslint.Duplicatebackgroundimages" => { categories: "Bug Risk" },
          "net.csslint.Duplicateproperties" => { categories: "Bug Risk" },
          "net.csslint.Emptyrules" => { categories: "Bug Risk" },
          "net.csslint.Fallbackcolors" => { categories: "Compatability" },
          "net.csslint.Fontfaces" => { categories: "Bug Risk" },
          "net.csslint.Gradients" => { categories: "Compatability" },
          "net.csslint.Import" => { categories: "Bug Risk" },
          "net.csslint.Knownproperties" => { categories: "Bug Risk" },
          "net.csslint.Overqualifiedelements" => { categories: "Bug Risk" },
          "net.csslint.Regexselectors" => { categories: "Bug Risk" },
          "net.csslint.Shorthand" => { categories: "Bug Risk" },
          "net.csslint.Starpropertyhack" => { categories: "Compatability" },
          "net.csslint.Textindent" => { categories: "Compatability" },
          "net.csslint.Underscorepropertyhack" => { categories: "Compatability" },
          "net.csslint.Uniqueheadings" => { categories: "Duplication" },
          "net.csslint.Universalselector" => { categories: "Bug Risk" },
          "net.csslint.Unqualifiedattributes" => { categories: "Bug Risk" },
          "net.csslint.Vendorprefix" => { categories: "Compatability" },
          "net.csslint.Zerounits" => { categories: "Bug Risk" },
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
