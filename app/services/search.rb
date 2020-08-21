class Search
  # https://freelancing-gods.com/thinking-sphinx/v5/searching.html

  def initialize(context, query)
    @context = context
    @query = ThinkingSphinx::Query.escape(query)
  end

  def call
    model = @context == 'All' ? ThinkingSphinx : @context.classify.constantize
    model.search(@query)
  end
end
