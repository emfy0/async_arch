json.task do
  json.public_id task.public_id
  json.name task.name
  json.jira_id task.jira_id
  json.description task.description

  json.user do
    json.public_id task.user.public_id
  end
end
