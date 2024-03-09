module WithinAdapters
  def within_db_transaction(input)
    result = nil

    ApplicationRecord.transaction do
      result = super(input)
      raise ActiveRecord::Rollback if result.failure?
    end

    result
  end
end
