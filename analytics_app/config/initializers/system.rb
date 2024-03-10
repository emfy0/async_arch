# frozen_string_literal: true

container = Dry::Container.new
AnalyticsApp::CONTAINER = container

AnalyticsApp::Import = Dry::AutoInject(container)

def auto_register(category, base: 'app')
  base = Rails.root.join(base)
  root_dir = File.join(base, category)
  all_files = Dir[File.join(root_dir, '**/*.rb')]

  container = AnalyticsApp::CONTAINER

  all_files.sort_by { |f| f.count('/') }.each do |path|
    path = path.sub('.rb', '')
    subpath = path.sub("#{root_dir}/", '')

    require path

    key = subpath.gsub('/', '.')

    const_name = key.split('.')
      .map(&:camelize)
      .join('::')
      .constantize

    container.register(key, -> { const_name.new })
  end
end

Rails.configuration.to_prepare do
  auto_register('operations')
  auto_register('transactions')
rescue Dry::Container::Error => e
  raise e unless Rails.env.development?
  raise e unless e.message.include?('already an item registered')
end
