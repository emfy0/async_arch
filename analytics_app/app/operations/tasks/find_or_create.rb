module Tasks
  class FindOrCreate
    TASK_PARAMS = %i[
      public_id
      name
      description
    ].freeze

    def call(params)
      user_id = User.where(public_id: params[:user_public_id]).pluck(:id).first

      current_params = params.slice(*TASK_PARAMS)

      task_params = Task.upsert(
        {
          **current_params,
          user_id:,
          reward: rand(20..40),
          penalty: rand(10..20)
        },
        unique_by: :public_id,
        update_only: current_params.keys,
        returning: Arel.star
      )

      Success(
        Task.new(task_params.to_a.first).tap { _1.instance_variable_set(:@new_record, false) }
      )
    end
  end
end
