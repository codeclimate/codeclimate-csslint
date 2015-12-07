module CC
  module Engine
    class CSSlint
      # https://github.com/CSSLint/csslint/wiki/Rules
      class CheckDetails
        DEFAULT_CATEGORY = "Style".freeze
        DEFAULT_REMEDIATION_POINTS = 50_000.freeze

        attr_reader :categories, :remediation_points

        def self.all
          @all ||= {
            "net.csslint.Adjoiningclasses" => new(categories: "Compatability"),
            "net.csslint.Boxmodel" => new(categories: "Bug Risk"),
            "net.csslint.Boxsizing" => new(categories: "Compatability"),
            "net.csslint.Bulletprooffontface" => new(categories: "Compatability"),
            "net.csslint.Compatiblevendorprefixes" => new(categories: "Compatability"),
            "net.csslint.Displaypropertygrouping" => new(categories: "Bug Risk"),
            "net.csslint.Duplicatebackgroundimages" => new(categories: "Bug Risk"),
            "net.csslint.Duplicateproperties" => new(categories: "Bug Risk"),
            "net.csslint.Emptyrules" => new(categories: "Bug Risk"),
            "net.csslint.Fallbackcolors" => new(categories: "Compatability"),
            "net.csslint.Fontfaces" => new(categories: "Bug Risk"),
            "net.csslint.Gradients" => new(categories: "Compatability"),
            "net.csslint.Import" => new(categories: "Bug Risk"),
            "net.csslint.Knownproperties" => new(categories: "Bug Risk"),
            "net.csslint.Overqualifiedelements" => new(categories: "Bug Risk"),
            "net.csslint.Regexselectors" => new(categories: "Bug Risk"),
            "net.csslint.Shorthand" => new(categories: "Bug Risk"),
            "net.csslint.Starpropertyhack" => new(categories: "Compatability"),
            "net.csslint.Textindent" => new(categories: "Compatability"),
            "net.csslint.Underscorepropertyhack" => new(categories: "Compatability"),
            "net.csslint.Uniqueheadings" => new(categories: "Duplication"),
            "net.csslint.Universalselector" => new(categories: "Bug Risk"),
            "net.csslint.Unqualifiedattributes" => new(categories: "Bug Risk"),
            "net.csslint.Vendorprefix" => new(categories: "Compatability"),
            "net.csslint.Zerounits" => new(categories: "Bug Risk"),
          }
        end

        def self.fetch(check_name)
          all.fetch(check_name) { new }
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
