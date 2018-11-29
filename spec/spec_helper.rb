$LOAD_PATH.unshift "lib"
require "hanami/utils"
require "hanami/devtools/unit"
require "hanami/validations"
require "hanami/validations/params"

Hanami::Utils.require!("spec/support")
Hanami::Utils.require!("spec/shared")
