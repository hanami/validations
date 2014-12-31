class AttributeSet
  VALIDATIONS = [:presence, :acceptance, :format, :inclusion, :exclusion, :confirmation, :size, :type, :writable].freeze

  def initialize
    @attributes = Hash.new {|h,k| h[k] = {} }
  end

  def add(name, options)
    @attributes[name.to_sym].merge!(
      validate_options!(name, options)
    )
  end

  def each(&blk)
    @attributes.each(&blk)
  end

  def iterate(attributes, &blk)
    if @attributes.any?
      @attributes.each(&blk)
    else
      attributes.each do |name, _|
        blk.call(name, {})
      end
    end
  end

  private
  # Checks at the loading time if the user defined validations are recognized
  #
  # @param name [Symbol] the attribute name
  # @param options [Hash] the set of validations associated with the given attribute
  #
  # @raise [ArgumentError] if at least one of the validations are not
  #   recognized
  #
  # @since 0.2.0
  # @api private
  def validate_options!(name, options)
    if (unknown = (options.keys - VALIDATIONS)) && unknown.any?
      raise ArgumentError.new(%(Unknown validation(s): #{ unknown.join ', ' } for "#{ name }" attribute))
    end

    # FIXME remove
    if options[:confirmation]
      add(:"#{ name }_confirmation", {})
    end

    options
  end
end
