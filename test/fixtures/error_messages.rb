{
  en: {
    acceptance_validator_test: {
      tos: {
        acceptance: "Please accept our Terms of Service"
      }
    },
    nested_validations: {
      address: {
        post_code: {
          format: "Post code must be of five numbers"
        }
      }
    },
    custom_validator_test: {
      age: {
        inclusion: "%{attribute} should be between %{expected} and got %{actual}"
      }
    }
  },

  it: {
    acceptance_validator_test: {
      tos: {
        acceptance: "Per favore accetta i nostri termini di servizio"
      }
    }
  }
}
