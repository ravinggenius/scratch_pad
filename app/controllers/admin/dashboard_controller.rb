class Admin::DashboardController < Admin::ApplicationController
  def index
    @node_count = Node.count
    @vocabulary_count = Vocabulary.count
    @term_count = Term.count
  end
end
