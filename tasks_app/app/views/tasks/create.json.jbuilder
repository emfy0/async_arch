respond_with_success(json, nil) do
  json.task do
    json.partial! 'tasks/task', task: @task
  end
end
