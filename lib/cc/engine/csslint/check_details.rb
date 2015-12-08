module CC
  module Engine
    class CSSlint
      class CheckDetails
        ALL_RULES = {
          # https://github.com/CSSLint/csslint/wiki/Rules
          "net.csslint.Bewareofbrokenboxsize" => { categories: "Bug Risk" },
          "net.csslint.Disallow@import" => { categories: "Bug Risk" },
          "net.csslint.Disallowadjoiningclasses" => { categories: "Compatibility" },
          "net.csslint.Disallowduplicatebackgroundimages" => { categories: "Bug Risk" },
          "net.csslint.Disallowduplicateproperties" => { categories: "Bug Risk" },
          "net.csslint.Disallowemptyrules" => { categories: "Bug Risk" },
          "net.csslint.Disallownegativetext-indent" => { categories: "Compatibility" },
          "net.csslint.Disallowoverqualifiedelements" => { categories: "Bug Risk" },
          "net.csslint.Disallowpropertieswithanunderscoreprefix" => { categories: "Compatibility" },
          "net.csslint.Disallowpropertieswithastarprefix" => { categories: "Compatibility" },
          "net.csslint.Disallowselectorsthatlooklikeregexs" => { categories: "Bug Risk" },
          "net.csslint.Disallowunitsfor0values" => { categories: "Bug Risk" },
          "net.csslint.Disallowuniversalselector" => { categories: "Bug Risk" },
          "net.csslint.Disallowunqualifiedattributeselectors" => { categories: "Bug Risk" },
          "net.csslint.Disallowuseofbox-sizing" => { categories: "Compatibility" },
          "net.csslint.Don'tusetoomanywebfonts" => { categories: "Bug Risk" },
          "net.csslint.Headingsshouldonlybedefinedonce" => { categories: "Duplication" },
          "net.csslint.Requireallgradientdefinitions" => { categories: "Compatibility" },
          "net.csslint.Requirecompatiblevendorprefixes" => { categories: "Compatibility" },
          "net.csslint.Requirefallbackcolors" => { categories: "Compatibility" },
          "net.csslint.Requirepropertiesappropriatefordisplay" => { categories: "Bug Risk" },
          "net.csslint.Requireshorthandproperties" => { categories: "Bug Risk" },
          "net.csslint.Requirestandardpropertywithvendorprefix" => { categories: "Compatibility" },
          "net.csslint.Requireuseofknownproperties" => { categories: "Bug Risk" },
          "net.csslint.Usethebulletproof@font-facesyntax" => { categories: "Compatibility" },
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
