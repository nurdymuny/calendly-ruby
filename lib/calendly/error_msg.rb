class Calendly::ErrorMsg < StandardError

  def initialize(msg="", errors={})
    @errors = errors
    super(msg)
  end
end