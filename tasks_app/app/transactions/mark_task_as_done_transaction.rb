class MarkTaskAsDoneTransaction < BaseTransaction
  request_schema do
    hash_schema(
      token: string,
      id: string
    )
  end

  remap_schema(
    task_id: :id
  )

  map  :unwrap
  step :typecast
  step :validate_ststion_token, with: 'users.retrieve_user'
  step :find_task
  step :mark_task_as_done
  tee  :broadcast

  def find_task(input)
    input in user:

    task = user.tasks.find_by(id: input[:task_id], completed: false)

    if task
      Success(input.merge!(task:))
    else
      Failure(:not_found)
    end
  end

  def mark_task_as_done(input)
    input[:task].update!(completed: true)

    Success(input)
  end

  def broadcast(input)
    BaseProducer.(:tasks_stream, :task_completed, task: input[:task])
  end
end

