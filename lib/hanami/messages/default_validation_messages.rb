Hanami::Validations::ValidationMessagesLibrary.configure do
  message_at :presence do |error|
    "can not be left blank"
  end

  message_at :acceptance do |error|
    "must be accepted"
  end

  message_at :confirmation do |error|
    "doesn't match"
  end

  message_at :inclusion do |error|
    "isn't included"
  end

  message_at :exclusion do |error|
    "shouldn't belong to #{ Array(error.expected).join(', ') }"
  end

  message_at :format do |error|
    "doesn't match expected format"
  end

  message_at :size do |error|
    "doesn't match expected size"
  end
end